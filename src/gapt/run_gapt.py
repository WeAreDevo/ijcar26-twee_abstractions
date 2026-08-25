"""Run GAPT cut-introduction on a Prover9 proof and parse the result.

GAPT computes a decomposition of a proof's Herbrand term set and turns it into
a universally quantified lemma. This is a different notion of compression from
Stitch's and babble's: those find repeated *subterms*, this produces a
*formula*, and its compression measure is decomposition size.

    python src/gapt/run_gapt.py <prover9 .out> [--method M] [--timeout S]

Landmines this wraps (all verified; see PROGRESS_herbrand.md):

  * GAPT shells out to `prooftrans` for every Prover9 interaction, and
    `Prover9Importer.isInstalled` does NOT check for it -- it reports True and
    then every import throws. `prooftrans` ships with LADR but Homebrew's
    prover9 formula omits it, so $LADR_DIR/bin is prepended to PATH here.
  * `gapt.cli.CLIMain` swallows exceptions and still exits 0. The harness
    script therefore reports status explicitly and calls sys.exit; this
    wrapper trusts the STATUS line, not the exit code alone.
  * GAPT's own `withTimeout` bounds cut-introduction but NOT the proof import
    (prooftrans + Escargot replay), which can hang on its own. So there is an
    outer subprocess timeout as well, set above the inner one.
  * `os.Path` in the harness requires an ABSOLUTE proof path.
"""

import argparse
import json
import os
import subprocess
import sys
from pathlib import Path

from dotenv import load_dotenv

project_root = Path(__file__).resolve().parents[2]
if project_root.as_posix() not in sys.path:
    sys.path.append(project_root.as_posix())

load_dotenv()

GAPT_ROOT = os.getenv("GAPT_ROOT") or (project_root / "third_party" / "gapt-2.19.0").as_posix()
LADR_DIR = os.getenv("LADR_DIR")
HARNESS = project_root / "src" / "gapt" / "cutintro.scala"

METHODS = ["many_dtable", "1_dtable_ss", "1_maxsat", "1_2_maxsat", "reforest"]

# Exit codes agreed with cutintro.scala
STATUS_BY_CODE = {0: "OK", 2: "NO_LEMMA", 3: "TIMEOUT", 1: "ERROR"}


class GaptError(RuntimeError):
    """GAPT could not be run at all (as opposed to finding no lemma)."""


def run(proof_file, method="many_dtable", timeout=60, heap="4g"):
    """Run cut-introduction on a Prover9 output file.

    Returns a dict with the parsed record. `status` is one of
    OK / NO_LEMMA / TIMEOUT / ERROR; a failure to *invoke* GAPT raises.
    """
    proof_path = Path(proof_file).resolve()
    if not proof_path.exists():
        raise GaptError(f"proof file not found: {proof_path}")
    jar = Path(GAPT_ROOT) / "gapt-2.19.0.jar"
    if not jar.exists():
        raise GaptError(
            f"GAPT jar not found at {jar}. Download it with:\n"
            "  curl -sSfLO https://logic.at/gapt/downloads/gapt-2.19.0.tar.gz")

    env = dict(os.environ)
    if LADR_DIR:  # prooftrans lives here; without it every import throws
        env["PATH"] = f"{Path(LADR_DIR) / 'bin'}:{env.get('PATH', '')}"

    cmd = ["java", f"-Xmx{heap}", "-Xss20m", "-cp", jar.name,
           "gapt.cli.CLIMain", HARNESS.as_posix(),
           proof_path.as_posix(), method, str(timeout)]
    try:
        # outer bound: the harness's own timeout does not cover proof import
        completed = subprocess.run(cmd, cwd=GAPT_ROOT, env=env, capture_output=True,
                                   text=True, timeout=timeout * 2 + 120)
        stdout, code = completed.stdout, completed.returncode
    except subprocess.TimeoutExpired as e:
        stdout, code = (e.stdout or b"").decode(errors="replace"), None

    record = parse(stdout)
    record.setdefault("status", "TIMEOUT" if code is None else STATUS_BY_CODE.get(code, "ERROR"))
    record["exit_code"] = code
    record["proof_file"] = proof_path.as_posix()
    record["method"] = method
    if record["status"] == "ERROR" and "error" not in record:
        raise GaptError(f"GAPT failed on {proof_path.name}:\n{stdout[-2000:]}")
    return record


def parse(stdout: str) -> dict:
    """Parse the harness's KEY<TAB>VALUE lines into a record."""
    record, metrics, lemmas = {}, {}, []
    for line in stdout.splitlines():
        if "\t" not in line:
            continue
        key, _, rest = line.partition("\t")
        if key == "METRIC":
            name, _, value = rest.partition("\t")
            metrics[name] = value
        elif key == "LEMMA":
            index, _, formula = rest.partition("\t")
            lemmas.append(formula)
        elif key in ("TERMSET_SIZE", "TERMSET_DISTINCT_ROOTS", "GRAMMAR_SIZE",
                     "GRAMMAR_WSIZE", "NUM_CUTS", "SEHS_SIZE", "SEHS_NUMVARS"):
            record[key.lower()] = int(rest)
        elif key in ("STATUS", "ERROR", "BACKGROUND_THEORY", "END_SEQUENT", "GRAMMAR"):
            record[key.lower()] = rest
    if lemmas:
        record["lemmas"] = lemmas
    if metrics:
        record["metrics"] = metrics
    # The paper's notion: a term set is trivial when every term has a distinct
    # root symbol, i.e. each end-sequent formula was instantiated once. Nothing
    # to compress, so no lemma is possible.
    if "termset_size" in record and "termset_distinct_roots" in record:
        record["termset_trivial"] = record["termset_distinct_roots"] == record["termset_size"]
    return record


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("proof_file")
    parser.add_argument("--method", default="many_dtable", choices=METHODS)
    parser.add_argument("--timeout", type=int, default=60)
    parser.add_argument("--heap", default="4g")
    parser.add_argument("--json", action="store_true", help="emit the raw record")
    args = parser.parse_args()

    result = run(args.proof_file, args.method, args.timeout, args.heap)
    if args.json:
        print(json.dumps(result, indent=1))
    else:
        print(f"{Path(result['proof_file']).name}  [{result['method']}]  -> {result['status']}")
        for field in ("background_theory", "termset_size", "termset_distinct_roots",
                      "termset_trivial", "grammar_size", "grammar_wsize", "num_cuts"):
            if field in result:
                print(f"  {field:24s} {result[field]}")
        for i, lemma in enumerate(result.get("lemmas", [])):
            print(f"  lemma[{i}]                 {lemma}")
        if "error" in result:
            print(f"  error                    {result['error']}")
