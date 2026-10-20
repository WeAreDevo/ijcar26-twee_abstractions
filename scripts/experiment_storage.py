"""Compact proof-shortening checkpoints and verified archival of stopped runs."""
from contextlib import contextmanager
import fcntl
import gzip
import hashlib
import json
import os
from pathlib import Path
import shutil
import tarfile
import tempfile
from functools import lru_cache

from src.stitch.pipeline.checkpoints import atomic_json


@contextmanager
def suite_access(suite, maintenance=False):
    """Prevent compacting a suite while this runner is using it."""
    with (Path(suite) / 'activity.lock').open('a') as stream:
        try:
            fcntl.flock(stream, (fcntl.LOCK_EX if maintenance else fcntl.LOCK_SH) | fcntl.LOCK_NB)
        except BlockingIOError as exc:
            raise RuntimeError('Suite is in use; compaction requires all its jobs to stop') from exc
        try:
            yield
        finally:
            fcntl.flock(stream, fcntl.LOCK_UN)


class ResultStore:
    """One atomic JSON per batch; a single stable lock coordinates all writers.

    flock protects read-modify-replace across threads and processes. Readers
    need no lock because JSON files are replaced atomically. Legacy per-problem
    files remain readable until a stopped suite is explicitly compacted.
    """
    def __init__(self, suite, method, shard=0):
        self.suite = Path(suite)
        self.method = method
        self.path = self.suite / 'checkpoints' / method / f'{shard}.json'

    @contextmanager
    def locked(self):
        self.suite.mkdir(parents=True, exist_ok=True)
        with (self.suite / 'checkpoints.lock').open('a') as lock:
            fcntl.flock(lock, fcntl.LOCK_EX)
            try:
                yield
            finally:
                fcntl.flock(lock, fcntl.LOCK_UN)

    def read(self):
        return json.loads(self.path.read_text()) if self.path.exists() else {'results': {}}

    def get(self, problem):
        row = self.read()['results'].get(problem)
        legacy = self.suite / 'results' / self.method / f'{problem}.json'
        return row if row is not None else json.loads(legacy.read_text()) if legacy.exists() else None

    def save(self, row):
        with self.locked():
            document = self.read()
            document['results'][row['problem']] = row
            atomic_json(self.path, document)

    def progress(self, state):
        with self.locked():
            document = self.read()
            document['run_state'] = state
            atomic_json(self.path, document)


def read_results(suite, method):
    suite = Path(suite)
    rows = {p.stem: json.loads(p.read_text()) for p in (suite / 'results' / method).glob('*.json')}
    for path in sorted((suite / 'checkpoints' / method).glob('*.json')):
        rows.update(json.loads(path.read_text())['results'])
    return rows


def write_inputs(suite, inputs):
    path = Path(suite) / 'krympa_inputs.json.gz'
    fd, temporary = tempfile.mkstemp(prefix='.inputs.', dir=path.parent)
    try:
        with os.fdopen(fd, 'wb') as stream:
            with gzip.GzipFile(fileobj=stream, mode='wb', mtime=0) as zipped:
                zipped.write(json.dumps(inputs, sort_keys=True).encode())
            stream.flush()
            os.fsync(stream.fileno())
        with gzip.open(temporary, 'rt') as stream:
            if json.load(stream) != inputs:
                raise ValueError('Input bundle failed verification')
        os.replace(temporary, path)
    finally:
        if os.path.exists(temporary):
            os.unlink(temporary)


@lru_cache(maxsize=4)
def _read_inputs(path, modified):
    with gzip.open(path, 'rt') as stream:
        return json.load(stream)


def read_input(suite, problem):
    path = Path(suite) / 'krympa_inputs.json.gz'
    if path.exists():
        return _read_inputs(str(path), path.stat().st_mtime_ns)[problem['problem']]
    return Path(problem['krympa_input']).read_text()


def _inventory(roots):
    """Snapshot bytes and symlink targets without following directory symlinks."""
    records = {}
    def fail(error):
        raise error
    for root in roots:
        if not root.is_dir() or root.is_symlink():
            raise ValueError(f'Expected a real source directory: {root}')
        for parent, dirs, files in os.walk(root, followlinks=False, onerror=fail):
            for name in dirs + files:
                path = Path(parent) / name
                relative = str(path.relative_to(root.parent))
                if path.is_symlink():
                    records[relative] = ('link', os.readlink(path))
                elif path.is_file():
                    with path.open('rb') as stream:
                        records[relative] = ('file', stream_hash(stream))
                elif path.is_dir():
                    records[relative] = ('dir', '')
                else:
                    raise ValueError(f'Unsupported filesystem object: {path}')
        records[root.name] = ('dir', '')
    return records


def stream_hash(stream):
    digest = hashlib.sha256()
    for block in iter(lambda: stream.read(1024 * 1024), b''):
        digest.update(block)
    return digest.hexdigest()


def archive_inventory(path):
    records = {}
    with tarfile.open(path, 'r:gz') as archive:
        for member in archive:
            if member.name in records:
                raise ValueError(f'Duplicate archive member: {member.name}')
            if member.isfile() or member.islnk():
                with archive.extractfile(member) as stream:
                    records[member.name] = ('file', stream_hash(stream))
            elif member.issym():
                records[member.name] = ('link', member.linkname)
            elif member.isdir():
                records[member.name] = ('dir', '')
            else:
                raise ValueError(f'Unsupported archive member: {member.name}')
    return records


