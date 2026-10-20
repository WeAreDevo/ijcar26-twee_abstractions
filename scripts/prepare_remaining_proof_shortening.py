#!/usr/bin/env python3
"""Prepare (never submit) sparse arrays for unfinished and storage-failed runs."""
import argparse
from collections import Counter
from datetime import datetime, timezone
import json
from pathlib import Path
import re
import shlex
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from scripts.proof_shortening import DEFAULT_SUITE, METHODS, load_suite, remaining_reason
from scripts.experiment_storage import ResultStore, read_results
from src.stitch.pipeline.checkpoints import atomic_json


def array_indices(indices):
    groups = []
    for index in sorted(set(indices)):
        if groups and index == groups[-1][1] + 1:
            groups[-1][1] = index
        else:
            groups.append([index, index])
    return ','.join(str(start) if start == end else f'{start}-{end}' for start, end in groups)


def prepare(args):
    suite, templates, output = args.suite.resolve(), args.templates.resolve(), args.output.resolve()
    if output.exists():
        raise ValueError(f'{output} already exists; choose a new --output directory')
    manifest = load_suite(suite)
    plan = dict(created=datetime.now(timezone.utc).isoformat(), suite=str(suite),
                parallel_tasks_per_method=args.parallel_tasks, methods={},
                policy='Missing, interrupted, and explicit disk quota/space errors only; terminal results kept.',
                submitted=False)
    scripts = {}
    # Only read checkpoint data; raw-output compaction may continue concurrently.
    # Hold the checkpoint writer lock to select from a consistent snapshot.
    with ResultStore(suite, METHODS[0]).locked():
        for method in METHODS:
            rows = read_results(suite, method)
            selected, reasons, kept = [], Counter(), Counter()
            for index, problem in enumerate(manifest['problems']):
                name = problem['problem']
                previous = rows.get(name)
                reason = remaining_reason(previous, retry_storage_errors=True)
                if reason:
                    selected.append(dict(problem=name, shard=index // manifest['batch_size'],
                                         reason=reason, previous=previous))
                    reasons[reason] += 1
                else:
                    kept[previous['status']] += 1
            indices = sorted({p['shard'] for p in selected})
            expression = array_indices(indices)
            plan['methods'][method] = dict(problems=len(selected), tasks=len(indices),
                                          reasons=dict(reasons), kept=dict(kept),
                                          array=expression, selected=selected)
            if not indices:
                continue
            script = (templates / f'{method}.sh').read_text()
            if '--retry-storage-errors' in script:
                raise ValueError('Use the original method scripts as templates')
            script, count = re.subn(r'^#SBATCH --array=.*$',
                                   f'#SBATCH --array={expression}%{args.parallel_tasks}', script, flags=re.M)
            if count != 1:
                raise ValueError(f'Expected one array directive in {method}')
            script = re.sub(r'^(#SBATCH --job-name=.+)$', r'\1_remaining', script, flags=re.M)
            script = re.sub(r'^#SBATCH --output=.*$',
                            f'#SBATCH --output={output}/slurm_%x_%A_%a.out', script, flags=re.M)
            # Keep original shard numbers so results update the same batch files.
            command = ('exec bash containers/run.sh python -u scripts/proof_shortening.py run-shard '
                       f'--suite {shlex.quote(str(suite))} --method {method} '
                       '--retry-storage-errors --shard "${SLURM_ARRAY_TASK_ID:?Submit using sbatch}"')
            script, count = re.subn(r'^exec bash containers/run.sh .*run-shard.*$',
                                   lambda _: command, script, flags=re.M)
            if count != 1:
                raise ValueError(f'Expected one run-shard command in {method}')
            scripts[method] = script
        output.mkdir(parents=True)
        atomic_json(output / 'plan.json', plan)
        submit = ['#!/usr/bin/env bash', '# Prepared only; running this script submits the remaining arrays.',
                  'set -euo pipefail', f'cd {shlex.quote(str(ROOT))}',
                  f'parallel=${{PROOF_PARALLEL_TASKS:-{args.parallel_tasks}}}',
                  '[[ "$parallel" =~ ^[1-9][0-9]*$ ]] || { echo "PROOF_PARALLEL_TASKS must be positive" >&2; exit 1; }',
                  'bash containers/run.sh python scripts/proof_shortening.py check '
                  f'--suite {shlex.quote(str(suite))}']
        for method, script in scripts.items():
            path = output / f'{method}.sh'
            path.write_text(script)
            path.chmod(0o755)
            expression = plan['methods'][method]['array']
            submit.append(f'sbatch --array="{expression}%$parallel" {shlex.quote(str(path))}')
        (output / 'submit.sh').write_text('\n'.join(submit) + '\n')
        (output / 'submit.sh').chmod(0o755)
    summary = {method: {key: value for key, value in entry.items() if key != 'selected'}
               for method, entry in plan['methods'].items()}
    print(json.dumps(dict(methods=summary, submit=str(output / 'submit.sh'), submitted=False), indent=2))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--suite', type=Path, default=DEFAULT_SUITE)
    parser.add_argument('--templates', type=Path, default=ROOT / 'vera_jobs/proof_shortening')
    parser.add_argument('--output', type=Path, default=ROOT / 'vera_jobs/proof_shortening/remaining')
    parser.add_argument('--parallel-tasks', type=int, default=2)
    args = parser.parse_args()
    if args.parallel_tasks < 1:
        parser.error('--parallel-tasks must be positive')
    prepare(args)


if __name__ == '__main__':
    main()
