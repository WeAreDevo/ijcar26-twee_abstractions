"""Compare goal-proof-only local abstractions with matching historical runs.

Reads saved configs/summaries only; never runs a prover or submits a job.
Speedup is mean_base_user_time / hints_time_user (extraction cost excluded).
"""
import argparse
from collections import Counter
from copy import deepcopy
import csv
import json
import math
from pathlib import Path
import re
import shlex
import statistics

import yaml

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_CONFIG = ROOT / 'src/stitch/configs/goal_proof_only/local_abs.yaml'


def canonical_config(config):
    """Compare full configs, allowing flag ordering and explicit default values."""
    config = deepcopy(config)
    config.pop('theory', None)
    config['twee']['flags'] = sorted(' '.join(shlex.split(f)) for f in config['twee']['flags'])
    extraction = config.setdefault('extraction', {})
    for key, default in [('onlyProofTerms', True), ('onlyPeakTerms', False),
                         ('onlyTopLemmas', False), ('onlyUsedLemmas', False)]:
        extraction.setdefault(key, default)
    return config


def historical_config(new_config):
    """Undo exactly the two intentional changes in the prepared experiment."""
    old = deepcopy(new_config)
    flags = old['twee']['flags']
    if '--no-all-lemmas' not in flags or not old.get('extraction', {}).get('onlyUsedLemmas'):
        raise ValueError('Expected a goal-only config with --no-all-lemmas and onlyUsedLemmas: true')
    old['twee']['flags'] = ['--all-lemmas' if f == '--no-all-lemmas' else f for f in flags]
    old['extraction'].pop('onlyUsedLemmas')
    return old


def theory_of(problem):
    match = re.match(r'[A-Z]+', problem)
    return match.group() if match else ''


def load_results(root, target_config, theories):
    """Latest completed record per problem, with repeats and pending runs visible.

    Run directory names begin with timestamps. We order by that name, not
    filesystem mtime (which changes when archived data is copied).
    """
    root = Path(root)
    records = {}
    info = {'root': str(root), 'matching_runs': [], 'pending_runs': [],
            'partial_runs': [], 'unreadable_runs': [], 'ignored_config_runs': 0, 'repeated_problems': {}}
    counts = Counter()
    target = canonical_config(target_config)
    for path in sorted(root.rglob('config.yaml'), key=lambda p: (p.parent.name, str(p))):
        try:
            config = yaml.safe_load(path.read_text())
            if canonical_config(config) != target:
                info['ignored_config_runs'] += 1
                continue
        except (OSError, ValueError, KeyError, TypeError, yaml.YAMLError) as exc:
            info['unreadable_runs'].append({'run': str(path.parent), 'error': str(exc)})
            continue
        summary = path.with_name('summary.json')
        if not summary.exists():
            info['pending_runs'].append(str(path.parent))
            continue
        try:
            rows = json.loads(summary.read_text())
            if not isinstance(rows, list):
                raise ValueError('summary.json is not a list')
            if any(not isinstance(row, dict) or not isinstance(row.get('problem'), str) for row in rows):
                raise ValueError('summary contains a row without a problem name')
            names = [row['problem'] for row in rows]
            if len(set(names)) != len(names):
                raise ValueError('duplicate problem in one summary')
            state_file = path.with_name('run_state.json')
            if state_file.exists():
                state = json.loads(state_file.read_text())
                unfinished = set(state['expected_problems']) - set(names)
                if state.get('state') != 'complete' or unfinished:
                    info['partial_runs'].append({
                        'run': str(path.parent), 'state': state.get('state'),
                        'finished_count': len(rows), 'unfinished_count': len(unfinished),
                    })
        except (OSError, ValueError, KeyError, TypeError) as exc:
            info['unreadable_runs'].append({'run': str(path.parent), 'error': str(exc)})
            continue
        selected = [row for row in rows if theory_of(row['problem']) in theories]
        if not selected:
            continue
        info['matching_runs'].append(str(path.parent))
        for row in selected:
            problem = row['problem']
            counts[problem] += 1
            records[problem] = dict(row, source_run=str(path.parent))
    info['repeated_problems'] = {p: n for p, n in sorted(counts.items()) if n > 1}
    return records, info


def number(value):
    if isinstance(value, (int, float)) and not isinstance(value, bool) and math.isfinite(value) and value >= 0:
        return value
    return None


def ratio(numerator, denominator):
    if numerator is None or denominator is None or numerator <= 0 or denominator <= 0:
        return None
    return numerator / denominator


def outcome(record):
    if record is None:
        return 'missing'
    # Worker exceptions can occur after a successful subprocess return.
    if record.get('status') == 'error':
        return 'error'
    if record.get('hints_status') == 'success':
        if number(record.get('hints_time_user')) is None:
            return 'success_missing_time'
        return 'success'
    return record.get('hints_status') or record.get('status') or 'unknown'


