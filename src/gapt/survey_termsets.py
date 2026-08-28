"""Probe term-set size for a directory of Prover9 proofs, without decomposing.

Cut-introduction's cost is gated by the term set, and the decomposition step is
exponential in it, so it is worth measuring the term set first and only running
the expensive step on proofs that stand a chance.

    python src/gapt/survey_termsets.py <dir with *prover9*.out> [--json out.json]

Reports size, distinct root symbols (a term set is *trivial*, hence
incompressible, when these are equal) and term depth.
"""

import argparse
import json
import os
import subprocess
import sys
import time
from pathlib import Path

from dotenv import load_dotenv

project_root = Path(__file__).resolve().parents[2]
load_dotenv(project_root / ".env")

GAPT_ROOT = os.getenv("GAPT_ROOT") or (project_root / "third_party" / "gapt-2.19.0").as_posix()
LADR_DIR = os.getenv("LADR_DIR")
PROBE = project_root / "src" / "gapt" / "probe_termset.scala"


def probe(proof_file, timeout=300):
    env = dict(os.environ)
    if LADR_DIR:  # prooftrans, required by the Prover9 importer
        env["PATH"] = f"{Path(LADR_DIR) / 'bin'}:{env.get('PATH', '')}"
    cmd = ["java", "-Xmx4g", "-Xss20m", "-cp", "gapt-2.19.0.jar",
           "gapt.cli.CLIMain", PROBE.as_posix(), Path(proof_file).resolve().as_posix()]
    started = time.time()
    try:
        out = subprocess.run(cmd, cwd=GAPT_ROOT, env=env, capture_output=True,
                             text=True, timeout=timeout).stdout
    except subprocess.TimeoutExpired:
        return {"status": "IMPORT_TIMEOUT", "seconds": round(time.time() - started, 1)}

    fields = {}
    for line in out.splitlines():
        if "\t" in line:
            key, _, value = line.partition("\t")
            fields[key] = value
    if "PROBE_FAIL" in fields:
        # The usual cause is that Prover9 never found a proof, so there is
        # nothing for prooftrans to convert.
        return {"status": "IMPORT_FAIL", "error": fields["PROBE_FAIL"][:200],
                "seconds": round(time.time() - started, 1)}
    record = {
        "status": "OK",
        "termset_size": int(fields["TERMSET_SIZE"]),
        "distinct_roots": int(fields["TERMSET_DISTINCT_ROOTS"]),
        "max_depth": int(fields["TERMSET_MAX_DEPTH"]),
        "avg_depth": round(float(fields["TERMSET_AVG_DEPTH"]), 1),
        "background_theory": fields.get("BACKGROUND_THEORY"),
        "seconds": round(time.time() - started, 1),
    }
    record["trivial"] = record["distinct_roots"] == record["termset_size"]
    return record


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("directory")
    parser.add_argument("--json")
    args = parser.parse_args()

    results = {}
    print(f"{'proof':40s} {'size':>7s} {'roots':>6s} {'maxd':>5s} {'avgd':>6s} {'triv':>5s}")
    for path in sorted(Path(args.directory).glob("*prover9*.out")):
        record = probe(path)
        results[path.stem] = record
        if record["status"] != "OK":
            print(f"{path.stem[:40]:40s} {record['status']:>7s}")
        else:
            print(f"{path.stem[:40]:40s} {record['termset_size']:>7d} "
                  f"{record['distinct_roots']:>6d} {record['max_depth']:>5d} "
                  f"{record['avg_depth']:>6.1f} {str(record['trivial']):>5s}")
    if args.json:
        Path(args.json).write_text(json.dumps(results, indent=1))
        print(f"\nwrote {args.json}")
