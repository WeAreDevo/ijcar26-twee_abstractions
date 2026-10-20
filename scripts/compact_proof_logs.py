#!/usr/bin/env python3
"""Archive stopped proof-shortening attempts, verifying bytes before deletion.

Run in LOG_DIR, first without --apply to inspect the plan. Requires only Python's
standard library. Reused base runs outside the selected suite are untouched.
"""
import argparse
from collections import Counter
import json
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from scripts.experiment_storage import archive_and_remove, suite_access

METHODS = ('krympa', 'twitch_no_flatten', 'twitch_flatten')


def attempts(log_dir, manifest, methods):
    label = manifest['label']
    if Path(label).name != label or label in ('.', '..'):
        raise ValueError('Invalid suite label')
    root = log_dir / label
    if not root.is_dir() or root.is_symlink():
        raise ValueError(f'Expected suite directory {root}; --log-dir must point to LOG_DIR')
    names = {p['problem'] for p in manifest['problems']}
    for method in methods:
        directory = root / method
        if directory.is_symlink():
            raise ValueError(f'Refusing symlink directory: {directory}')
        if not directory.is_dir():
            continue
        for problem in sorted(directory.iterdir()):
            if problem.name not in names or problem.is_symlink() or not problem.is_dir():
                continue
            for attempt in sorted(problem.iterdir()):
                if (re.fullmatch(r'\d{8}T\d{6}_[0-9a-f]{8}', attempt.name)
                        and attempt.is_dir() and not attempt.is_symlink()):
                    yield method, attempt


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--log-dir', type=Path, default=Path.cwd())
    parser.add_argument('--suite', type=Path, default=ROOT / 'data/experiments/proof_shortening')
    parser.add_argument('--methods', nargs='+', choices=METHODS, default=list(METHODS))
    parser.add_argument('--apply', action='store_true', help='Archive, verify, then remove loose attempt directories')
    args = parser.parse_args()
    manifest = json.loads((args.suite / 'manifest.json').read_text())
    log_dir = args.log_dir.resolve()
    with suite_access(args.suite, maintenance=True):
        work = list(attempts(log_dir, manifest, args.methods))
        counts = Counter(method for method, _ in work)
        print(json.dumps({'attempts_to_archive': dict(counts), 'total': len(work),
                          'apply': args.apply, 'base_runs': 'preserved outside the suite'}, indent=2), flush=True)
        if not args.apply:
            for _, path in work[:10]:
                print(f'{path} -> {path}.tar.gz')
            print('Stopped jobs only. Add --apply to archive and remove the verified loose copies.')
            return
        removed = 0
        for index, (method, path) in enumerate(work, 1):
            archive = path.with_name(path.name + '.tar.gz')
            count = archive_and_remove([path], archive)
            removed += count
            print(f'[{index}/{len(work)}] {method}/{path.parent.name}: {count} entries -> {archive.name}', flush=True)
        print(f'Archived and removed {removed} loose entries into {len(work)} archives. '
              'All file bytes were verified before removal.')


if __name__ == '__main__':
    main()
