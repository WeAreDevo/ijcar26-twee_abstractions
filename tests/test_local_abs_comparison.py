from copy import deepcopy
import csv
import json
from pathlib import Path
import tempfile
import unittest

import yaml

from scripts.compare_local_abs import (
    canonical_config, compare_records, historical_config, load_results,
    main, plot_comparison, summarize,
)

CONFIG = {
    'twee': {'flags': ['--no-all-lemmas', '--show-peaks', '--no-flatten-goal',
                       '--hint-skel-factor 0', '--hint-skel-cost 1'], 'timeout': 1000},
    'stitch': {'iterations': 10, 'max_arity': 10},
    'extraction': {'onlyProofTerms': True, 'onlyPeakTerms': False, 'onlyUsedLemmas': True},
}


def result(base, hint, status='success'):
    return {'mean_base_user_time': base, 'hints_time_user': hint, 'hints_status': status}


class ComparisonTests(unittest.TestCase):
    def test_match_only_intended_config_changes(self):
        old = historical_config(CONFIG)
        self.assertIn('--all-lemmas', old['twee']['flags'])
        self.assertNotIn('onlyUsedLemmas', old['extraction'])
        reordered = deepcopy(old)
        reordered['twee']['flags'].reverse()
        reordered['theory'] = 'GRP'
        reordered['extraction']['onlyUsedLemmas'] = False
        self.assertEqual(canonical_config(old), canonical_config(reordered))
        for field in ('iterations', 'max_arity'):
            different = deepcopy(old)
            different['stitch'][field] += 1
            self.assertNotEqual(canonical_config(old), canonical_config(different))
        different = deepcopy(old)
        different['twee']['timeout'] = 500
        self.assertNotEqual(canonical_config(old), canonical_config(different))
        self.assertNotEqual(canonical_config(old), canonical_config(CONFIG))

    def test_speedup_gain_and_absolute_runtime_are_distinct(self):
        rows = compare_records({'GRP001': result(20, 5)}, {'GRP001': result(100, 10)})
        row = rows[0]
        self.assertEqual(row['old_speedup'], 4)
        self.assertEqual(row['new_speedup'], 10)
        self.assertEqual(row['speedup_ratio_new_over_old'], 2.5)
        self.assertEqual(row['speedup_change_pct'], 150)
        self.assertEqual(row['hint_runtime_ratio_old_over_new'], 0.5)
        self.assertEqual(row['base_runtime_ratio_new_over_old'], 5)

    def test_common_cohort_excludes_missing_and_failed_from_ratios(self):
        old = {'GRP001': result(20, 5), 'GRP002': result(10, 5),
               'LAT001': result(10, 9), 'LAT002': result(10, None, 'timeout')}
        new = {'GRP001': result(20, 2), 'GRP002': result(10, None, 'timeout'),
               'LAT002': result(10, 1), 'LAT003': result(10, 1)}
        stats = summarize(compare_records(old, new))
        self.assertEqual(stats['common_problems'], 3)
        self.assertEqual(stats['paired_positive_timings'], 1)
        self.assertEqual(stats['old_geomean_speedup_paired'], 4)
        self.assertAlmostEqual(stats['new_geomean_speedup_paired'], 10)
        self.assertEqual(stats['old_only'], 1)
        self.assertEqual(stats['new_only'], 1)
        self.assertEqual(stats['new_success_old_not_success'], 1)
        self.assertEqual(stats['old_success_new_not_success'], 1)
        self.assertEqual(stats['old_over_2x_on_common'], 1)  # Exactly 2x is excluded.
        self.assertEqual(stats['new_over_2x_on_common'], 2)

    def test_zero_missing_nonfinite_times_are_not_invented(self):
        old = {f'GRP{i}': result(10, 2) for i in range(5)}
        new = {'GRP0': result(10, 0), 'GRP1': result(0, 2), 'GRP2': result(10, None),
               'GRP3': result(10, float('nan')), 'GRP4': result(10, float('inf'))}
        rows = compare_records(old, new)
        self.assertTrue(all(r['speedup_ratio_new_over_old'] is None for r in rows))
        self.assertTrue(rows[0]['new_over_2x'])
        stats = summarize(rows)
        self.assertEqual(stats['paired_positive_timings'], 0)
        self.assertEqual(stats['new_zero_hint_time'], 1)
        json.dumps(stats, allow_nan=False)

    def test_latest_failure_is_not_replaced_with_earlier_success(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            old = historical_config(CONFIG)
            for name, status in [('20250101_GRP', 'success'), ('20250102_GRP', 'timeout')]:
                folder = root / name
                folder.mkdir()
                (folder / 'config.yaml').write_text(yaml.safe_dump(old))
                (folder / 'summary.json').write_text(json.dumps([
                    dict(result(10, 1 if status == 'success' else None, status), problem='GRP001')]))
            # An in-flight newer run must be visible without hiding completed data.
            pending = root / '20250103_GRP'
            pending.mkdir()
            (pending / 'config.yaml').write_text(yaml.safe_dump(old))
            bad = root / '20250104_GRP'
            bad.mkdir()
            (bad / 'config.yaml').write_text(yaml.safe_dump(old))
            (bad / 'summary.json').write_text('[{')
            different = deepcopy(old)
            different['twee']['flags'].append('--flatten-goal')
            (root / 'config.yaml').write_text(yaml.safe_dump(different))
            records, info = load_results(root, old, ['GRP'])
            self.assertEqual(records['GRP001']['hints_status'], 'timeout')
            self.assertEqual(info['repeated_problems'], {'GRP001': 2})
            self.assertEqual(len(info['pending_runs']), 1)
            self.assertEqual(len(info['unreadable_runs']), 1)
            self.assertEqual(info['ignored_config_runs'], 1)

    def test_cli_before_new_results_arrive(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            cfg = root / 'new.yaml'
            cfg.write_text(yaml.safe_dump(CONFIG))
            old_run = root / 'old/20250101_GRP'
            old_run.mkdir(parents=True)
            (old_run / 'config.yaml').write_text(yaml.safe_dump(historical_config(CONFIG)))
            (old_run / 'summary.json').write_text(json.dumps([dict(result(10, 1), problem='GRP001')]))
            report = main(['--old-root', str(root / 'old'), '--new-root', str(root / 'new'),
                           '--config', str(cfg), '--output-dir', str(root / 'report')])
            self.assertEqual(report['overall']['old_problems'], 1)
            self.assertEqual(report['overall']['new_problems'], 0)
            self.assertIsNone(report['overall']['new_geomean_speedup_paired'])
            with (root / 'report/per_problem.csv').open() as f:
                row = next(csv.DictReader(f))
            self.assertEqual(row['new_status'], 'missing')
            self.assertEqual(row['new_speedup'], '')

    def test_partial_checkpoint_summary_is_included_but_flagged(self):
        with tempfile.TemporaryDirectory() as tmp:
            run = Path(tmp) / '20261018_GRP'
            run.mkdir()
            (run / 'config.yaml').write_text(yaml.safe_dump(CONFIG))
            (run / 'summary.json').write_text(json.dumps([dict(result(10, 1), problem='GRP001')]))
            (run / 'run_state.json').write_text(json.dumps({
                'state': 'failed', 'expected_problems': ['GRP001', 'GRP002'],
            }))
            records, info = load_results(tmp, CONFIG, ['GRP'])
            self.assertEqual(set(records), {'GRP001'})
            self.assertEqual(info['partial_runs'][0]['unfinished_count'], 1)
            self.assertEqual(info['partial_runs'][0]['state'], 'failed')

    def test_plot_with_synthetic_paired_timings(self):
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / 'speedups.png'
            self.assertFalse(plot_comparison([], path))
            rows = compare_records({'GRP001': result(10, 2)}, {'GRP001': result(10, 1)})
            self.assertTrue(plot_comparison(rows, path))
            self.assertGreater(path.stat().st_size, 1000)


if __name__ == '__main__':
    unittest.main()
