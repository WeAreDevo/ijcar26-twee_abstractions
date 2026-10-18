#!/usr/bin/env python3
"""Prepare, run and compare Krympa vs Twitch proof-shortening experiments.

Preparation never submits jobs. Each problem/phase runs in a separate process
group with a wall limit. Results are checkpointed independently and summaries
can be regenerated while jobs are running.
"""
import argparse
from collections import Counter
from concurrent.futures import ThreadPoolExecutor
import csv
from datetime import datetime, timezone
import hashlib
import json
import math
import os
from pathlib import Path
import shlex
import signal
import statistics
import subprocess
import sys
import threading
import time
import uuid

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from dotenv import load_dotenv
import yaml
from scripts.ueq_inputs import krympa_input
from src.proof_metrics import METRIC, measure_completed_twee_proof
from src.stitch.pipeline.checkpoints import atomic_json

METHODS = ('krympa', 'twitch_no_flatten', 'twitch_flatten')
DEFAULT_SUITE = ROOT / 'data/experiments/proof_shortening'
ACTIVE = set()
ACTIVE_LOCK = threading.Lock()
STOP = threading.Event()


def digest(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def discover(root, include_etp=False):
    """Deduplicate official problems by name; reject inconsistent copies."""
    import re
    problems = {}
    for path in sorted(Path(root).rglob('*.p')):
        text = path.read_text()
        official = re.search(r'^%\s*Status\s*:\s*Unsatisfiable\b', text, re.M)
        if not official and not (include_etp and path.parent.name == 'ETP_UEQ_UNSAT'):
            continue
        sha = digest(path)
        if path.stem in problems:
            if problems[path.stem]['sha256'] != sha:
                raise ValueError(f"Conflicting copies of {path.stem}")
            continue
        problems[path.stem] = dict(problem=path.stem, source=str(path.resolve()),
                                   sha256=sha, domain=path.stem[:3] if official else 'ETP')
    if not problems:
        raise ValueError(f"No UNSAT problems found in {root}")
    return [problems[name] for name in sorted(problems)]


def configs(flatten):
    flag = '--flatten-goal' if flatten else '--no-flatten-goal'
    common = [flag, '--no-all-lemmas', '--show-peaks']
    base = {'twee': {'flags': common + ['--proof-on-saturation', '--max-time 1000'],
                     'timeout': 1500}}
    local = {'twee': {'flags': common + ['--hint-skel-factor 0.2', '--hint-skel-cost 0'],
                      'timeout': 1000},
             'stitch': {'iterations': 10, 'max_arity': 10},
             'extraction': {'onlyProofTerms': True, 'onlyPeakTerms': False, 'onlyUsedLemmas': True}}
    return base, local


def existing_bases(roots):
    """Pin latest compatible completed attempt, including genuine base timeouts.

    Do not use historical all-lemma summaries whose raw proofs were lost or
    whose proof presentation differs. Explicit roots keep provenance reviewable.
    """
    found = {}
    expected = configs(False)[0]
    for root in roots:
        for path in sorted(Path(root).rglob('summary.json')):
            config_path = path.with_name('config.yaml')
            if not config_path.is_file():
                continue
            config = yaml.safe_load(config_path.read_text())
            if (set(config.get('twee', {}).get('flags', [])) != set(expected['twee']['flags'])
                    or config['twee'].get('timeout') != expected['twee']['timeout']):
                continue
            for row in json.loads(path.read_text()):
                if row.get('base_status') not in ('success', 'timeout'):
                    continue
                if row['base_status'] == 'success' and not row.get('base_proof_size'):
                    continue
                name = row['problem']
                candidate = dict(result=row, config=config, experiment=path.parent.name,
                                 summary=str(path.resolve()))
                if name not in found or candidate['experiment'] > found[name]['experiment']:
                    found[name] = candidate
    return found


def prepare(args):
    suite = args.suite.resolve()
    if suite.exists():
        raise ValueError(f"Suite already exists: {suite}; choose --suite for a new experiment")
    log_root = Path(os.environ['LOG_DIR']).resolve()
    tptp_root = Path(os.environ['TPTP_ROOT']).resolve()
    problems = discover(args.inputs, args.include_etp)
    bases = existing_bases(args.base_root or [ROOT / 'data/experiments/goal_proof_only/base'])
    # Validate every input and include before emitting submission scripts.
    converted = {p['problem']: krympa_input(p['source'], tptp_root) for p in problems}
    suite.mkdir(parents=True)
    for problem in problems:
        name = problem['problem']
        target = suite / 'krympa_inputs' / f'{name}.p'
        target.parent.mkdir(exist_ok=True)
        target.write_text(converted[name])
        problem['krympa_input'] = str(target)
        problem['krympa_sha256'] = digest(target)
        if name in bases:
            problem['no_flatten_base'] = bases[name]
    label = args.label
    if not label or any(c not in 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-' for c in label):
        raise ValueError('Use letters, digits, underscores or hyphens in --label')
    manifest = dict(schema_version=1, label=label, metric=METRIC,
                    created=datetime.now(timezone.utc).isoformat(),
                    log_root=str(log_root), tptp_root=str(tptp_root),
                    environment={'TWEE_PATH': '/usr/local/bin/twee_hints_v3',
                                 'VAMPIRE_PATH': '/usr/local/bin/vampire',
                                 'RAYON_NUM_THREADS': '1'},
                    limits={'base': 1530, 'local_abs': 1800, 'krympa': 1000},
                    workers=args.workers, batch_size=args.batch_size, problems=problems,
                    configs={})
    for method, flatten in [('twitch_no_flatten', False), ('twitch_flatten', True)]:
        base, local = configs(flatten)
        manifest['configs'][method] = {'base': base, 'local_abs': local}
        for stage, config in manifest['configs'][method].items():
            path = suite / 'configs' / f'{method}_{stage}.yaml'
            path.parent.mkdir(exist_ok=True)
            path.write_text(yaml.safe_dump(config, sort_keys=False))
    atomic_json(suite / 'manifest.json', manifest)
    jobs = args.scripts_dir.resolve()
    jobs.mkdir(parents=True, exist_ok=True)
    count = math.ceil(len(problems) / args.batch_size)
    for method in METHODS:
        script = ["#!/usr/bin/env bash", f"#SBATCH --account={args.account}",
                  '#SBATCH --partition=vera', f'#SBATCH --job-name={label}_{method}',
                  '#SBATCH --ntasks=1', f'#SBATCH --cpus-per-task={args.workers}',
                  '#SBATCH --mem=64G', '#SBATCH --time=0-03:00:00',
                  f'#SBATCH --array=0-{count-1}%{args.parallel_shards}',
                  f'#SBATCH --output={jobs}/slurm_%x_%A_%a.out',
                  'set -euo pipefail', f'cd {shlex.quote(str(ROOT))}']
        for key, value in dict(manifest['environment'], LOG_DIR=str(log_root),
                               TPTP_ROOT=str(tptp_root)).items():
            script.append(f'export {key}={shlex.quote(value)}')
        # A reviewed upper bound, overridable downward through the environment.
        script += [f'export TWITCH_MAX_WORKERS="${{TWITCH_MAX_WORKERS:-{args.workers}}}"',
                   'exec bash containers/run.sh python -u scripts/proof_shortening.py run-shard '
                   f'--suite {shlex.quote(str(suite))} --method {method} '
                   '--shard "${SLURM_ARRAY_TASK_ID:?Submit using sbatch}"', '']
        (jobs / f'{method}.sh').write_text('\n'.join(script))
    submit = ['#!/usr/bin/env bash', '# Review the manifest and the three arrays before submission.',
              'set -euo pipefail', f'cd {shlex.quote(str(ROOT))}',
              'bash containers/run.sh python scripts/proof_shortening.py check '
              f'--suite {shlex.quote(str(suite))}']
    submit += [f'sbatch {shlex.quote(str(jobs / (method + ".sh")))}' for method in METHODS]
    (jobs / 'submit.sh').write_text('\n'.join(submit) + '\n')
    for path in jobs.glob('*.sh'):
        path.chmod(0o755)
    reused = [p['no_flatten_base']['result'] for p in problems if 'no_flatten_base' in p]
    plan = dict(problems=len(problems), domains=dict(Counter(p['domain'] for p in problems)),
                reuse_no_flatten=dict(Counter(r['base_status'] for r in reused)),
                new_no_flatten_bases=len(problems)-len(reused), new_flatten_bases=len(problems),
                shards_per_method=count, workers_per_shard=args.workers,
                max_parallel_shards_per_method=args.parallel_shards,
                scripts=str(jobs), note='Prepared only; no jobs submitted.')
    atomic_json(suite / 'plan.json', plan)
    print(json.dumps(plan, indent=2))


def load_suite(suite):
    return json.loads((suite / 'manifest.json').read_text())


def check(suite, manifest):
    """Run on the submitting host; fail early on missing reused proofs/access."""
    root = Path(manifest['log_root'])
    root.stat()  # Preserve PermissionError rather than disguising it as absent.
    if not os.access(root, os.W_OK | os.X_OK):
        raise ValueError(f'LOG_DIR is not writable: {root}')
    checked = 0
    for p in manifest['problems']:
        if digest(p['source']) != p['sha256'] or digest(p['krympa_input']) != p['krympa_sha256']:
            raise ValueError(f"Input changed after preparation: {p['problem']}")
        if krympa_input(p['source'], manifest['tptp_root']) != Path(p['krympa_input']).read_text():
            raise ValueError(f"Included axioms changed after preparation: {p['problem']}")
        reused = p.get('no_flatten_base')
        if reused and reused['result']['base_status'] == 'success':
            path = root / reused['experiment'] / f"{p['problem']}_base_output.txt"
            size = measure_completed_twee_proof(path.read_text())
            if size != reused['result']['base_proof_size']:
                raise ValueError(f'Reused proof missing, incomplete or changed: {path}')
            checked += 1
    print(f"Checked {len(manifest['problems'])} inputs and {checked} reused proofs; LOG_DIR is writable.")


def stop_process(process):
    try:
        os.killpg(process.pid, signal.SIGTERM)
    except ProcessLookupError:
        return
    try:
        process.wait(timeout=5)
    except subprocess.TimeoutExpired:
        pass
    try:
        os.killpg(process.pid, signal.SIGKILL)
    except ProcessLookupError:
        pass
    process.wait()


def run_command(command, log, timeout):
    start = time.monotonic()
    with log.open('w') as output:
        with ACTIVE_LOCK:
            if STOP.is_set():
                return {'status': 'interrupted'}
            process = subprocess.Popen(command, stdout=output, stderr=subprocess.STDOUT,
                                       start_new_session=True, cwd=ROOT)
            ACTIVE.add(process)
        try:
            try:
                code = process.wait(timeout=timeout)
                status = 'success' if code == 0 else 'error'
            except subprocess.TimeoutExpired:
                stop_process(process)
                code, status = process.returncode, 'timeout'
            if STOP.is_set():
                status = 'interrupted'
            return {'status': status, 'exit_code': code, 'wall_seconds': time.monotonic()-start}
        finally:
            with ACTIVE_LOCK:
                ACTIVE.discard(process)


def twitch_phase(args):
    # Import native Stitch only in the isolated child, never in the scheduler.
    from src.stitch.pipeline import worker
    request = json.loads(args.request.read_text())
    source, config, raw = Path(request['source']), request['config'], Path(request['raw'])
    if request['stage'] == 'base':
        result = worker.base_stage((source, config, raw))
    else:
        worker.init_worker({source.stem: [request['base_entry']]}, None, None)
        result = worker.local_abs_stage((source, config, raw))
    atomic_json(raw / 'result.json', result)


def run_phase(source, config, stage, raw, limit, base_entry=None):
    raw.mkdir(parents=True, exist_ok=False)
    request = dict(source=source, config=config, stage=stage, raw=str(raw), base_entry=base_entry)
    atomic_json(raw / 'request.json', request)
    outcome = run_command([sys.executable, '-u', str(Path(__file__).resolve()), '_twitch-phase',
                           '--request', str(raw / 'request.json')], raw / 'worker.log', limit)
    path = raw / 'result.json'
    result = json.loads(path.read_text()) if path.exists() else {'status': outcome['status']}
    result['phase_execution'] = outcome
    return result


def execute_problem(suite, manifest, method, problem):
    name = problem['problem']
    result_path = suite / 'results' / method / f'{name}.json'
    previous = {}
    if result_path.exists():
        previous = json.loads(result_path.read_text())
        if previous['status'] not in ('running', 'interrupted'):
            return previous  # Explicitly keep failed/timeout attempts on resume too.
    attempt = datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S') + '_' + uuid.uuid4().hex[:8]
    log_root = Path(manifest['log_root'])
    raw = log_root / manifest['label'] / method / name / attempt
    raw.mkdir(parents=True, exist_ok=False)
    row = dict(problem=name, method=method, status='running', raw_dir=str(raw),
               source=problem['source'], attempt=attempt, metric=METRIC)

    def save():
        atomic_json(raw / 'checkpoint.json', row)
        atomic_json(result_path, row)

    save()
    try:
        if digest(problem['source']) != problem['sha256']:
            raise ValueError('Source input changed after preparation')
        if method == 'krympa':
            if digest(problem['krympa_input']) != problem['krympa_sha256']:
                raise ValueError('Converted input changed after preparation')
            input_path = raw / f'{name}.p'
            input_path.write_text(Path(problem['krympa_input']).read_text())
            command = [sys.executable, '-u', str(ROOT / 'scripts/run_krympa.py'), str(input_path),
                       '--output-dir', str(raw / 'pipeline'), '--sequential',
                       '--timeout', str(manifest['limits']['krympa'])]
            outcome = run_command(command, raw / 'launcher.log', manifest['limits']['krympa'] + 30)
            path = raw / 'pipeline/run.json'
            details = json.loads(path.read_text()) if path.exists() else {}
            row.update(krympa=details, execution=outcome,
                       status='success' if details.get('status') == 'completed' else
                       ('timeout' if details.get('status') == 'timeout' or outcome['status'] == 'timeout' else 'error'))
            if outcome['status'] == 'interrupted':
                row['status'] = 'interrupted'
        else:
            config = manifest['configs'][method]
            reused = problem.get('no_flatten_base') if method == 'twitch_no_flatten' else None
            saved_base = previous.get('base', {})
            if (previous.get('base_experiment') and
                    (saved_base.get('base_status') in ('success', 'timeout') or saved_base.get('status') == 'timeout')):
                base = previous['base']
                experiment = previous['base_experiment']
                row['base_reused_from'] = str(result_path) + ':' + previous['attempt']
            elif reused:
                base = reused['result']
                row['base_reused_from'] = reused['summary']
                experiment = reused['experiment']
            else:
                base = run_phase(problem['source'], config['base'], 'base', raw / 'base',
                                 manifest['limits']['base'])
                experiment = str((raw / 'base').relative_to(log_root))
            row['base'] = base
            row['base_experiment'] = experiment
            save()  # Keep newly computed base results even if compression is killed.
            if base.get('base_proof_size') is None:
                base_status = base.get('base_status', base.get('status', 'no_proof'))
                row['status'] = 'base_' + ('no_proof' if base_status == 'success' else base_status)
            else:
                proof = log_root / experiment / f'{name}_base_output.txt'
                if measure_completed_twee_proof(proof.read_text()) != base['base_proof_size']:
                    raise ValueError(f'Base proof changed or is incomplete: {proof}')
                entry = dict(experiment=experiment, user_time=base['base_time_user'], config=config['base'])
                local = run_phase(problem['source'], config['local_abs'], 'local_abs', raw / 'local_abs',
                                  manifest['limits']['local_abs'], entry)
                row['local_abs'] = local
                row['status'] = ('success' if local.get('hints_proof_size') is not None else
                                 local.get('status', local.get('hints_status', 'no_proof')))
                if row['status'] == 'success' and local.get('hints_proof_size') is None:
                    row['status'] = 'no_proof'
        if STOP.is_set():
            row['status'] = 'interrupted'
    except Exception as exc:
        row.update(status='error', error=f'{type(exc).__name__}: {exc}')
    save()
    return row


def run_shard(args, manifest):
    manifest_env = dict(manifest['environment'], LOG_DIR=manifest['log_root'], TPTP_ROOT=manifest['tptp_root'])
    os.environ.update(manifest_env)
    start = args.shard * manifest['batch_size']
    problems = manifest['problems'][start:start+manifest['batch_size']]
    if args.shard < 0 or not problems:
        raise ValueError('Invalid shard index')
    affinity = len(os.sched_getaffinity(0))
    workers = min(affinity, manifest['workers'], int(os.environ.get('SLURM_CPUS_PER_TASK', affinity)),
                  int(os.environ.get('TWITCH_MAX_WORKERS', manifest['workers'])))
    if workers < 1:
        raise ValueError('Worker limits must be positive')
    directory = args.suite / 'shards' / args.method / str(args.shard)
    rows = {}

    def snapshot():
        atomic_json(directory / 'summary.json', [rows[k] for k in sorted(rows)])
        atomic_json(directory / 'run_state.json', dict(
            expected=[p['problem'] for p in problems], finished=len(rows),
            state='interrupted' if STOP.is_set() else ('complete' if len(rows) == len(problems) else 'running')))

    def interrupted(signum, frame):
        STOP.set()

    signal.signal(signal.SIGTERM, interrupted)
    signal.signal(signal.SIGINT, interrupted)
    print(f'{args.method}: shard {args.shard}, {len(problems)} problems, {workers} concurrent problems', flush=True)
    snapshot()
    with ThreadPoolExecutor(max_workers=workers) as pool:
        futures = {pool.submit(execute_problem, args.suite, manifest, args.method, p): p for p in problems}
        # Poll so SIGTERM also terminates active process groups promptly.
        from concurrent.futures import wait, FIRST_COMPLETED
        pending = set(futures)
        while pending:
            done, pending = wait(pending, timeout=0.5, return_when=FIRST_COMPLETED)
            if STOP.is_set():
                with ACTIVE_LOCK:
                    active = list(ACTIVE)
                for process in active:
                    stop_process(process)
            for future in done:
                p = futures[future]
                try:
                    row = future.result()
                except Exception as exc:
                    row = dict(problem=p['problem'], method=args.method, status='error', error=str(exc))
                    atomic_json(args.suite / 'results' / args.method / f"{p['problem']}.json", row)
                rows[row['problem']] = row
                snapshot()
                print(f"{row['problem']}: {row['status']} ({len(rows)}/{len(problems)})", flush=True)
    if STOP.is_set():
        raise SystemExit(143)


def measurements(row):
    if not row:
        return None, None, False
    if row['method'] == 'krympa':
        size = row.get('krympa', {}).get('proof_size', {})
        valid = (row.get('status') == 'success' and size.get('metric') == METRIC and size.get('counts_match') is True
                 and size.get('reference_revision_matches') is True)
        return size.get('baseline_steps'), size.get('steps'), valid
    base = row.get('base', {}).get('base_proof_size') or {}
    final = row.get('local_abs', {}).get('hints_proof_size') or {}
    return (base.get('steps'), final.get('steps'), row.get('status') == 'success'
            and base.get('metric') == final.get('metric') == METRIC)


def report(suite, manifest):
    rows, outcomes = [], {m: Counter() for m in METHODS}
    paired = {m: [] for m in METHODS[1:]}
    for problem in manifest['problems']:
        name = problem['problem']
        record = dict(problem=name, domain=problem['domain'])
        sizes = {}
        for method in METHODS:
            path = suite / 'results' / method / f'{name}.json'
            row = json.loads(path.read_text()) if path.exists() else {}
            status = row.get('status', 'pending')
            outcomes[method][status] += 1
            base, final, valid = measurements(row)
            sizes[method] = final if valid else None
            fields = dict(status=status, baseline_steps=base, final_steps=final, comparable=valid,
                          reduction_fraction=(base-final)/base if valid and base and final is not None else None,
                          raw_dir=row.get('raw_dir'), error=row.get('error'))
            if method == 'krympa':
                size = row.get('krympa', {}).get('proof_size', {})
                fields.update(reported_steps=size.get('reported_steps'), benchmark_steps=size.get('benchmark_steps'),
                              counts_match=size.get('counts_match'))
            record.update({f'{method}_{key}': value for key, value in fields.items()})
        for method in METHODS[1:]:
            k, t = sizes['krympa'], sizes[method]
            if k is not None and t is not None:
                paired[method].append((k, t))
            record[f'{method}_krympa_over_twitch_steps'] = k/t if k and t else None
        rows.append(record)
    comparison = {}
    for method, pairs in paired.items():
        positive = [k/t for k, t in pairs if k > 0 and t > 0]
        comparison[method] = dict(
            paired_proofs=len(pairs), twitch_shorter=sum(t < k for k, t in pairs),
            equal=sum(t == k for k, t in pairs), krympa_shorter=sum(k < t for k, t in pairs),
            positive_ratio_pairs=len(positive),
            median_krympa_over_twitch=statistics.median(positive) if positive else None,
            geometric_mean_krympa_over_twitch=statistics.geometric_mean(positive) if positive else None)
    output = suite / 'comparison'
    output.mkdir(exist_ok=True)
    with (output / 'per_problem.csv').open('w', newline='') as stream:
        writer = csv.DictWriter(stream, fieldnames=list(rows[0]))
        writer.writeheader()
        writer.writerows(rows)
    reductions = {}
    for method in METHODS:
        valid = [r for r in rows if r[f'{method}_comparable']]
        fractions = [r[f'{method}_reduction_fraction'] for r in valid
                     if r[f'{method}_reduction_fraction'] is not None]
        reductions[method] = dict(
            measured_proofs=len(valid),
            shortened=sum(r[f'{method}_final_steps'] < r[f'{method}_baseline_steps'] for r in valid),
            equal=sum(r[f'{method}_final_steps'] == r[f'{method}_baseline_steps'] for r in valid),
            lengthened=sum(r[f'{method}_final_steps'] > r[f'{method}_baseline_steps'] for r in valid),
            median_reduction_fraction=statistics.median(fractions) if fractions else None)
    summary = dict(metric=METRIC, problems=len(rows), outcomes=outcomes, comparisons=comparison,
                   reductions_from_own_baseline=reductions,
                   notes=['Final artifact steps; Krympa accounting/revision mismatches excluded from paired statistics.',
                          'Reduction fractions use each method\'s own baseline: Vampire for Krympa, Twee for Twitch.',
                          'Missing and failed runs are not assigned proof lengths; zero-step proofs are valid, ratios require positive steps.',
                          'Krympa uses equivalent FOF inputs; Twitch retains original CNF inputs.'])
    atomic_json(output / 'summary.json', summary)
    print(json.dumps(summary, indent=2))


def main():
    load_dotenv(ROOT / '.env', override=False)
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest='command', required=True)
    prep = commands.add_parser('prepare', help='Write manifest/configs/Slurm scripts; never submit')
    prep.add_argument('--suite', type=Path, default=DEFAULT_SUITE)
    prep.add_argument('--inputs', type=Path, default=ROOT / 'data/TPTP')
    prep.add_argument('--include-etp', action='store_true')
    prep.add_argument('--base-root', type=Path, action='append', help='Compatible prior base summaries (repeatable)')
    prep.add_argument('--scripts-dir', type=Path, default=ROOT / 'vera_jobs/proof_shortening')
    prep.add_argument('--label', default='proof_shortening')
    prep.add_argument('--account', default='c3se2026-1-12')
    prep.add_argument('--workers', type=int, default=4)
    prep.add_argument('--batch-size', type=int, default=8)
    prep.add_argument('--parallel-shards', type=int, default=2)
    for command in ('check', 'report', 'run-shard'):
        sub = commands.add_parser(command)
        sub.add_argument('--suite', type=Path, default=DEFAULT_SUITE)
        if command == 'run-shard':
            sub.add_argument('--method', choices=METHODS, required=True)
            sub.add_argument('--shard', type=int, required=True)
    phase = commands.add_parser('_twitch-phase', help=argparse.SUPPRESS)
    phase.add_argument('--request', type=Path, required=True)
    args = parser.parse_args()
    if args.command == '_twitch-phase':
        twitch_phase(args)
    elif args.command == 'prepare':
        if min(args.workers, args.batch_size, args.parallel_shards) < 1:
            parser.error('workers, batch-size and parallel-shards must be positive')
        prepare(args)
    else:
        args.suite = args.suite.resolve()
        manifest = load_suite(args.suite)
        if args.command == 'check':
            check(args.suite, manifest)
        elif args.command == 'report':
            report(args.suite, manifest)
        else:
            run_shard(args, manifest)


if __name__ == '__main__':
    main()
