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
import shutil
import signal
import statistics
import subprocess
import sys
import threading
import tempfile
import time
import uuid

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from dotenv import load_dotenv
import yaml
from scripts.ueq_inputs import krympa_input
from scripts.experiment_storage import (ResultStore, compact_suite, publish_archive, read_artifact,
                                       read_input, read_results, suite_access, write_inputs)
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
    write_inputs(suite, converted)
    for problem in problems:
        name = problem['problem']
        problem['krympa_input'] = str(suite / 'krympa_inputs.json.gz') + '#' + name
        problem['krympa_sha256'] = hashlib.sha256(converted[name].encode()).hexdigest()
        if name in bases:
            problem['no_flatten_base'] = bases[name]
    label = args.label
    if not label or any(c not in 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_-' for c in label):
        raise ValueError('Use letters, digits, underscores or hyphens in --label')
    manifest = dict(schema_version=2, label=label, metric=METRIC,
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
                  '#SBATCH --signal=B:TERM@180',
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
    # Permissions alone do not detect an exhausted file or byte quota.
    with tempfile.TemporaryFile(dir=root) as probe:
        probe.write(b'proof-shortening submission check\n')
        probe.flush()
        os.fsync(probe.fileno())
    checked = 0
    for p in manifest['problems']:
        converted = read_input(suite, p)
        if digest(p['source']) != p['sha256'] or hashlib.sha256(converted.encode()).hexdigest() != p['krympa_sha256']:
            raise ValueError(f"Input changed after preparation: {p['problem']}")
        if krympa_input(p['source'], manifest['tptp_root']) != converted:
            raise ValueError(f"Included axioms changed after preparation: {p['problem']}")
        reused = p.get('no_flatten_base')
        if reused and reused['result']['base_status'] == 'success':
            path = root / reused['experiment'] / f"{p['problem']}_base_output.txt"
            size = measure_completed_twee_proof(read_artifact(path))
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


def scratch_directory(suite, log_root):
    scratch = Path(os.environ.get('PROOF_SCRATCH_DIR', '/tmp')).resolve()
    if any(scratch.is_relative_to(Path(p).resolve()) for p in (suite, log_root, ROOT)):
        raise ValueError('PROOF_SCRATCH_DIR must be outside the project and LOG_DIR')
    scratch.mkdir(parents=True, exist_ok=True)
    return Path(tempfile.mkdtemp(prefix='proof-shortening-', dir=scratch))


def remaining_reason(row, retry_storage_errors=False):
    if not row:
        return 'missing'
    if row.get('status') in ('running', 'interrupted') or row.get('artifact_status') == 'publishing':
        return 'unfinished'
    if retry_storage_errors and row.get('status') in ('error', 'base_error'):
        errors = json.dumps({key: row.get(key) for key in
                             ('error', 'storage_error', 'checkpoint_error', 'base', 'local_abs', 'krympa')}).lower()
        if any(marker in errors for marker in ('disk quota exceeded', 'no space left on device',
                                               'errno 122', 'errno 28')):
            return 'storage_error'
    return None


def execute_problem(suite, manifest, method, problem, store=None, retry_storage_errors=False):
    name = problem['problem']
    if store is None:
        index = next((i for i, p in enumerate(manifest.get('problems', [])) if p['problem'] == name), 0)
        store = ResultStore(suite, method, index // manifest.get('batch_size', 8))
    result_path = str(store.path) + '#' + name
    previous = store.get(name) or {}
    if remaining_reason(previous, retry_storage_errors) is None:
        return previous  # Keep completed results and genuine terminal failures.
    if STOP.is_set():
        return previous or dict(problem=name, method=method, status='interrupted')
    attempt = datetime.now(timezone.utc).strftime('%Y%m%dT%H%M%S') + '_' + uuid.uuid4().hex[:8]
    log_root = Path(manifest['log_root'])
    logical = log_root / manifest['label'] / method / f'{name}_{attempt}'
    archive_path = logical.with_name(logical.name + '.tar.gz')
    scratch = scratch_directory(suite, log_root)
    raw = scratch / logical.name
    raw.mkdir(parents=True, exist_ok=False)
    row = dict(problem=name, method=method, status='running', raw_dir=str(logical),
               artifact_archive=str(archive_path), artifact_prefix=raw.name,
               artifact_status='pending', scratch_dir=str(raw),
               source=problem['source'], attempt=attempt, metric=METRIC)
    if previous:
        row['previous_attempt'] = previous

    def save():
        # Preserve the compact result even if the separate raw-output quota is full.
        store.save(row)
        atomic_json(raw / 'checkpoint.json', row)

    def snapshot_archive(state):
        row['artifact_status'] = state
        if method == 'krympa':
            outputs = [Path('pipeline/output') / f'proof_{name}.out']
        else:
            outputs = [Path('base') / f'{name}_base_output.txt',
                       Path('local_abs') / f'{name}_with_hints_output.txt']
        outputs = [path for path in outputs if (raw / path).is_file()]
        row['retained_files'] = [str(path) for path in outputs]
        if method != 'krympa':
            row['retained_files'].append('checkpoint.json')
        if not row['retained_files']:
            # Failed Krympa attempts without a final output need no LOG_DIR file;
            # status, error, timings and counts remain in the batch checkpoint.
            row.update(artifact_status='no_output', artifact_archive=None)
            store.save(row)
            return
        # A hard kill during publication must not make a terminal result skip
        # resumption when only the earlier base snapshot reached LOG_DIR.
        store.save(dict(row, artifact_status='publishing'))
        retained = scratch / 'retained' / raw.name
        retained.mkdir(parents=True, exist_ok=True)
        for path in outputs:
            target = retained / path
            target.parent.mkdir(parents=True, exist_ok=True)
            shutil.copyfile(raw / path, target)
        if method != 'krympa':
            atomic_json(retained / 'checkpoint.json', row)
        publish_archive(retained, archive_path)
        store.save(row)

    save()
    try:
        if digest(problem['source']) != problem['sha256']:
            raise ValueError('Source input changed after preparation')
        if method == 'krympa':
            converted = read_input(suite, problem)
            if hashlib.sha256(converted.encode()).hexdigest() != problem['krympa_sha256']:
                raise ValueError('Converted input changed after preparation')
            input_path = raw / f'{name}.p'
            input_path.write_text(converted)
            command = [sys.executable, '-u', str(ROOT / 'scripts/run_krympa.py'), str(input_path),
                       '--output-dir', str(raw / 'pipeline'), '--sequential',
                       '--timeout', str(manifest['limits']['krympa'])]
            outcome = run_command(command, raw / 'launcher.log', manifest['limits']['krympa'] + 30)
            path = raw / 'pipeline/run.json'
            details = json.loads(path.read_text()) if path.exists() else {}
            if details.get('proof'):
                details['proof'] = str(logical / Path(details['proof']).relative_to(raw))
            if details.get('input'):
                details['input'] = str(logical / f'{name}.p')
            row.update(krympa=details, execution=outcome,
                       status='success' if details.get('status') == 'completed' else
                       ('timeout' if details.get('status') == 'timeout' or outcome['status'] == 'timeout' else 'error'))
            if outcome['status'] == 'interrupted':
                row['status'] = 'interrupted'
        else:
            config = manifest['configs'][method]
            reused = problem.get('no_flatten_base') if method == 'twitch_no_flatten' else None
            saved_base = previous.get('base', {})
            base_text = None
            if (previous.get('base_experiment') and
                    (saved_base.get('base_status') in ('success', 'timeout') or saved_base.get('status') == 'timeout')):
                try:
                    if saved_base.get('base_proof_size') is not None:
                        base_text = read_artifact(log_root / previous['base_experiment'] / f'{name}_base_output.txt')
                    base = saved_base
                    experiment = previous['base_experiment']
                    row['base_reused_from'] = str(result_path) + ':' + previous['attempt']
                except FileNotFoundError:
                    # A hard kill can happen before the first archive is published.
                    # Preserve the earlier checkpoint but recompute an unavailable base.
                    saved_base = {}
                    row['unavailable_previous_base'] = previous['base_experiment']
            else:
                saved_base = {}
            if not saved_base and reused:
                base = reused['result']
                row['base_reused_from'] = reused['summary']
                experiment = reused['experiment']
                if base.get('base_proof_size') is not None:
                    base_text = read_artifact(log_root / experiment / f'{name}_base_output.txt')
            elif not saved_base:
                base = run_phase(problem['source'], config['base'], 'base', raw / 'base',
                                 manifest['limits']['base'])
                experiment = str((logical / 'base').relative_to(log_root))
                if base.get('base_proof_size') is not None:
                    base_text = (raw / 'base' / f'{name}_base_output.txt').read_text()
            row['base'] = base
            row['base_experiment'] = experiment
            if base.get('base_proof_size') is not None:
                proof = raw / 'base' / f'{name}_base_output.txt'
                if base_text is None or measure_completed_twee_proof(base_text) != base['base_proof_size']:
                    raise ValueError(f'Base proof changed or is incomplete: {proof}')
                # Materialize just the reused proof, never an entire archived tree.
                proof.parent.mkdir(exist_ok=True)
                proof.write_text(base_text)
                row['base_experiment'] = str((logical / 'base').relative_to(log_root))
            # Publish a self-contained base snapshot before the long Stitch call.
            snapshot_archive('base_saved')
            if base.get('base_proof_size') is None:
                base_status = base.get('base_status', base.get('status', 'no_proof'))
                row['status'] = 'base_' + ('no_proof' if base_status == 'success' else base_status)
            else:
                entry = dict(experiment=experiment, output_file=str(proof),
                             user_time=base['base_time_user'], config=config['base'])
                local = run_phase(problem['source'], config['local_abs'], 'local_abs', raw / 'local_abs',
                                  manifest['limits']['local_abs'], entry)
                row['local_abs'] = local
                if local.get('base_output_file'):
                    local['base_output_file'] = str(logical / 'base' / f'{name}_base_output.txt')
                row['status'] = ('success' if local.get('hints_proof_size') is not None else
                                 local.get('status', local.get('hints_status', 'no_proof')))
                if row['status'] == 'success' and local.get('hints_proof_size') is None:
                    row['status'] = 'no_proof'
        if STOP.is_set():
            row['status'] = 'interrupted'
    except Exception as exc:
        row.update(status='error', error=f'{type(exc).__name__}: {exc}')
    try:
        snapshot_archive('archived')
    except Exception as exc:
        # Keep scratch for recovery, preserve metrics, stop this batch rather
        # than generating more files against a full quota. The next submission
        # can resume this interrupted attempt using its last durable base.
        row.update(completed_result_status=row['status'], status='interrupted',
                   artifact_status='error', storage_error=f'{type(exc).__name__}: {exc}')
        STOP.set()
        print(f'Archive failed; scratch preserved at {raw}: {exc}', flush=True)
        store.save(row)
    else:
        shutil.rmtree(scratch)
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
    store = ResultStore(args.suite, args.method, args.shard)
    rows = {}

    def snapshot():
        store.progress(dict(
            expected=[p['problem'] for p in problems], finished=len(rows),
            state='interrupted' if STOP.is_set() else ('complete' if len(rows) == len(problems) else 'running')))

    def interrupted(signum, frame):
        STOP.set()

    signal.signal(signal.SIGTERM, interrupted)
    signal.signal(signal.SIGINT, interrupted)
    print(f'{args.method}: shard {args.shard}, {len(problems)} problems, {workers} concurrent problems', flush=True)
    snapshot()
    with ThreadPoolExecutor(max_workers=workers) as pool:
        futures = {pool.submit(execute_problem, args.suite, manifest, args.method, p, store,
                               getattr(args, 'retry_storage_errors', False)): p for p in problems}
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
                    row = store.get(p['problem']) or dict(problem=p['problem'], method=args.method, status='error')
                    row['checkpoint_error'] = str(exc)
                    if row['status'] == 'running':
                        row['status'] = 'error'
                    store.save(row)
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
        reported = size.get('reported_steps')
        valid = (row.get('status') == 'success' and size.get('metric') == METRIC
                 and type(reported) is int and reported >= 0
                 and size.get('reference_revision_matches') is True)
        return size.get('baseline_steps'), reported, valid
    base = row.get('base', {}).get('base_proof_size') or {}
    final = row.get('local_abs', {}).get('hints_proof_size') or {}
    return (base.get('steps'), final.get('steps'), row.get('status') == 'success'
            and base.get('metric') == final.get('metric') == METRIC)


def report(suite, manifest):
    rows, outcomes = [], {m: Counter() for m in METHODS}
    paired = {m: [] for m in (*METHODS[1:], 'twitch_best')}
    best_coverage = Counter()
    best_by_domain = {}
    excluded_successes = Counter()
    saved = {method: read_results(suite, method) for method in METHODS}
    for problem in manifest['problems']:
        name = problem['problem']
        record = dict(problem=name, domain=problem['domain'])
        sizes = {}
        for method in METHODS:
            row = saved[method].get(name, {})
            status = row.get('status', 'pending')
            outcomes[method][status] += 1
            base, final, valid = measurements(row)
            if status == 'success' and not valid:
                excluded_successes[method] += 1
            sizes[method] = final if valid else None
            fields = dict(status=status, baseline_steps=base, final_steps=final, comparable=valid,
                          reduction_fraction=(base-final)/base if valid and base and final is not None else None,
                          raw_dir=row.get('raw_dir'), artifact_archive=row.get('artifact_archive'),
                          artifact_status=row.get('artifact_status'),
                          error=row.get('error'), storage_error=row.get('storage_error'))
            if method == 'krympa':
                size = row.get('krympa', {}).get('proof_size', {})
                fields.update(reported_steps=size.get('reported_steps'), benchmark_steps=size.get('benchmark_steps'),
                              recounted_steps=size.get('steps'),
                              counts_match=size.get('counts_match'),
                              reference_revision_matches=size.get('reference_revision_matches'))
            record.update({f'{method}_{key}': value for key, value in fields.items()})
        candidates = {method: sizes[method] for method in METHODS[1:] if sizes[method] is not None}
        best = min(candidates.values()) if candidates else None
        sizes['twitch_best'] = best
        record.update(twitch_best_final_steps=best, twitch_best_comparable=best is not None,
                      twitch_best_configs='|'.join(method for method, steps in candidates.items() if steps == best),
                      twitch_available_configs=len(candidates))
        k = sizes['krympa']
        if k is not None and best is not None:
            outcome = 'krympa_shorter' if k < best else 'twitch_shorter' if best < k else 'equal'
        else:
            outcome = ('krympa_only_comparable' if k is not None else
                       'twitch_only_comparable' if best is not None else 'neither_comparable')
        record['twitch_best_comparison'] = outcome
        best_coverage[outcome] += 1
        best_by_domain.setdefault(problem['domain'], Counter())[outcome] += 1
        for method in paired:
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
                   final_length_source={'krympa': 'reported_steps', 'twitch': 'recounted_twee_steps'},
                   krympa_count_mismatches_included=sum(
                       r['krympa_comparable'] and r['krympa_counts_match'] is False for r in rows),
                   best_of_two_coverage=best_coverage, best_of_two_by_domain=best_by_domain,
                   successful_runs_excluded_from_comparison=excluded_successes,
                   best_of_two_paired_with_both_twitch_configs=sum(
                       r['krympa_comparable'] and r['twitch_available_configs'] == 2 for r in rows),
                   reductions_from_own_baseline=reductions,
                   notes=['Krympa final lengths use its reported Total steps; output recounts and count mismatches are diagnostic and do not exclude successful runs. Revision mismatches or missing reported lengths remain excluded.',
                          'Twitch final lengths use recounted printed Twee steps, including lemma proofs. Krympa baseline lengths still use the baseline recount.',
                          'twitch_best selects the shortest comparable successful local proof across the two configurations; it does not fall back to base proofs.',
                          'If only one Twitch configuration has a comparable proof, twitch_best uses that available proof; missing alternatives may improve the eventual result.',
                          'Only paired comparable proofs count as length wins/ties. One-sided availability is reported separately.',
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
    for command in ('check', 'report', 'run-shard', 'compact'):
        sub = commands.add_parser(command)
        sub.add_argument('--suite', type=Path, default=DEFAULT_SUITE)
        if command == 'run-shard':
            sub.add_argument('--method', choices=METHODS, required=True)
            sub.add_argument('--shard', type=int, required=True)
            sub.add_argument('--retry-storage-errors', action='store_true',
                             help='Retry explicit disk quota/space errors, preserving the previous record')
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
            with suite_access(args.suite):
                check(args.suite, manifest)
        elif args.command == 'compact':
            with suite_access(args.suite, maintenance=True):
                print(json.dumps(compact_suite(args.suite, manifest, METHODS), indent=2))
        elif args.command == 'report':
            with suite_access(args.suite):
                report(args.suite, manifest)
        else:
            with suite_access(args.suite):
                run_shard(args, manifest)


if __name__ == '__main__':
    main()
