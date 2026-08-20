"""Phase 3 driver: primitive Bol-Moufang concept recovery.

    python src/corpus/run_phase3.py [--provers otter,twee] [--problems thm1,...]

Runs Stitch and Babble directly on the primitive quasigroup corpora — no
erasure: the loop-theoretic concepts were never named in these proofs — and
matches learned abstractions against the standard constructions (associator,
commutator, L, R, T inner mappings) in three tiers:

    alpha       abstraction body alpha-equivalent to the construction
    subterm     construction occurs inside a larger abstraction body
    equational  provably equal under the problem's own axioms (twee check,
                over argument permutations; see src/corpus/equiv.py)

Abstraction bodies are matched after `expand_abstractions` (so a construction
assembled from two nested fn_i still counts), but ranks always refer to the
engine's own raw ranked list. Results: data/concept_recovery/phase3/.
"""

import argparse
import json
import re
import sys
import time
from pathlib import Path

project_root = Path(__file__).resolve().parents[2]
sys.path.append(project_root.as_posix())

from src.corpus.equiv import axioms_from_tptp, checkable, equational_match
from src.corpus.erasure import match_abstractions, target_bodies
from src.corpus.run_phase2 import target_occurrences
from src.stitch.Abstractions import Stitch_Abstractions
from src.babble.Abstractions import Babble_Abstractions
from src.utils import expand_abstractions, filter_out_higer_order_abstractions

OUT = project_root / "data" / "concept_recovery" / "phase3"
TOP_N = 30
MAX_EQUATIONAL_RANK = 6  # only twee-check the strongest abstractions


def expanded_triples(raw: list) -> list:
    """(name, expanded_body, original_rank) for each surviving abstraction."""
    ranks = {a.split("=", 1)[0].strip().split("(")[0]: i + 1
             for i, a in enumerate(raw)}
    triples = []
    for a in expand_abstractions(filter_out_higer_order_abstractions(raw)):
        head, body = a.split("=", 1)
        name = head.strip().split("(")[0]
        triples.append((name, body.strip(), ranks[name]))
    return triples


def match_all_tiers(raw: list, axioms: list, equational_budget: float = 60) -> dict:
    triples = expanded_triples(raw)
    # tiers 1+2 on the expanded bodies, ranks remapped to the raw list
    recovered = match_abstractions([f"{n} = {b}" for n, b, _ in triples])
    by_name = {n: r for n, _, r in triples}
    for entry in recovered.values():
        entry["rank"] = by_name[entry["abstraction"].split("=", 1)[0].strip()]
    # tier 3 for what remains, on the strongest candidates only
    candidates = [(n, b, r) for n, b, r in triples
                  if r <= MAX_EQUATIONAL_RANK and checkable(b)]
    equational, exhausted = equational_match(
        candidates, target_bodies(), axioms, already=set(recovered),
        timeout=2, budget=equational_budget)
    recovered.update(equational)
    return recovered, exhausted


def run_engine(label, terms, axioms, args):
    started = time.time()
    try:
        if label == "stitch":
            engine = Stitch_Abstractions(terms, args.stitch_iterations, args.max_arity)
            extra = {}
        else:
            engine = Babble_Abstractions(terms, iterations=args.babble_rounds,
                                         max_arity=args.max_arity,
                                         beams=args.babble_beams,
                                         timeout=args.babble_timeout)
            extra = {"compression_ratio": engine.compression_ratio}
        raw = engine.fo_abstractions
        recovered, budget_exhausted = match_all_tiers(raw, axioms)
        return {"status": "ok", "seconds": round(time.time() - started, 1),
                "n_abstractions": len(raw),
                "recovered": recovered,
                "equational_budget_exhausted": budget_exhausted,
                "top_abstractions": raw[:TOP_N],
                "expanded_abstractions": [f"{n} = {b}" for n, b, _ in expanded_triples(raw)][:TOP_N],
                **extra}
    except Exception as e:
        return {"status": f"failed: {type(e).__name__}",
                "seconds": round(time.time() - started, 1)}


MARK = {"alpha": "", "subterm": "*", "equational": "~"}


def summary_row(result: dict, engine_order=("stitch", "babble")) -> str:
    cells = [result["problem"], result["prover"], str(result["n_terms"])]
    for label in engine_order:
        engine = result["engines"].get(label)
        if engine is None:
            cells.append("not run")
        elif engine["status"] != "ok":
            cells.append(engine["status"])
        else:
            recovered = engine["recovered"]
            cells.append(", ".join(
                f"{sym}@{recovered[sym]['rank']}{MARK[recovered[sym]['match']]}"
                for sym in sorted(recovered)) or "-")
    return "| " + " | ".join(cells) + " |"


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--problems", default=",".join(f"thm{i}" for i in range(1, 10)))
    parser.add_argument("--provers", default="otter,twee")
    parser.add_argument("--engines", default="stitch,babble")
    parser.add_argument("--stitch-iterations", type=int, default=10)
    parser.add_argument("--max-arity", type=int, default=3)
    parser.add_argument("--babble-rounds", type=int, default=5)
    parser.add_argument("--babble-beams", type=int, default=100)
    parser.add_argument("--babble-timeout", type=int, default=900)
    args = parser.parse_args()

    OUT.mkdir(parents=True, exist_ok=True)
    print(f"targets: {target_bodies()}\n", flush=True)

    for problem in args.problems.split(","):
        axioms = axioms_from_tptp(project_root / "data" / "bol_moufang" / "tptp" / f"{problem}.p")
        for prover in args.provers.split(","):
            name = f"{problem}__{prover}"
            corpus = json.loads((project_root / "data" / "corpora" / "bol_moufang" / f"{name}.json").read_text())
            terms = [r["term"] for r in corpus["records"]]
            out_path = OUT / f"{name}.json"
            result = json.loads(out_path.read_text()) if out_path.exists() else {
                "problem": problem, "prover": prover, "n_terms": len(terms),
                "statement": corpus["metadata"].get("statement"),
                "target_occurrences": target_occurrences(terms),
                "engines": {},
            }
            for label in args.engines.split(","):
                result["engines"][label] = run_engine(label, terms, axioms, args)
            out_path.write_text(json.dumps(result, indent=1))
            print(summary_row(result), flush=True)

    all_results = [json.loads(p.read_text())
                   for p in sorted(OUT.glob("*.json")) if p.name != "results.json"]
    (OUT / "results.json").write_text(json.dumps(all_results, indent=1))
    lines = ["| problem | prover | terms | stitch recovered | babble recovered |",
             "|---|---|---:|---|---|"] + [summary_row(r) for r in all_results]
    (OUT / "summary.md").write_text(
        "# Phase 3: primitive Bol-Moufang concept recovery\n\n"
        "`sym@rank` = alpha-equivalent whole-body match; `*` = as subterm; "
        "`~` = provably equal under the problem's axioms (twee-checked, "
        "modulo argument permutation).\n\n" + "\n".join(lines) + "\n")
    print(f"\nwrote {OUT.relative_to(project_root)}/results.json and summary.md")
