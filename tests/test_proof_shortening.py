import argparse
import contextlib
import io
import json
import os
from pathlib import Path
import tarfile
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
        suite.STOP.clear()

    def tearDown(self):
        suite.STOP.clear()
        self.temp.cleanup()

    def archive_fixture(self):
        source = self.root / 'P.p'
        source.write_text('cnf(goal,negated_conjecture,a!=a).')
        proof = 'Goal 1: a = a.\nProof:\n a\nRESULT: Theorem\n'
        size = suite.measure_completed_twee_proof(proof)
        manifest = dict(log_root=str(self.root / 'logs'), label='suite',
                        limits={'base': 1, 'local_abs': 1},
                        configs={'twitch_flatten': dict(zip(('base', 'local_abs'), suite.configs(True)))})
        problem = dict(problem='P', source=str(source), sha256=suite.digest(source))
        return manifest, problem, proof, size

    def test_archive_base_before_local_and_resume_without_loose_outputs(self):
        manifest, problem, proof, size = self.archive_fixture()
        project = self.root / 'project'
        def phase(source, config, stage, raw, limit, entry=None):
            raw.mkdir(parents=True)
            if stage == 'base':
                (raw / 'P_base_output.txt').write_text(proof)
                return dict(base_proof_size=size, base_time_user=1, base_status='success')
            row = suite.ResultStore(project, 'twitch_flatten').get('P')
            archived = Path(row['raw_dir']) / 'base/P_base_output.txt'
            self.assertEqual(suite.read_artifact(archived), proof)
            self.assertEqual(Path(entry['output_file']).read_text(), proof)
            suite.STOP.set()  # Simulate a stop after a durable base snapshot.
            return {'status': 'interrupted'}
        with patch.dict(os.environ, {'PROOF_SCRATCH_DIR': str(self.root / 'scratch')}), \
                patch.object(suite, 'run_phase', side_effect=phase):
            row = suite.execute_problem(project, manifest, 'twitch_flatten', problem)
        self.assertEqual(row['status'], 'interrupted')
        self.assertFalse(Path(row['scratch_dir']).exists())
        self.assertFalse(Path(row['raw_dir']).exists())
        self.assertEqual(len(list((self.root / 'logs').rglob('*'))), 3)  # Two dirs + one archive.
        suite.STOP.clear()
        # Also cover a kill between saving final metrics and publishing the
        # final archive: a nominal success must not skip this interrupted save.
        interrupted = dict(row, status='success', artifact_status='publishing')
        suite.ResultStore(project, 'twitch_flatten').save(interrupted)
        with patch.dict(os.environ, {'PROOF_SCRATCH_DIR': str(self.root / 'scratch')}), \
                patch.object(suite, 'run_phase', return_value={'hints_proof_size': size}) as run:
            resumed = suite.execute_problem(project, manifest, 'twitch_flatten', problem)
        self.assertEqual(resumed['status'], 'success')
        self.assertEqual(run.call_count, 1)
        self.assertEqual(run.call_args.args[2], 'local_abs')
        self.assertTrue(Path(resumed['artifact_archive']).is_file())

    def test_archive_failure_keeps_metrics_and_scratch_and_stops_batch(self):
        manifest, problem, proof, size = self.archive_fixture()
        def phase(source, config, stage, raw, limit, entry=None):
            raw.mkdir(parents=True)
            if stage == 'base':
                (raw / 'P_base_output.txt').write_text(proof)
                return dict(base_proof_size=size, base_time_user=1, base_status='success')
            (raw / 'P_with_hints_output.txt').write_text(proof)
            return {'hints_proof_size': size}
        real_publish = suite.publish_archive
        def publish(raw, archive):
            if (raw / 'local_abs').exists():
                raise OSError('Disk quota exceeded')
            return real_publish(raw, archive)
        with patch.dict(os.environ, {'PROOF_SCRATCH_DIR': str(self.root / 'scratch')}), \
                patch.object(suite, 'run_phase', side_effect=phase), \
                patch.object(suite, 'publish_archive', side_effect=publish):
            row = suite.execute_problem(self.root / 'project', manifest, 'twitch_flatten', problem)
        self.assertEqual(row['artifact_status'], 'error')
        self.assertEqual(row['completed_result_status'], 'success')
        self.assertEqual(row['local_abs']['hints_proof_size'], size)
        self.assertEqual(row, suite.ResultStore(self.root / 'project', 'twitch_flatten').get('P'))
        self.assertEqual(suite.read_artifact(Path(row['raw_dir']) / 'base/P_base_output.txt'), proof)
        self.assertTrue(Path(row['scratch_dir']).is_dir())
        self.assertTrue(suite.STOP.is_set())

    def test_twitch_keeps_only_prover_outputs_and_one_metadata_file(self):
        manifest, problem, proof, size = self.archive_fixture()
        def phase(source, config, stage, raw, limit, entry=None):
            raw.mkdir(parents=True)
            for filename in ('worker.log', 'request.json', 'result.json', 'P_extracted_terms.json',
                             'P_with_hints.p', 'P_base_stderr.txt'):
                (raw / filename).write_text('discard this')
            if stage == 'base':
                (raw / 'P_base_output.txt').write_text(proof)
                return dict(base_proof_size=size, base_time_user=1, base_status='success')
            (raw / 'P_with_hints_output.txt').write_text(proof)
            return {'hints_proof_size': size}
        with patch.dict(os.environ, {'PROOF_SCRATCH_DIR': str(self.root / 'scratch')}), \
                patch.object(suite, 'run_phase', side_effect=phase):
            row = suite.execute_problem(self.root / 'project', manifest, 'twitch_flatten', problem)
        with tarfile.open(row['artifact_archive']) as archive:
            prefix = row['artifact_prefix'] + '/'
            files = {m.name.removeprefix(prefix) for m in archive if m.isfile()}
            self.assertEqual(files, {'base/P_base_output.txt', 'local_abs/P_with_hints_output.txt',
                                     'checkpoint.json'})
            self.assertEqual(json.load(archive.extractfile(prefix + 'checkpoint.json')), row)
        self.assertFalse(Path(row['scratch_dir']).exists())

    def test_krympa_keeps_only_final_output_or_no_archive_on_failure(self):
        manifest, problem, proof, size = self.archive_fixture()
        manifest['limits']['krympa'] = 1
        converted = 'fof(goal,conjecture,a=a).'
        problem['krympa_sha256'] = suite.hashlib.sha256(converted.encode()).hexdigest()
        for success in (True, False):
            with self.subTest(success=success):
                def command(args, log, limit):
                    raw = log.parent
                    (raw / 'launcher.log').write_text('discard this log')
                    pipeline = raw / 'pipeline'
                    (pipeline / 'output').mkdir(parents=True)
                    (pipeline / 'output/intermediate.out').write_text('discard this proof')
                    details = dict(status='failed', error='failure details')
                    if success:
                        final = pipeline / 'output/proof_P.out'
                        final.write_text(proof)
                        details = dict(status='completed', proof=str(final), proof_size=size)
                    atomic_json(pipeline / 'run.json', details)
                    return {'status': 'success' if success else 'error'}
                with patch.dict(os.environ, {'PROOF_SCRATCH_DIR': str(self.root / 'scratch')}), \
                        patch.object(suite, 'read_input', return_value=converted), \
                        patch.object(suite, 'run_command', side_effect=command):
                    project = self.root / str(success)
                    previous = dict(problem='P', method='krympa', status='error',
                                    error='[Errno 122] Disk quota exceeded')
                    suite.ResultStore(project, 'krympa').save(previous)
                    self.assertEqual(suite.execute_problem(project, manifest, 'krympa', problem), previous)
                    row = suite.execute_problem(project, manifest, 'krympa', problem, retry_storage_errors=True)
                self.assertEqual(row['previous_attempt'], previous)
                self.assertEqual(row, suite.ResultStore(project, 'krympa').get('P'))
                self.assertFalse(Path(row['scratch_dir']).exists())
                if success:
                    with tarfile.open(row['artifact_archive']) as archive:
                        files = [m for m in archive if m.isfile()]
                        self.assertEqual(len(files), 1)
                        self.assertTrue(files[0].name.endswith('/pipeline/output/proof_P.out'))
                        self.assertEqual(archive.extractfile(files[0]).read().decode(), proof)
                else:
                    self.assertIsNone(row['artifact_archive'])
                    self.assertEqual(row['artifact_status'], 'no_output')
                    self.assertEqual(row['krympa']['error'], 'failure details')

    def test_remaining_selection_keeps_terminal_outcomes_and_retries_storage_errors(self):
        self.assertEqual(suite.remaining_reason(None, True), 'missing')
        self.assertEqual(suite.remaining_reason({'status': 'running'}, True), 'unfinished')
        self.assertEqual(suite.remaining_reason({'status': 'success', 'artifact_status': 'publishing'}, True),
                         'unfinished')
        for status in ('success', 'timeout', 'base_timeout', 'no valid abstractions produced by Stitch'):
            self.assertIsNone(suite.remaining_reason({'status': status}, True))
        self.assertIsNone(suite.remaining_reason({'status': 'error', 'krympa': {'error': 'no final proof'}}, True))
        self.assertEqual(suite.remaining_reason({'status': 'error', 'local_abs': {
            'error': '[Errno 28] No space left on device'}}, True), 'storage_error')

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

    def test_report_uses_reported_krympa_length_including_mismatches_and_zero(self):
        def size(n):
            return dict(metric=METRIC, steps=n)
        for name, k, t, matches in [('A', 8, 4, True), ('B', 1, 0, True), ('C', 4, 2, False)]:
            atomic_json(self.root / f'results/krympa/{name}.json',
                        dict(problem=name, method='krympa', status='success',
                             krympa={'proof_size': dict(size(k), baseline_steps=10,
                                     reported_steps=k if matches else 1,
                                     counts_match=matches, reference_revision_matches=True)}))
            atomic_json(self.root / f'results/twitch_no_flatten/{name}.json',
                        dict(problem=name, method='twitch_no_flatten', status='success',
                             base={'base_proof_size': size(12)}, local_abs={'hints_proof_size': size(t)}))
        manifest = {'problems': [dict(problem=p, domain='test') for p in 'ABCD']}
        with contextlib.redirect_stdout(io.StringIO()):
            suite.report(self.root, manifest)
        report = json.loads((self.root / 'comparison/summary.json').read_text())
        stats = report['comparisons']['twitch_no_flatten']
        self.assertEqual(stats['paired_proofs'], 3)
        self.assertEqual(stats['twitch_shorter'], 2)
        self.assertEqual(stats['krympa_shorter'], 1)
        self.assertEqual(stats['positive_ratio_pairs'], 2)
        self.assertAlmostEqual(stats['geometric_mean_krympa_over_twitch'], 1)
        self.assertEqual(report['krympa_count_mismatches_included'], 1)
        self.assertEqual(report['outcomes']['twitch_flatten'], {'pending': 4})
        import csv
        with (self.root / 'comparison/per_problem.csv').open() as stream:
            rows = {r['problem']: r for r in csv.DictReader(stream)}
        self.assertEqual(rows['C']['krympa_final_steps'], '1')
        self.assertEqual(rows['C']['krympa_recounted_steps'], '4')
        self.assertEqual(rows['C']['krympa_comparable'], 'True')

    def test_reported_length_required_and_revision_still_checked(self):
        size = dict(metric=METRIC, baseline_steps=10, steps=4, counts_match=False,
                    reference_revision_matches=True)
        def eligible(**changes):
            return suite.measurements(dict(method='krympa', status='success',
                                           krympa={'proof_size': dict(size, **changes)}))[2]
        self.assertFalse(eligible())
        self.assertFalse(eligible(reported_steps=-1))
        self.assertFalse(eligible(reported_steps=5, reference_revision_matches=False))
        self.assertTrue(eligible(reported_steps=0))

    def test_best_of_two_selects_per_problem_and_separates_one_sided_results(self):
        def write(method, name, steps, matches=True):
            size = dict(metric=METRIC, steps=steps)
            row = dict(problem=name, method=method, status='success')
            if method == 'krympa':
                row['krympa'] = {'proof_size': dict(size, baseline_steps=20,
                    reported_steps=steps if matches else steps + 1,
                    counts_match=matches, reference_revision_matches=True)}
            else:
                row.update(base={'base_proof_size': dict(metric=METRIC, steps=20)},
                           local_abs={'hints_proof_size': size})
            atomic_json(self.root / 'results' / method / f'{name}.json', row)

        # Different configurations win on A/B, with a zero-step tie on C.
        for name, k, no_flatten, flatten in [('A', 8, 12, 6), ('B', 8, 6, 12), ('C', 0, 0, 0)]:
            for method, steps in zip(suite.METHODS, (k, no_flatten, flatten)):
                write(method, name, steps)
        write('krympa', 'D', 3)
        write('twitch_flatten', 'D', 4)  # Only one available Twitch configuration.
        write('krympa', 'E', 1, matches=False)
        write('twitch_no_flatten', 'E', 10)
        write('krympa', 'F', 5)
        manifest = {'problems': [dict(problem=p, domain='test') for p in 'ABCDEFG']}
        with contextlib.redirect_stdout(io.StringIO()):
            suite.report(self.root, manifest)
        report = json.loads((self.root / 'comparison/summary.json').read_text())
        best = report['comparisons']['twitch_best']
        self.assertEqual((best['paired_proofs'], best['twitch_shorter'], best['krympa_shorter'], best['equal']),
                         (5, 2, 2, 1))
        self.assertEqual(report['best_of_two_paired_with_both_twitch_configs'], 3)
        self.assertEqual(report['best_of_two_coverage'].get('twitch_only_comparable', 0), 0)
        self.assertEqual(report['best_of_two_coverage']['krympa_only_comparable'], 1)
        self.assertEqual(report['best_of_two_coverage']['neither_comparable'], 1)
        self.assertEqual(report['successful_runs_excluded_from_comparison'], {})
        import csv
        with (self.root / 'comparison/per_problem.csv').open() as stream:
            rows = {r['problem']: r for r in csv.DictReader(stream)}
        self.assertEqual(rows['A']['twitch_best_configs'], 'twitch_flatten')
        self.assertEqual(rows['B']['twitch_best_configs'], 'twitch_no_flatten')
        self.assertEqual(rows['C']['twitch_best_configs'], 'twitch_no_flatten|twitch_flatten')
        self.assertEqual(rows['C']['twitch_best_krympa_over_twitch_steps'], '')


if __name__ == '__main__':
    unittest.main()
