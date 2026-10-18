"""Atomic per-problem results and recoverable summary snapshots.

Children write their own result before returning it to the pool. Only the
parent writes summary.json. Recovery never invents outcomes for unfinished
problems, and never infers CPU timings from proof text or file timestamps.
"""
import json
import os
from pathlib import Path
import tempfile


def atomic_json(path, value):
    """Replace a JSON file without exposing a truncated document to readers."""
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    fd, temporary = tempfile.mkstemp(prefix=f'.{path.name}.', suffix='.tmp', dir=path.parent)
    try:
        with os.fdopen(fd, 'w') as stream:
            json.dump(value, stream, indent=2, allow_nan=False)
            stream.write('\n')
            stream.flush()
            os.fsync(stream.fileno())
        os.replace(temporary, path)
    finally:
        if os.path.exists(temporary):
            os.unlink(temporary)


def save_problem(result, directories):
    problem = result['problem']
    if not isinstance(problem, str) or not problem or Path(problem).name != problem or problem in ('.', '..'):
        raise ValueError(f'Invalid problem identifier: {problem!r}')
    for directory in directories:
        atomic_json(Path(directory) / 'results' / f'{problem}.json', result)


def read_problems(directories):
    """Read child checkpoints; the first directory is authoritative on overlap."""
    records = {}
    for directory in directories:
        for path in sorted((Path(directory) / 'results').glob('*.json')):
            result = json.loads(path.read_text())
            if not isinstance(result, dict) or result.get('problem') != path.stem:
                raise ValueError(f'Invalid problem checkpoint: {path}')
            records.setdefault(path.stem, result)
    return records


def write_snapshot(directories, records, expected, state, error=None):
    unexpected = records.keys() - set(expected)
    if unexpected:
        raise ValueError(f'Unexpected problem checkpoints: {sorted(unexpected)}')
    rows = [records[p] for p in sorted(records)]
    progress = {
        'state': state,
        'expected_problems': sorted(expected),
        'finished_count': len(records),
        'unfinished_problems': sorted(set(expected) - records.keys()),
    }
    if error:
        progress['error'] = error
    for directory in directories:
        # A snapshot can lag the durable child records but is always valid JSON.
        atomic_json(Path(directory) / 'summary.json', rows)
        atomic_json(Path(directory) / 'run_state.json', progress)
    return progress


def rebuild_summary(experiment_dir, log_dir=None):
    """Rebuild a stopped run from result checkpoints, optionally mirroring logs.

    Call only after the run has stopped, so the parent is not concurrently
    updating summary.json. Older config-only runs do not have checkpoints.
    """
    directories = [Path(experiment_dir)]
    if log_dir is not None:
        directories.append(Path(log_dir))
    state_file = directories[0] / 'run_state.json'
    if not state_file.exists():
        raise ValueError('No run_state.json: this run predates checkpointing; proof outputs alone cannot recover CPU timings')
    previous = json.loads(state_file.read_text())
    records = read_problems(directories)
    expected = previous['expected_problems']
    state = 'complete' if set(records) == set(expected) else 'interrupted'
    return write_snapshot(directories, records, expected, state,
                          previous.get('error') or ('Rebuilt after interruption' if state != 'complete' else None))
