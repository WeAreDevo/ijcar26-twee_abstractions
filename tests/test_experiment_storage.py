import hashlib
import json
import multiprocessing
from pathlib import Path
import tarfile
import tempfile
import unittest
from unittest.mock import patch

from scripts.experiment_storage import (
    ResultStore, archive_and_remove, compact_suite, publish_archive, read_artifact,
    read_input, read_results, suite_access,
)
from scripts.compact_proof_logs import attempts
from src.stitch.pipeline.checkpoints import atomic_json


def save_rows(directory, start):
    store = ResultStore(directory, 'krympa', 0)
    for i in range(start, start + 8):
        store.save({'problem': str(i), 'status': 'success'})


class StorageTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)

    def tearDown(self):
        self.temp.cleanup()

    def test_concurrent_updates_preserve_every_record(self):
        ctx = multiprocessing.get_context('fork')
        children = [ctx.Process(target=save_rows, args=(self.root, start)) for start in (0, 8, 16)]
        for child in children:
            child.start()
        for child in children:
            child.join(10)
            self.assertEqual(child.exitcode, 0)
        self.assertEqual(len(read_results(self.root, 'krympa')), 24)
        self.assertEqual(len(list((self.root / 'checkpoints/krympa').glob('*.json'))), 1)

    def test_archive_preserves_bytes_and_symlinks_before_removal(self):
        directory = self.root / 'old'
        directory.mkdir()
        (directory / 'data').write_bytes(b'important\x00data')
        (directory / 'link').symlink_to('data')
        archive = self.root / 'old.tar.gz'
        archive_and_remove([directory], archive)
        self.assertFalse(directory.exists())
        with tarfile.open(archive) as saved:
            self.assertEqual(saved.extractfile('old/data').read(), b'important\x00data')
            self.assertEqual(saved.getmember('old/link').linkname, 'data')

    def test_incorrect_existing_archive_never_removes_originals(self):
        directory = self.root / 'old'
        directory.mkdir()
        (directory / 'data').write_text('old version')
        archive = self.root / 'old.tar.gz'
        with tarfile.open(archive, 'w:gz') as saved:
            saved.add(directory, arcname='old')
        (directory / 'data').write_text('new version')
        with self.assertRaisesRegex(ValueError, 'verification failed'):
            archive_and_remove([directory], archive)
        self.assertEqual((directory / 'data').read_text(), 'new version')

    def test_publish_and_compact_read_without_extracting_tree(self):
        directory = self.root / 'attempt'
        directory.mkdir()
        proof = directory / 'proof.txt'
        proof.write_text('base proof')
        archive = self.root / 'attempt.tar.gz'
        publish_archive(directory, archive)
        original = archive.read_bytes()
        proof.write_text('final proof')
        with patch('scripts.experiment_storage.archive_inventory', return_value={}):
            with self.assertRaisesRegex(ValueError, 'verification failed'):
                publish_archive(directory, archive)
        self.assertEqual(archive.read_bytes(), original)
        self.assertEqual(proof.read_text(), 'final proof')
        publish_archive(directory, archive)
        archive_and_remove([directory], archive)
        self.assertEqual(read_artifact(proof), 'final proof')
        self.assertFalse(directory.exists())
        self.assertEqual(list(self.root.iterdir()), [archive])

    def test_compactor_selects_only_known_legacy_attempts(self):
        manifest = {'label': 'suite', 'problems': [{'problem': 'P'}]}
        attempt = self.root / 'suite/krympa/P/20261019T123456_abcdef01'
        attempt.mkdir(parents=True)
        for relative in ('reused_base', 'suite/krympa/unknown/20261019T123456_abcdef01',
                         'suite/krympa/P/other', 'suite/krympa/P_20261019T123456_abcdef01'):
            (self.root / relative).mkdir(parents=True)
        self.assertEqual(list(attempts(self.root, manifest, ['krympa'])), [('krympa', attempt)])

    def test_compaction_preserves_legacy_results_inputs_and_progress(self):
        inputs = self.root / 'krympa_inputs'
        inputs.mkdir()
        text = 'fof(goal, conjecture, a=a).\n'
        (inputs / 'P.p').write_text(text)
        problem = {'problem': 'P', 'krympa_input': str(inputs / 'P.p'),
                   'krympa_sha256': hashlib.sha256(text.encode()).hexdigest()}
        manifest = {'problems': [problem], 'batch_size': 8}
        row = {'problem': 'P', 'status': 'running', 'base': {'steps': 5}}
        atomic_json(self.root / 'results/krympa/P.json', row)
        atomic_json(self.root / 'shards/krympa/0/run_state.json', {'state': 'running'})
        result = compact_suite(self.root, manifest, ['krympa'])
        self.assertEqual(result['results_preserved'], 1)
        self.assertEqual(read_results(self.root, 'krympa'), {'P': row})
        self.assertEqual(read_input(self.root, problem), text)
        self.assertFalse(inputs.exists())
        self.assertFalse((self.root / 'results').exists())
        store = ResultStore(self.root, 'krympa', 0)
        self.assertEqual(store.read()['run_state'], {'state': 'running'})
        store.save(dict(row, status='success'))
        self.assertEqual(store.get('P')['status'], 'success')
        # Rerunning compaction does not resurrect the archived running record.
        compact_suite(self.root, manifest, ['krympa'])
        self.assertEqual(store.get('P')['status'], 'success')

    def test_running_suite_blocks_maintenance(self):
        with suite_access(self.root):
            with self.assertRaisesRegex(RuntimeError, 'Suite is in use'):
                with suite_access(self.root, maintenance=True):
                    self.fail('Must not enter maintenance')


if __name__ == '__main__':
    unittest.main()
