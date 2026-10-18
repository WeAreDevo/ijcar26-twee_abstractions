import json
import multiprocessing
import os
from pathlib import Path
import signal
import tempfile
import time
import unittest
from unittest.mock import patch
from concurrent.futures.process import BrokenProcessPool

from src.stitch.pipeline import worker
from src.stitch.pipeline.checkpoints import atomic_json, rebuild_summary, save_problem, write_snapshot


def synthetic_task(args):
    path, config, log_dir = args
    if path.stem == 'slow':
        deadline = time.monotonic() + 10
        while not Path(config['gate']).exists():
            if time.monotonic() > deadline:
                raise RuntimeError('Test gate timed out')
            time.sleep(0.02)
    if path.stem == 'exception':
        raise ValueError('Synthetic problem failure')
    if path.stem == 'crash':
        deadline = time.monotonic() + 10
        while not (log_dir / 'results/fast.json').exists():
            if time.monotonic() > deadline:
                raise RuntimeError('Test checkpoint timed out')
            time.sleep(0.02)
        os._exit(17)  # Simulate a killed child; no real prover involved.
    return {'problem': path.stem, 'hints_status': 'success', 'hints_time_user': 1.25}


def launch_test_run(root, names):
    root = Path(root)
    with patch.dict(os.environ, {'LOG_DIR': str(root / 'logs'), 'TWITCH_MAX_WORKERS': '2'}):
        worker.spawn_processes(synthetic_task, {'gate': str(root / 'gate')}, root / 'runs',
                               [Path(name + '.p') for name in names], 'test')


class CheckpointTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)

    def summaries(self):
        return sorted(self.root.glob('*/202*/summary.json'))

    def test_atomic_write_failure_preserves_previous_valid_summary(self):
        path = self.root / 'summary.json'
        atomic_json(path, [{'problem': 'old'}])
        with patch('os.replace', side_effect=OSError('simulated failure')):
            with self.assertRaises(OSError):
                atomic_json(path, [{'problem': 'new'}])
        self.assertEqual(json.loads(path.read_text()), [{'problem': 'old'}])
        self.assertEqual(list(self.root.glob('*.tmp')), [])

    def test_normal_exception_does_not_lose_other_results(self):
        launch_test_run(self.root, ['fast', 'exception'])
        self.assertEqual(len(self.summaries()), 2)
        for path in self.summaries():
            rows = {r['problem']: r for r in json.loads(path.read_text())}
            self.assertEqual(rows['fast']['hints_time_user'], 1.25)
            self.assertEqual(rows['exception']['status'], 'error')
            self.assertIn('Synthetic problem failure', rows['exception']['error'])
            state = json.loads(path.with_name('run_state.json').read_text())
            self.assertEqual(state['state'], 'complete')
            self.assertEqual(state['unfinished_problems'], [])

    def test_broken_pool_recovers_results_written_before_delivery(self):
        with self.assertRaises(BrokenProcessPool):
            launch_test_run(self.root, ['fast', 'crash'])
        for path in self.summaries():
            self.assertEqual([r['problem'] for r in json.loads(path.read_text())], ['fast'])
            state = json.loads(path.with_name('run_state.json').read_text())
            self.assertEqual(state['state'], 'failed')
            self.assertEqual(state['unfinished_problems'], ['crash'])
            self.assertTrue((path.parent / 'results/fast.json').exists())

    def test_fast_result_saved_while_first_input_is_blocked_and_on_sigterm(self):
        parent = multiprocessing.get_context('fork').Process(
            target=launch_test_run, args=(str(self.root), ['slow', 'fast']))
        parent.start()
        try:
            deadline = time.monotonic() + 5
            ready = False
            while time.monotonic() < deadline:
                paths = self.summaries()
                if len(paths) == 2 and all(
                    any(row['problem'] == 'fast' for row in json.loads(p.read_text())) for p in paths
                ):
                    ready = True
                    break
                time.sleep(0.02)
            self.assertTrue(ready, 'Later result must be saved before the first input finishes')
            os.kill(parent.pid, signal.SIGTERM)
            deadline = time.monotonic() + 5
            while time.monotonic() < deadline:
                if all(json.loads(p.with_name('run_state.json').read_text())['state'] == 'interrupted'
                       for p in self.summaries()):
                    break
                time.sleep(0.02)
            for path in self.summaries():
                state = json.loads(path.with_name('run_state.json').read_text())
                self.assertEqual(state['state'], 'interrupted')
                self.assertEqual(state['unfinished_problems'], ['slow'])
                self.assertEqual(json.loads(path.read_text())[0]['problem'], 'fast')
        finally:
            # Allow surviving synthetic children to exit before the test ends.
            (self.root / 'gate').touch()
            parent.join(timeout=5)
            if parent.is_alive():
                parent.kill()
                parent.join(timeout=5)
        self.assertEqual(parent.exitcode, 143)

    def test_rebuild_includes_durable_result_missing_from_snapshot(self):
        experiment = self.root / 'experiment'
        logs = self.root / 'logs'
        write_snapshot([experiment, logs], {}, ['one', 'two'], 'running')
        result = {'problem': 'one', 'hints_status': 'success', 'hints_time_user': 3.0}
        save_problem(result, [experiment, logs])
        state = rebuild_summary(experiment, logs)
        self.assertEqual(state['state'], 'interrupted')
        self.assertEqual(state['unfinished_problems'], ['two'])
        for directory in (experiment, logs):
            self.assertEqual(json.loads((directory / 'summary.json').read_text()), [result])

    def test_legacy_proofs_do_not_fabricate_cpu_times(self):
        self.root.joinpath('config.yaml').write_text('twee: {}')
        with self.assertRaisesRegex(ValueError, 'predates checkpointing'):
            rebuild_summary(self.root)
        self.assertFalse((self.root / 'summary.json').exists())

    def test_worker_cap_is_independent_of_slurm_allocation(self):
        with patch.dict(os.environ, {'SLURM_CPUS_PER_TASK': '64', 'TWITCH_MAX_WORKERS': '8'}), \
                patch('os.sched_getaffinity', return_value=set(range(64))):
            self.assertEqual(worker.worker_count(), 8)
            self.assertEqual(worker.worker_count(debug=True), 1)


if __name__ == '__main__':
    unittest.main()
