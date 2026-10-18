"""Rank historical local runs and prepare the goal-only comparison (no jobs).

Run through containers/run.sh so the analysis dependencies are available.
"""
import ast
from collections import Counter, defaultdict
from copy import deepcopy
import json
import os
from pathlib import Path
import sys

import yaml

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from data.experiments.analysis import successes_per_config
from src.stitch.pipeline.main import prepare_pipeline


def main():
    successes = defaultdict(list)
    runs = []
    for path in sorted((ROOT / 'data/experiments/local_abs_10iter').glob('*/summary.json')):
        config = yaml.safe_load(path.with_name('config.yaml').read_text())
        rows = json.loads(path.read_text())
        runs.append((path, config, rows))
        for row in rows:
            base, hints = row.get('mean_base_user_time'), row.get('hints_time_user')
            if (row.get('hints_status') == 'success'
                    and isinstance(base, (int, float)) and isinstance(hints, (int, float))
                    and hints < 0.5 * base):
                successes[row['problem']].append({'config': config})
    ranked = successes_per_config(successes)
    key, problems = next(iter(ranked.items()))
    selected = {name: ast.literal_eval(value) for name, value in key}
    source_runs = []
    for path, config, rows in runs:
        candidate = {k: v for k, v in config.items() if k != 'theory'}
        if candidate == selected:
            source_runs.append({
                'directory': str(path.parent.relative_to(ROOT)),
                'problems': len(rows),
                'hints_successes': sum(r.get('hints_status') == 'success' for r in rows),
            })
    out = ROOT / 'src/stitch/configs/goal_proof_only'
    out.mkdir(parents=True, exist_ok=True)
    manifest = {
        'source': 'data/experiments/local_abs_10iter',
        'ranking_function': 'data.experiments.analysis.successes_per_config',
        'criterion': 'hints_status == success and hints_time_user < 0.5 * mean_base_user_time',
        'success_records': len(problems),
        'distinct_successful_problems': len(set(problems)),
        'successes_by_theory': dict(sorted(Counter(p[:3] for p in set(problems)).items())),
        'selected_historical_config': selected,
        'historical_runs': source_runs,
        'successful_problems': sorted(set(problems)),
        'top_five': [
            {'config': {k: ast.literal_eval(v) for k, v in cfg},
             'success_records': len(ps), 'distinct_problems': len(set(ps))}
            for cfg, ps in list(ranked.items())[:5]
        ],
    }
    (out / 'selection.json').write_text(json.dumps(manifest, indent=2) + '\n')
    local = deepcopy(selected)
    local['twee']['flags'] = ['--no-all-lemmas' if flag == '--all-lemmas' else flag
                              for flag in local['twee']['flags']]
    local['extraction']['onlyUsedLemmas'] = True
    base = {'twee': {'flags': [
        '--no-flatten-goal', '--no-all-lemmas', '--show-peaks',
        '--proof-on-saturation', '--max-time 1000',
    ], 'timeout': 1500}}
    for name, cfg in [('base', base), ('local_abs', local)]:
        (out / f'{name}.yaml').write_text(yaml.safe_dump(cfg, sort_keys=False))
    prefix = 'src/stitch/configs/goal_proof_only'
    result_root = 'data/experiments/goal_proof_only'
    pipeline = {
        'theories': ['GRP', 'LAT'],
        'slurm': {'account': 'c3se2026-1-12', 'partition': 'vera',
                  'cpus_per_task': 64, 'time': '0-05:00:00'},
        # Explicit exports win over .env via containers/run.sh.
        'environment': {'TWEE_PATH': '/usr/local/bin/twee_hints_v3', 'RAYON_NUM_THREADS': 1,
                        'LOG_DIR': os.environ['LOG_DIR']},
        'stages': {
            'base': {'config': f'{prefix}/base.yaml',
                     'input_dir': 'data/TPTP/{theory}_UEQ_UNSAT',
                     'output_dir': f'{result_root}/base/{{theory}}'},
            'local_abs': {'config': f'{prefix}/local_abs.yaml',
                          'input_dir': 'data/TPTP/{theory}_UEQ_UNSAT',
                          'output_dir': f'{result_root}/local_abs/{{theory}}',
                          'base_dir': f'{result_root}/base/{{theory}}'},
        },
    }
    (out / 'pipeline.yaml').write_text(yaml.safe_dump(pipeline, sort_keys=False))
    scripts = prepare_pipeline(pipeline, 'vera_jobs/goal_proof_only', 'goal_proof_only')
    print(f'Selected {len(problems)} successes on {len(set(problems))} distinct problems.')
    print(f'Historical selection: {out / "selection.json"}')
    for path in scripts:
        print(path)
    print('Prepared scripts only. No experiment jobs run or submitted.')


if __name__ == '__main__':
    main()
