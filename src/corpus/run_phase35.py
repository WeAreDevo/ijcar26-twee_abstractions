"""Phase 3.5 driver: prove the AIM goals with the concepts removed from the input.

Phase 2 erased the derived operations from proofs that were *found with them*.
Here the provers never see them: `definition_free.py` deletes the five defining
equations and unfolds everything into the primitive loop signature. Any
construction a compressor recovers from the resulting proof was genuinely
re-derived.

These problems are expected to be hard, so each prover gets 60s and a partial
proof is kept when the search fails: twee's derived lemma list, Prover9's
`kept:` clauses.

    python src/corpus/run_phase35.py [--corpora aim_lc,bml_aim] [--seconds 60]

Writes data/concept_recovery/phase35/<corpus>__<problem>__<prover>.json
(status, term counts, engine results, recovery) plus summary.md; raw prover
output goes to data/definition_free/<corpus>/out/.
"""

import argparse
import json
import re
import subprocess
import sys
import tempfile
import time
from pathlib import Path

project_root = Path(__file__).resolve().parents[2]
sys.path.append(project_root.as_posix())

from dotenv import load_dotenv
import os

from src.corpus.equiv import axioms_from_tptp
from src.corpus.erasure import target_bodies
from src.corpus.extraction import (
    rename_prover9_symbols, terms_from_prover9_kept, terms_from_prover9_proof,
    terms_from_twee_output)
from src.utils import extract_terms, normalize_fof_term
from src.corpus.run_phase2 import target_occurrences
from src.corpus.run_phase3 import match_all_tiers, run_engine

load_dotenv()
LADR = os.getenv("LADR_DIR")
OUT = project_root / "data" / "concept_recovery" / "phase35"
DEF_FREE = project_root / "data" / "definition_free"

TWEE_FLAGS = ["--flatten-goal", "--all-lemmas", "--show-peaks", "--proof-on-saturation"]

# A twee run that gives up still prints every lemma it derived -- tens of
# thousands of terms, most of them noise. The repo's partial-proof stage
# (partial_abs in worker.py) handles this by scoring lemmas and keeping the
# top-k most interesting; the same is done here so partial corpora stay
# comparable in size to real proofs.
PARTIAL_TOPK = 60


# Prover9 keeps tens of thousands of clauses on these problems. When the
# search fails they are the only record of what it derived, so they are capped
# at the most recently kept ones -- later clauses build on earlier ones, so the
# tail is the most developed part of the search.
KEPT_CAP = 600


def prover9_terms(output: str, proved: bool) -> list:
    """The proof when Prover9 found one, otherwise its kept clauses.

    Mirrors the twee path: a successful run contributes its actual proof, a
    failed one its partial search record.
    """
    if proved:
        import re as _re
        blocks = _re.split(r'=+ PROOF =+', output)
        if len(blocks) > 1:
            proof_text = _re.split(r'=+ end of proof =+', blocks[1])[0]
            steps = []
            for line in proof_text.splitlines():
                match = _re.match(r'^\s*(\d+[A-Z]*)\s+(.*?)\.\s*\[(.*)\]\.?\s*$', line)
                if not match:
                    continue
                step_id, body, justification = match.groups()
                body = body.split("#", 1)[0].strip()
                # Skip genuine clauses and implications, but KEEP negated unit
                # equations. Those are the goal-refutation chain -- Prover9's
                # analogue of twee's goal proof chain, which the twee side does
                # include. Dropping them discarded ~20% of an expanded proof
                # and biased any twee/Prover9 comparison.
                if any(t in body for t in ("|", "->", "<->")) or "=" not in body:
                    continue
                if "!=" in body:
                    body = body.replace("!=", "=", 1)
                steps.append({"id": step_id, "text": rename_prover9_symbols(body),
                              "justification": justification, "kind": "equation",
                              "labels": []})
            if steps:
                return terms_from_prover9_proof({"steps": steps})
    kept = [line for line in output.splitlines() if line.startswith("kept:")]
    return terms_from_prover9_kept("\n".join(kept[-KEPT_CAP:]))


def twee_terms(output: str, proved: bool, topk: int = PARTIAL_TOPK) -> list:
    if proved:
        return terms_from_twee_output(output)
    selected = extract_terms(output, {"onlyTopLemmas": True, "topk": topk})
    return [{"term": normalize_fof_term(t.replace("'", "")), "step": None,
             "side": None, "is_input": False} for t in selected]


def run_twee(problem: Path, seconds: int) -> dict:
    from src.utils import run_twee_on_file
    result = run_twee_on_file(problem, timeout=seconds + 30,
                              flags=TWEE_FLAGS + [f"--max-time {seconds}"])
    output = result["output"] or ""
    proved = "RESULT: Theorem" in output or "RESULT: Unsatisfiable" in output
    return {"output": output, "proved": proved,
            "status": "proved" if proved else
                      ("gave_up" if "RESULT: GaveUp" in output else result["status"])}


def run_prover9(problem_in: Path, seconds: int) -> dict:
    text = (f"assign(max_seconds, {seconds}).\nset(print_kept).\n"
            + problem_in.read_text())
    with tempfile.NamedTemporaryFile("w", suffix=".in", delete=False) as f:
        f.write(text)
        path = f.name
    try:
        completed = subprocess.run([f"{LADR}/bin/prover9", "-f", path],
                                   capture_output=True, text=True,
                                   timeout=seconds + 60)
        output = completed.stdout
    except subprocess.TimeoutExpired:
        output = ""
    finally:
        Path(path).unlink()
    proved = "THEOREM PROVED" in output
    return {"output": output, "proved": proved,
            "status": "proved" if proved else
                      ("search_failed" if "SEARCH FAILED" in output else "timeout")}


