"""Re-run twee on the translated AIM goals; retain raw outputs + a summary.

    python data/aim_lc/run_twee.py [max_time_seconds]

Runs every data/aim_lc/tptp/*.p in parallel with the base-stage flags,
writes raw twee output to data/aim_lc/twee/<goal>.out and a summary json.
"""

import concurrent.futures
import json
import sys
from pathlib import Path

here = Path(__file__).resolve().parent
project_root = here.parent.parent
sys.path.append(project_root.as_posix())

from src.utils import run_twee_on_file

MAX_TIME = int(sys.argv[1]) if len(sys.argv) > 1 else 1000
FLAGS = ["--flatten-goal", "--all-lemmas", "--show-peaks",
         "--proof-on-saturation", f"--max-time {MAX_TIME}"]


def run_one(problem: Path):
    result = run_twee_on_file(problem, timeout=MAX_TIME + 120, flags=FLAGS)
    out_dir = here / "twee"
    (out_dir / f"{problem.stem}.out").write_text(result["output"] or "")
    # twee prints "RESULT: Theorem" for fof conjectures, "RESULT: Unsatisfiable" for cnf
    out = result["output"] or ""
    proved = "RESULT: Theorem" in out or "RESULT: Unsatisfiable" in out
    return problem.stem, {
        "status": result["status"],
        "proved": proved,
        "total_cpu": result["total_cpu"],
    }


if __name__ == "__main__":
    (here / "twee").mkdir(exist_ok=True)
    problems = sorted((here / "tptp").glob("*.p"))
    print(f"running twee (max_time={MAX_TIME}s) on {len(problems)} problems")
    summary = {}
    with concurrent.futures.ProcessPoolExecutor(max_workers=7) as pool:
        for stem, info in pool.map(run_one, problems):
            summary[stem] = info
            print(f"  {stem}: {info['status']}, proved={info['proved']}, cpu={info['total_cpu']}")
    (here / "twee" / "summary.json").write_text(json.dumps(summary, indent=1))
