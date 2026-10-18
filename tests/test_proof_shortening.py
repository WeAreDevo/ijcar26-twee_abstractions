import argparse
import contextlib
import io
import json
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

import yaml

from scripts import proof_shortening as suite
from scripts.ueq_inputs import krympa_input
from src.proof_metrics import METRIC
from src.stitch.pipeline.checkpoints import atomic_json


class ProofShorteningTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.root = Path(self.temp.name)

    def tearDown(self):
        self.temp.cleanup()

    def test_deduplicate_unsat_and_exclude_unknown_and_unlabelled(self):
        for directory, name, text in [('a', 'GRP001-1', '% Status : Unsatisfiable\n'),
                                       ('b', 'GRP001-1', '% Status : Unsatisfiable\n'),
                                       ('a', 'GRP002-1', '% Status : Unknown\n'),
                                       ('ETP_UEQ_UNSAT', '1_2', 'cnf(x,axiom,a=b).')]:
            path = self.root / directory / f'{name}.p'
            path.parent.mkdir(exist_ok=True)
            path.write_text(text)
        self.assertEqual(len(suite.discover(self.root)), 1)
        self.assertEqual(len(suite.discover(self.root, include_etp=True)), 2)
        (self.root / 'b/GRP001-1.p').write_text('% Status : Unsatisfiable\n% changed')
        with self.assertRaisesRegex(ValueError, 'Conflicting'):
            suite.discover(self.root)

    def test_expand_selected_include_and_preserve_existential_goal(self):
        (self.root / 'axioms.ax').write_text('cnf(a,axiom,f(X)=X).\ncnf(b,axiom,b=c).')
        source = self.root / 'problem.p'
        source.write_text("include('axioms.ax',[a]).\ncnf(g,negated_conjecture,f(Y)!=Y).")
        converted = krympa_input(source, self.root)
        self.assertIn('! [X] : (f(X)=X)', converted)
        self.assertIn('? [Y] : (f(Y)=Y)', converted)
        self.assertNotIn('b=c', converted)
        self.assertNotIn('include(', converted)

    def test_positive_negated_conjecture_is_retained_as_assumption(self):
        source = self.root / 'problem.p'
        source.write_text('cnf(a,negated_conjecture,a=b).\ncnf(g,negated_conjecture,b!=c).')
        converted = krympa_input(source, self.root)
        self.assertIn('fof(a1, axiom,\n    a=b', converted)
        self.assertIn('fof(goal, conjecture,\n    b=c', converted)

    def test_reject_nonunit_and_multiple_negative_goals(self):
        source = self.root / 'problem.p'
        for text in ['cnf(a,axiom,a=b|b=c).\ncnf(g,negated_conjecture,a!=c).',
                     'cnf(g,negated_conjecture,a!=b).\ncnf(h,axiom,b!=c).']:
            source.write_text(text)
            with self.assertRaises(ValueError):
                krympa_input(source, self.root)

    def test_base_reuse_requires_compatible_presentation_and_keeps_timeouts(self):
        for label, all_lemmas in [('20260101_base', False), ('20260201_base', True)]:
            folder = self.root / label
            folder.mkdir()
            config = suite.configs(False)[0]
            if all_lemmas:
                config['twee']['flags'].remove('--no-all-lemmas')
                config['twee']['flags'].append('--all-lemmas')
            (folder / 'config.yaml').write_text(yaml.safe_dump(config))
            atomic_json(folder / 'summary.json', [dict(problem='P', base_status='timeout')])
        found = suite.existing_bases([self.root])
        self.assertEqual(found['P']['experiment'], '20260101_base')
        self.assertEqual(found['P']['result']['base_status'], 'timeout')

    def test_timeout_kills_process_group(self):
        import sys
        outcome = suite.run_command([sys.executable, '-c', 'import time; time.sleep(60)'],
                                    self.root / 'worker.log', 0.05)
        self.assertEqual(outcome['status'], 'timeout')
        self.assertFalse(suite.ACTIVE)

    def test_atomic_result_resume_does_not_repeat_finished_failure(self):
        row = dict(problem='P', method='twitch_no_flatten', status='timeout')
        atomic_json(self.root / 'results/twitch_no_flatten/P.json', row)
        self.assertEqual(suite.execute_problem(self.root, {}, 'twitch_no_flatten', {'problem': 'P'}), row)

    def test_interrupted_local_reuses_saved_base(self):
        proof_dir = self.root / 'oldbase'
        proof_dir.mkdir()
        proof = 'Goal 1: a = a.\nProof:\n a\nRESULT: Theorem\n'
        (proof_dir / 'P_base_output.txt').write_text(proof)
        size = suite.measure_completed_twee_proof(proof)
        base = dict(base_proof_size=size, base_time_user=1, base_status='success')
        atomic_json(self.root / 'suite/results/twitch_no_flatten/P.json',
                    dict(problem='P', method='twitch_no_flatten', status='interrupted',
                         base=base, base_experiment='oldbase', attempt='old'))
        source = self.root / 'P.p'
        source.write_text('cnf(goal,negated_conjecture,a!=a).')
        manifest = dict(log_root=str(self.root), label='logs', limits={'local_abs': 1},
                        configs={'twitch_no_flatten': dict(zip(('base', 'local_abs'), suite.configs(False)))})
        with patch.object(suite, 'run_phase', return_value={'hints_proof_size': size}) as run:
            row = suite.execute_problem(self.root / 'suite', manifest, 'twitch_no_flatten',
                                        dict(problem='P', source=str(source), sha256=suite.digest(source)))
        self.assertEqual(row['status'], 'success')
        self.assertEqual(run.call_count, 1)
        self.assertEqual(run.call_args.args[2], 'local_abs')

    def test_report_excludes_mismatches_and_pending_and_handles_zero(self):
        def size(n):
            return dict(metric=METRIC, steps=n)
        for name, k, t, matches in [('A', 8, 4, True), ('B', 1, 0, True), ('C', 4, 2, False)]:
            atomic_json(self.root / f'results/krympa/{name}.json',
                        dict(problem=name, method='krympa', status='success',
                             krympa={'proof_size': dict(size(k), baseline_steps=10,
                                     counts_match=matches, reference_revision_matches=True)}))
            atomic_json(self.root / f'results/twitch_no_flatten/{name}.json',
                        dict(problem=name, method='twitch_no_flatten', status='success',
                             base={'base_proof_size': size(12)}, local_abs={'hints_proof_size': size(t)}))
        manifest = {'problems': [dict(problem=p, domain='test') for p in 'ABCD']}
        with contextlib.redirect_stdout(io.StringIO()):
            suite.report(self.root, manifest)
        report = json.loads((self.root / 'comparison/summary.json').read_text())
        stats = report['comparisons']['twitch_no_flatten']
        self.assertEqual(stats['paired_proofs'], 2)
        self.assertEqual(stats['twitch_shorter'], 2)
        self.assertEqual(stats['positive_ratio_pairs'], 1)
        self.assertEqual(stats['geometric_mean_krympa_over_twitch'], 2)
        self.assertEqual(report['outcomes']['twitch_flatten'], {'pending': 4})


if __name__ == '__main__':
    unittest.main()