def fsync_directory(path):
    directory_fd = os.open(path, os.O_RDONLY | os.O_DIRECTORY)
    try:
        os.fsync(directory_fd)
    finally:
        os.close(directory_fd)


def publish_archive(root, destination):
    """Publish a verified snapshot atomically; keep source and old archive on error.

    Used twice for Twitch: after the base and after the local phase. Hashing is
    streamed so even large prover logs do not have to fit in RAM.
    """
    root, destination = Path(root), Path(destination)
    destination.parent.mkdir(parents=True, exist_ok=True)
    before = _inventory([root])
    fd, temporary = tempfile.mkstemp(prefix='.' + destination.name + '.', suffix='.partial',
                                     dir=destination.parent)
    try:
        with os.fdopen(fd, 'wb') as stream:
            with tarfile.open(fileobj=stream, mode='w:gz', compresslevel=1) as archive:
                archive.add(root, arcname=root.name)
            stream.flush()
            os.fsync(stream.fileno())
        if archive_inventory(temporary) != before or _inventory([root]) != before:
            raise ValueError('Archive verification failed or files changed; sources preserved')
        os.replace(temporary, destination)
        fsync_directory(destination.parent)
    finally:
        if os.path.exists(temporary):
            os.unlink(temporary)
    return len(before)


def read_artifact(path):
    """Read a loose UTF-8 artifact or its closest archived ancestor.

    Example: attempt/base/P.txt is read from attempt.tar.gz, member
    attempt/base/P.txt, after that attempt's working directory is compacted.
    Only a single regular file is read; tar extraction to disk is not needed.
    """
    path = Path(path)
    try:
        return path.read_text()
    except (FileNotFoundError, NotADirectoryError):
        pass
    for ancestor in path.parents:
        if not ancestor.name:
            break
        archive_path = ancestor.with_name(ancestor.name + '.tar.gz')
        try:
            stream = archive_path.open('rb')
        except FileNotFoundError:
            continue
        member_name = str(path.relative_to(ancestor.parent))
        with stream, tarfile.open(fileobj=stream, mode='r:gz') as archive:
            try:
                member = archive.getmember(member_name)
            except KeyError:
                continue
            if not member.isfile():
                raise ValueError(f'Expected a regular artifact: {archive_path}:{member_name}')
            with archive.extractfile(member) as contents:
                return contents.read().decode('utf-8')
    raise FileNotFoundError(f'No loose or archived artifact: {path}')


def archive_and_remove(roots, destination):
    """Archive specific stopped working trees, verify all bytes, then remove.

    All roots must be siblings. The archive is published and fsynced before any
    input is removed. Existing archives are verified rather than overwritten.
    """
    roots = [Path(root).resolve() for root in roots if Path(root).exists()]
    if not roots:
        return 0
    destination = Path(destination).resolve()
    if len({p.parent for p in roots}) != 1:
        raise ValueError('Archive roots must be siblings')
    if any(destination.is_relative_to(p) for p in roots):
        raise ValueError('Archive must be outside the trees being removed')
    before = _inventory(roots)
    if not destination.exists():
        temporary = destination.with_name(destination.name + '.partial')
        with tarfile.open(temporary, 'w:gz') as archive:
            for root in roots:
                archive.add(root, arcname=root.name, recursive=True)
        with temporary.open('rb') as stream:
            os.fsync(stream.fileno())
        verify_path = temporary
    else:
        verify_path = destination
    verified = archive_inventory(verify_path)
    if any(verified.get(k) != value for k, value in before.items()) or _inventory(roots) != before:
        raise ValueError('Archive verification failed or files changed; originals preserved')
    if verify_path != destination:
        os.replace(verify_path, destination)
    fsync_directory(destination.parent)
    for root in roots:
        shutil.rmtree(root)
    return len(before)


def compact_suite(suite, manifest, methods):
    """Migrate a stopped suite without changing result contents or input bytes."""
    suite = Path(suite)
    inputs = {p['problem']: read_input(suite, p) for p in manifest['problems']}
    for p in manifest['problems']:
        if hashlib.sha256(inputs[p['problem']].encode()).hexdigest() != p['krympa_sha256']:
            raise ValueError(f"Input hash mismatch: {p['problem']}")
    write_inputs(suite, inputs)
    index = {p['problem']: i // manifest['batch_size'] for i, p in enumerate(manifest['problems'])}
    total = 0
    for method in methods:
        rows = read_results(suite, method)
        groups = {}
        for name, row in rows.items():
            groups.setdefault(index[name], {})[name] = row
        for shard, batch in groups.items():
            store = ResultStore(suite, method, shard)
            with store.locked():
                document = store.read()
                document['results'].update(batch)
                legacy_state = suite / 'shards' / method / str(shard) / 'run_state.json'
                if legacy_state.exists():
                    document['run_state'] = json.loads(legacy_state.read_text())
                atomic_json(store.path, document)
        if read_results(suite, method) != rows:
            raise ValueError('Result migration changed the records; originals preserved')
        # Check the compact copy alone, not the legacy fallback.
        copied = {}
        for path in (suite / 'checkpoints' / method).glob('*.json'):
            copied.update(json.loads(path.read_text())['results'])
        if copied != rows:
            raise ValueError('Incomplete checkpoint migration; originals preserved')
        total += len(rows)
    removed = archive_and_remove([suite / name for name in ('results', 'shards', 'krympa_inputs')],
                                 suite / 'legacy_layout.tar.gz')
    return {'results_preserved': total, 'inputs_preserved': len(inputs), 'archived_entries': removed}
