"""Rebuild a stopped stage's summary from per-problem checkpoints (no jobs)."""
import argparse
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))
from src.stitch.pipeline.checkpoints import rebuild_summary


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('experiment_dir', type=Path, help='Timestamped run directory; the run must have stopped')
    parser.add_argument('--log-dir', type=Path, help='Optional matching LOG_DIR run directory to read and update too')
    args = parser.parse_args()
    try:
        state = rebuild_summary(args.experiment_dir, args.log_dir)
    except (OSError, ValueError, KeyError) as exc:
        parser.exit(1, f'Cannot rebuild summary: {exc}\n')
    print(f"Saved {state['finished_count']} results; {len(state['unfinished_problems'])} unfinished ({state['state']}).")
    print(args.experiment_dir / 'summary.json')


if __name__ == '__main__':
    main()
