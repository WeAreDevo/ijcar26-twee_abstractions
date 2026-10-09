#!/usr/bin/env python3
"""Run the upstream Krympa pipeline with configured provers and isolated files."""
import argparse
import json
import os
from pathlib import Path
import signal
import subprocess
import sys
import time

from dotenv import load_dotenv

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "third_party/Krympa"


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("input", type=Path, help="TPTP equational problem")
    parser.add_argument("--output-dir", required=True, type=Path,
                        help="New directory for this run (must not already exist)")
    parser.add_argument("--timeout", type=float, default=600,
                        help="Total pipeline wall-clock limit in seconds (default: 600)")
    parser.add_argument("--sequential", action="store_true")
    args = parser.parse_args()
    if args.timeout <= 0:
        parser.error("--timeout must be positive")
    load_dotenv(ROOT / ".env", override=False)
    # Shell exports take precedence over .env, including on cluster nodes.
    if os.environ.get("TPTP_ROOT"):
        os.environ.setdefault("TPTP", os.environ["TPTP_ROOT"])
    problem = args.input.resolve(strict=True)
    binary = SOURCE / "rust/target/release/krympa"
    ocaml = SOURCE / "rust/ocaml_install/tptp_parser"
    suffix = "_mac" if sys.platform == "darwin" else ""
    if not os.environ.get("VAMPIRE_PATH"):
        parser.error("Set VAMPIRE_PATH in .env or the shell environment")
    vampire = Path(os.environ["VAMPIRE_PATH"]).expanduser().resolve(strict=True)
    twee = Path(os.environ.get("TWEE_PATH", str(SOURCE / f"bin/twee{suffix}"))).expanduser().resolve(strict=True)
    for executable in (binary, ocaml, vampire, twee):
        if not executable.is_file() or not os.access(executable, os.X_OK):
            parser.error(f"Missing executable: {executable}; run scripts/setup_krympa.sh first")

    output = args.output_dir.resolve()
    output.mkdir(parents=True, exist_ok=False)
    work = output / "rust"
    (work / "ocaml_install").mkdir(parents=True)
    (work / "ocaml_install/tptp_parser").symlink_to(ocaml)
    (output / "bin").mkdir()
    for name, target in ((f"vampire{suffix}", vampire), (f"twee{suffix}", twee)):
        (output / "bin" / name).symlink_to(target)
    metadata = {
        "revision": subprocess.check_output(["git", "-C", str(SOURCE), "rev-parse", "HEAD"], text=True).strip(),
        "input": str(problem), "vampire": str(vampire), "twee": str(twee),
        "timeout_seconds": args.timeout, "sequential": args.sequential,
        "status": "running", "completed_stages": [],
    }
    start = time.monotonic()
    manifest = output / "run.json"
    manifest.write_text(json.dumps(metadata, indent=2) + "\n")
    try:
        for stage in ("run_vampire", "collect", "shorten", "minimize"):
            command = [str(binary)] + (["--sequential"] if args.sequential else []) + [stage, str(problem)]
            print(f"Krympa: {stage} (log: {output / (stage + '.log')})", flush=True)
            with (output / f"{stage}.log").open("w") as log:
                process = subprocess.Popen(command, cwd=work, stdout=log, stderr=subprocess.STDOUT,
                                           start_new_session=True)
                try:
                    code = process.wait(timeout=max(0, args.timeout - (time.monotonic() - start)))
                except (subprocess.TimeoutExpired, KeyboardInterrupt):
                    os.killpg(process.pid, signal.SIGKILL)
                    process.wait()
                    raise
                if code:
                    raise RuntimeError(f"{stage} exited with status {code}; see its log")
            metadata["completed_stages"].append(stage)
        # Upstream can report errors but exit zero; require an actual final proof.
        stem = problem.stem.removeprefix("input_problem_")
        proof = output / "output" / f"proof_{stem}.out"
        if not proof.is_file() or not proof.stat().st_size:
            raise RuntimeError("Krympa produced no final proof; inspect the stage logs")
        metadata.update(status="completed", proof=str(proof))
        print(f"Proof: {proof}")
    except BaseException as exc:
        metadata.update(status="failed", error=str(exc))
        raise
    finally:
        metadata["elapsed_seconds"] = time.monotonic() - start
        manifest.write_text(json.dumps(metadata, indent=2) + "\n")


if __name__ == "__main__":
    main()
