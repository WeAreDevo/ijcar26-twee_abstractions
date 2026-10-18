import json
import os
from pathlib import Path
import shlex
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch

from src.stitch.pipeline.main import prepare_pipeline, stage_tasks
from src.stitch.pipeline import worker


class PipelinePreparationTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.input = self.root / 'inputs with spaces'
        self.input.mkdir()
        (self.input / 'example.p').write_text('cnf(goal, negated_conjecture, a != a).\n')
        self.config_path = self.root / 'stage.yaml'
        self.config_path.write_text('twee: {flags: [--no-flatten-goal]}\n')
        base = {'config': str(self.config_path), 'input_dir': str(self.input),
                'output_dir': str(self.root / 'base/{theory}')}
        local = dict(base, output_dir=str(self.root / 'local/{theory}'), base_dir=base['output_dir'])
        self.config = {'theories': ['ALG', 'BOO'], 'slurm': {'account': 'test'},
                       'stages': {'base': base, 'local_abs': local}}

    def prepare(self):
        return prepare_pipeline(self.config, self.root / 'jobs', 'test')

    def test_preparation_does_not_execute_commands(self):
        with patch('subprocess.run', side_effect=AssertionError('Must not submit')):
            paths = self.prepare()
        self.assertEqual(len(paths), 3)
        for path in paths:
            subprocess.run(['bash', '-n', str(path)], check=True)

    def test_generated_commands_match_worker_cli(self):
        paths = self.prepare()
        for path in paths[:2]:
            for line in path.read_text().splitlines():
                if not line.strip().startswith('exec '):
                    continue
                args = shlex.split(line.strip())[4:]  # exec bash containers/run.sh twitch
                with patch.object(sys, 'argv', ['worker.py', *args]):
                    parsed = worker.parse_args()
                self.assertEqual(parsed.input_dir, str(self.input))
                if parsed.stage == 'local_abs':
                    self.assertIn('/base/', parsed.base_dir)

    def test_separate_base_indexes(self):
        self.config['stages']['base']['output_dir'] = str(self.root / 'shared')
        with self.assertRaisesRegex(ValueError, 'distinct task output'):
            self.prepare()

    def test_submit_script_dependencies_with_fake_sbatch(self):
        submit = self.prepare()[-1]
        fake = self.root / 'sbatch'
        log = self.root / 'calls.jsonl'
        fake.write_text('#!' + sys.executable + '\n'
                        'import json, os, sys\n'
                        'with open(os.environ["CALL_LOG"], "a") as f: f.write(json.dumps(sys.argv[1:])+"\\n")\n'
                        'print("123;testcluster")\n')
        fake.chmod(0o755)
        env = dict(os.environ, PATH=str(self.root) + os.pathsep + os.environ['PATH'], CALL_LOG=str(log))
        subprocess.run(['bash', str(submit)], env=env, check=True, capture_output=True)
        calls = [json.loads(line) for line in log.read_text().splitlines()]
        self.assertEqual(len(calls), 2)
        self.assertNotIn('--dependency=afterok:123', calls[0])
        self.assertIn('--dependency=afterok:123', calls[1])

    def test_slurm_cpu_allocation_honored(self):
        with patch.dict(os.environ, {'SLURM_CPUS_PER_TASK': '4'}), \
                patch('os.sched_getaffinity', return_value=set(range(64))):
            self.assertEqual(worker.worker_count(), 4)
            self.assertEqual(worker.worker_count(debug=True), 1)

    def test_partial_stage_dispatch_arguments(self):
        with patch.object(worker, '_run_partial_abs_stage') as run:
            worker.run_stage_with_config('partial_abs', self.config_path, self.input,
                                         self.root / 'output', 'test')
        self.assertEqual(len(run.call_args.args), 6)


if __name__ == '__main__':
    unittest.main()