def compress_and_match(terms, axioms, args) -> dict:
    engines = {}
    for label in args.engines.split(","):
        engines[label] = run_engine(label, terms, axioms, args)
    return engines


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--corpora", default="bml_aim,aim_lc")
    parser.add_argument("--seconds", type=int, default=60)
    parser.add_argument("--provers", default="twee,prover9")
    parser.add_argument("--engines", default="stitch,babble")
    parser.add_argument("--stitch-iterations", type=int, default=10)
    parser.add_argument("--max-arity", type=int, default=3)
    parser.add_argument("--babble-rounds", type=int, default=5)
    parser.add_argument("--babble-beams", type=int, default=25)
    parser.add_argument("--babble-timeout", type=int, default=600)
    parser.add_argument("--problems", default="",
                        help="comma-separated problem stems; default all")
    parser.add_argument("--skip-existing", action="store_true",
                        help="skip problem/prover pairs already recorded")
    parser.add_argument("--reuse-proofs", action="store_true",
                        help="skip the provers; recompress the stored output")
    args = parser.parse_args()

    OUT.mkdir(parents=True, exist_ok=True)
    print(f"targets: {target_bodies()}\n", flush=True)

    for corpus in args.corpora.split(","):
        problems = sorted((DEF_FREE / corpus).glob("*.p"))
        if args.problems:
            wanted = set(args.problems.split(","))
            problems = [p for p in problems if p.stem in wanted]
        raw_dir = DEF_FREE / corpus / "out"
        raw_dir.mkdir(exist_ok=True)
        for problem in problems:
            axioms = [line for line in problem.read_text().splitlines()
                      if line.startswith("cnf(")]
            for prover in args.provers.split(","):
                name = f"{corpus}__{problem.stem}__{prover}"
                out_path = OUT / f"{name}.json"
                previous = json.loads(out_path.read_text()) if out_path.exists() else None
                if previous and args.skip_existing:
                    print(f"| {corpus} | {problem.stem} | {prover} | (already done) |",
                          flush=True)
                    continue
                if previous and args.reuse_proofs:
                    # keep the prover result, just add/refresh engine columns
                    raw = (raw_dir / f"{problem.stem}__{prover}.out").read_text()
                    records = (twee_terms(raw, previous.get("proved", False))
                               if prover == "twee"
                               else prover9_terms(raw, previous.get("proved", False)))
                    terms = [r["term"] for r in records]
                    # refresh the derived counts too: the extraction policy may have
                    # changed since the proof was stored
                    previous["n_terms"] = len(terms)
                    previous["n_distinct_terms"] = len(set(terms))
                    previous["n_input_terms"] = sum(r["is_input"] for r in records)
                    previous["n_derived_terms"] = sum(not r["is_input"] for r in records)
                    previous["target_occurrences"] = target_occurrences(terms) if terms else {}
                    previous["engines"].update(
                        compress_and_match(terms, axioms, args) if terms else {})
                    out_path.write_text(json.dumps(previous, indent=1))
                    recovered = {label: sorted(e.get("recovered", {}))
                                 for label, e in previous["engines"].items()
                                 if e.get("status") == "ok"}
                    print(f"| {corpus} | {problem.stem} | {prover} | "
                          f"{previous['prover_status']} | {len(terms)} | {recovered} |",
                          flush=True)
                    continue
                started = time.time()
                if prover == "twee":
                    run = run_twee(problem, args.seconds)
                    records = twee_terms(run["output"], run["proved"])
                else:
                    run = run_prover9(problem.with_suffix(".in"), args.seconds)
                    records = prover9_terms(run["output"], run["proved"])
                (raw_dir / f"{problem.stem}__{prover}.out").write_text(run["output"])

                terms = [r["term"] for r in records]
                result = {
                    "corpus": corpus, "problem": problem.stem, "prover": prover,
                    "prover_status": run["status"], "proved": run["proved"],
                    "prover_seconds": round(time.time() - started, 1),
                    "n_terms": len(terms),
                    "n_distinct_terms": len(set(terms)),
                    # Prover9's kept clauses include the input axioms. Because
                    # unfolding leaves the construction bodies *in* those
                    # axioms, a run that derived almost nothing can "recover"
                    # constructions that were simply handed to it -- so the
                    # derived count is what separates discovery from artifact.
                    "n_input_terms": sum(r["is_input"] for r in records),
                    "n_derived_terms": sum(not r["is_input"] for r in records),
                    "target_occurrences": target_occurrences(terms) if terms else {},
                    "engines": compress_and_match(terms, axioms, args) if terms else {},
                }
                if previous:
                    result["engines"] = {**previous.get("engines", {}), **result["engines"]}
                out_path.write_text(json.dumps(result, indent=1))
                recovered = {label: sorted(e.get("recovered", {}))
                             for label, e in result["engines"].items()
                             if e.get("status") == "ok"}
                print(f"| {corpus} | {problem.stem} | {prover} | {run['status']} | "
                      f"{len(terms)} | {recovered} |", flush=True)

    all_results = [json.loads(p.read_text())
                   for p in sorted(OUT.glob("*.json")) if p.name != "results.json"]
    (OUT / "results.json").write_text(json.dumps(all_results, indent=1))
    print(f"\nwrote {OUT.relative_to(project_root)}/results.json")
