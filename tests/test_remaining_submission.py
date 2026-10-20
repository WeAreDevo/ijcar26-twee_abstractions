import argparse
import contextlib
import io
import os
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch

from scripts import prepare_remaining_proof_shortening as remaining
from scripts.experiment_storage import ResultStore
from src.stitch.pipeline.checkpoints import atomic_json


class RemainingSubmissionTests(unittest.TestCase):
    def test_sparse_arrays_and_preflight_before_any_submission(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            suite = root / 'suite'
            suite.mkdir()
            manifest = {'batch_size': 2, 'problems': [{'problem': n} for n in 'ABCDE']}
            atomic_json(suite / 'manifest.json', manifest)
            for method in remaining.METHODS:
                for index, name in enumerate('ABCD'):
                    ResultStore(suite, method, index // 2).save(dict(
                        problem=name, method=method, status='success' if name != 'B' else 'error',
                        error='' if name != 'B' else 'Disk quota exceeded'))
            templates = remaining.ROOT / 'vera_jobs/proof_shortening'
            args = argparse.Namespace(suite=suite, templates=templates, output=root / 'remaining',
                                      parallel_tasks=2)
            with patch.object(remaining, 'ROOT', root), contextlib.redirect_stdout(io.StringIO()):
                remaining.prepare(args)
            for method in remaining.METHODS:
                script = (args.output / f'{method}.sh').read_text()
                self.assertIn('#SBATCH --array=0,2%2', script)
                self.assertIn('--retry-storage-errors', script)
                self.assertIn('#SBATCH --signal=B:TERM@180', script)
            (root / 'containers').mkdir()
            (root / 'containers/run.sh').write_text('#!/bin/bash\nexit "${CHECK_EXIT:-0}"\n')
            fake = root / 'bin'
            fake.mkdir()
            (fake / 'sbatch').write_text('#!/bin/bash\nprintf "%s\\n" "$*" >> "$SUBMISSIONS"\n')
            (fake / 'sbatch').chmod(0o755)
            submitted = root / 'submissions'
            env = dict(os.environ, PATH=str(fake) + ':' + os.environ['PATH'],
                       SUBMISSIONS=str(submitted), CHECK_EXIT='1')
            command = ['bash', str(args.output / 'submit.sh')]
            self.assertNotEqual(subprocess.run(command, env=env, capture_output=True).returncode, 0)
            self.assertFalse(submitted.exists())
            env.update(CHECK_EXIT='0', PROOF_PARALLEL_TASKS='4')
            subprocess.run(command, env=env, check=True, capture_output=True)
            calls = submitted.read_text().splitlines()
            self.assertEqual(len(calls), 3)
            self.assertTrue(all('--array=0,2%4' in call for call in calls))


if __name__ == '__main__':
    unittest.main()