def compare_records(old, new):
    rows = []
    for problem in sorted(old.keys() | new.keys()):
        row = {'problem': problem, 'theory': theory_of(problem)}
        for label, records in [('old', old), ('new', new)]:
            record = records.get(problem)
            state = outcome(record)
            record = record or {}
            base = number(record.get('mean_base_user_time'))
            hint = number(record.get('hints_time_user')) if state == 'success' else None
            row.update({f'{label}_status': state, f'{label}_run': record.get('source_run'),
                        f'{label}_base_user_s': base, f'{label}_hints_user_s': hint,
                        f'{label}_speedup': ratio(base, hint),
                        f'{label}_faster_than_base': hint < base if hint is not None and base is not None and base > 0 else None,
                        f'{label}_over_2x': hint < 0.5 * base if hint is not None and base is not None and base > 0 else None,
                        f'{label}_error': record.get('error'),
                        f'{label}_base_run': record.get('min_base_dir')})
        row['speedup_ratio_new_over_old'] = ratio(row['new_speedup'], row['old_speedup'])
        row['speedup_change_pct'] = (100 * (row['speedup_ratio_new_over_old'] - 1)
                                      if row['speedup_ratio_new_over_old'] is not None else None)
        row['hint_runtime_ratio_old_over_new'] = ratio(row['old_hints_user_s'], row['new_hints_user_s'])
        row['base_runtime_ratio_new_over_old'] = ratio(row['new_base_user_s'], row['old_base_user_s'])
        rows.append(row)
    return rows


def geometric_mean(values):
    return math.exp(statistics.mean(math.log(v) for v in values)) if values else None


def summarize(rows):
    common = [r for r in rows if r['old_status'] != 'missing' and r['new_status'] != 'missing']
    paired = [r for r in common if r['speedup_ratio_new_over_old'] is not None]
    transitions = Counter(f"{r['old_status']} -> {r['new_status']}" for r in common)
    result = {
        'old_problems': sum(r['old_status'] != 'missing' for r in rows),
        'new_problems': sum(r['new_status'] != 'missing' for r in rows),
        'common_problems': len(common), 'paired_positive_timings': len(paired),
        'old_only': sum(r['new_status'] == 'missing' for r in rows),
        'new_only': sum(r['old_status'] == 'missing' for r in rows),
        'outcome_transitions_on_common': dict(sorted(transitions.items())),
        'new_success_old_not_success': sum(r['new_status'] == 'success' and r['old_status'] != 'success' for r in common),
        'old_success_new_not_success': sum(r['old_status'] == 'success' and r['new_status'] != 'success' for r in common),
    }
    for side in ('old', 'new'):
        result[f'{side}_outcomes'] = dict(sorted(Counter(r[f'{side}_status'] for r in rows).items()))
        result[f'{side}_over_2x_on_common'] = sum(r[f'{side}_over_2x'] is True for r in common)
        result[f'{side}_faster_than_base_on_common'] = sum(r[f'{side}_faster_than_base'] is True for r in common)
        result[f'{side}_zero_hint_time'] = sum(r[f'{side}_hints_user_s'] == 0 for r in rows)
        values = [r[f'{side}_speedup'] for r in paired]
        result[f'{side}_geomean_speedup_paired'] = geometric_mean(values)
        result[f'{side}_median_speedup_paired'] = statistics.median(values) if values else None
    for key in ('speedup_ratio_new_over_old', 'hint_runtime_ratio_old_over_new', 'base_runtime_ratio_new_over_old'):
        result[f'geomean_{key}_paired'] = geometric_mean([r[key] for r in paired])
    result['speedup_wins_paired'] = sum(r['speedup_ratio_new_over_old'] > 1 for r in paired)
    result['speedup_losses_paired'] = sum(r['speedup_ratio_new_over_old'] < 1 for r in paired)
    result['speedup_ties_paired'] = sum(r['speedup_ratio_new_over_old'] == 1 for r in paired)
    return result


def plot_comparison(rows, path):
    import matplotlib
    matplotlib.use('Agg')
    import matplotlib.pyplot as plt

    paired = [r for r in rows if r['speedup_ratio_new_over_old'] is not None]
    if not paired:
        return False
    fig, ax = plt.subplots(figsize=(7, 6))
    for theory in sorted({r['theory'] for r in paired}):
        subset = [r for r in paired if r['theory'] == theory]
        ax.scatter([r['old_speedup'] for r in subset], [r['new_speedup'] for r in subset],
                   label=f'{theory} (n={len(subset)})', alpha=0.65, s=22)
    values = [r[f'{side}_speedup'] for r in paired for side in ('old', 'new')]
    lo, hi = min(values) / 1.3, max(values) * 1.3
    ax.plot([lo, hi], [lo, hi], color='black', linewidth=1, linestyle='--')
    ax.axhline(1, color='grey', linewidth=0.6)
    ax.axvline(1, color='grey', linewidth=0.6)
    ax.set(xscale='log', yscale='log', xlim=(lo, hi), ylim=(lo, hi),
           xlabel='Historical speedup (base / hints)', ylabel='Goal-only speedup (base / hints)',
           title='Paired successful problems: above diagonal = improved speedup')
    ax.legend()
    fig.tight_layout()
    fig.savefig(path, dpi=180)
    plt.close(fig)
    return True


def format_value(value):
    return 'n/a' if value is None else f'{value:.3f}'


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--old-root', type=Path, default=ROOT / 'data/experiments/local_abs_10iter')
    parser.add_argument('--new-root', type=Path, default=ROOT / 'data/experiments/goal_proof_only/local_abs')
    parser.add_argument('--config', type=Path, default=DEFAULT_CONFIG)
    parser.add_argument('--theories', nargs='+', default=['GRP', 'LAT'])
    parser.add_argument('--output-dir', type=Path, default=ROOT / 'data/experiments/goal_proof_only/comparison')
    parser.add_argument('--plot', action='store_true', help='Save speedups.png when paired data exists')
    args = parser.parse_args(argv)
    target = yaml.safe_load(args.config.read_text())
    old, old_info = load_results(args.old_root, historical_config(target), args.theories)
    new, new_info = load_results(args.new_root, target, args.theories)
    rows = compare_records(old, new)
    report = {
        'definitions': {
            'speedup': 'mean_base_user_time / hints_time_user; excludes extraction and total pipeline time',
            'speedup_ratio_new_over_old': 'new_speedup / old_speedup; above 1 is an improvement',
            'hint_runtime_ratio_old_over_new': 'old_hints_time_user / new_hints_time_user; above 1 is faster now',
            'base_runtime_ratio_new_over_old': 'new_mean_base_user_time / old_mean_base_user_time',
            'over_2x': 'hints_time_user < 0.5 * mean_base_user_time (strict historical criterion)',
            'repeats': 'latest completed record per problem by timestamped run directory name; no best-of selection',
            'paired': 'same problems, both successful, with strictly positive finite baseline and hint CPU times',
            'missing_or_zero_times': 'undefined ratios are null, never infinity or an epsilon substitute',
            'incomplete': 'partial snapshots are included and flagged; missing/unfinished problems are not failures',
        },
        'comparison_config': target, 'historical_config': historical_config(target),
        'theories': args.theories, 'old_input': old_info, 'new_input': new_info,
        'overall': summarize(rows),
        'by_theory': {t: summarize([r for r in rows if r['theory'] == t]) for t in args.theories},
    }
    args.output_dir.mkdir(parents=True, exist_ok=True)
    (args.output_dir / 'summary.json').write_text(json.dumps(report, indent=2, allow_nan=False) + '\n')
    with (args.output_dir / 'per_problem.csv').open('w', newline='') as f:
        # Retain a usable header even while no matching runs exist.
        fields = list(rows[0]) if rows else list(compare_records({'EXAMPLE': {}}, {})[0])
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()
        writer.writerows(rows)
    print('Speedup = baseline / hinted user CPU time; paired geometric means use identical problems.')
    print('Group   Old  New Common Paired   Old speedup New speedup New/old speedup  Wins/Losses')
    for name, stats in [('ALL', report['overall']), *report['by_theory'].items()]:
        print(f"{name:5} {stats['old_problems']:5} {stats['new_problems']:4} {stats['common_problems']:6} "
              f"{stats['paired_positive_timings']:6} {format_value(stats['old_geomean_speedup_paired']):>13} "
              f"{format_value(stats['new_geomean_speedup_paired']):>11} "
              f"{format_value(stats['geomean_speedup_ratio_new_over_old_paired']):>15} "
              f"{stats['speedup_wins_paired']:5}/{stats['speedup_losses_paired']}")
        print(f"      >2x on common: old={stats['old_over_2x_on_common']}, new={stats['new_over_2x_on_common']}; "
              f"success gained/lost={stats['new_success_old_not_success']}/{stats['old_success_new_not_success']}")
    for label, info in [('old', old_info), ('new', new_info)]:
        print(f"{label}: {len(info['matching_runs'])} matching summaries, {len(info['pending_runs'])} pending runs, "
              f"{len(info['partial_runs'])} partial runs, {len(info['unreadable_runs'])} unreadable runs, "
              f"{len(info['repeated_problems'])} repeated problems")
    if new_info['partial_runs']:
        print('New results include partial runs: speedups describe finished problems only; unfinished problems are excluded.')
    if not new:
        print('No completed matching new local results yet. Rerun this command when summaries are available.')
    if args.plot:
        if plot_comparison(rows, args.output_dir / 'speedups.png'):
            print(args.output_dir / 'speedups.png')
        else:
            print('No paired positive timings available to plot.')
    print(f'Reports: {args.output_dir / "summary.json"} and {args.output_dir / "per_problem.csv"}')
    return report


if __name__ == '__main__':
    main()
