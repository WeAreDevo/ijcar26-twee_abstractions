"""Phase 2 driver: AIM definition-erasure control.

    python src/corpus/run_phase2.py [--sketches first_sketch,second_sketch]
                                    [--goals aK1,...] [--expanded]
                                    [--stitch-iterations N] [--max-arity N]
                                    [--babble-rounds N] [--babble-timeout S]

For every selected AIM corpus: erase a/K/L/R/T (unfold + drop definitions),
run Stitch and Babble on the erased terms, and record which hidden
definitions each engine re-discovers, at what rank. Results are appended to
data/concept_recovery/phase2/<corpus-name>.json as they finish, plus a
combined results.json and a markdown summary table at the end.

Babble runs without an equational theory here (phase 4 adds theories);
a babble timeout is recorded as such, not treated as an error.
"""

import argparse
import json
import sys
import time
from pathlib import Path

project_root = Path(__file__).resolve().parents[2]
sys.path.append(project_root.as_posix())

from src.corpus.erasure import erase, match_abstractions, target_bodies
from src.utils import normalize_fof_term, parse_fof_term
from src.stitch.Abstractions import Stitch_Abstractions
from src.babble.Abstractions import Babble_Abstractions

OUT = project_root / "data" / "concept_recovery" / "phase2"
GOALS = ["aK1", "aK2", "aK3", "Ka", "aa1", "aa2", "aa3"]
TOP_N = 30  # abstractions retained per run for later inspection


def target_occurrences(terms: list) -> dict:
    """How often each hidden definition body occurs as a subterm across the
    erased corpus (the spec's 'occurrence count' metric)."""
    targets = target_bodies()
    counts = dict.fromkeys(targets, 0)

    def tree_to_fof(tree):
        if isinstance(tree, str):
            return tree
        return f"{tree[0]}({', '.join(tree_to_fof(a) for a in tree[1:])})"

    def subterms(tree):
        yield tree
        if not isinstance(tree, str):
            for arg in tree[1:]:
                yield from subterms(arg)

    for term in terms:
        for sub in subterms(parse_fof_term(term)):
            if isinstance(sub, str):
                continue
            normalized = normalize_fof_term(tree_to_fof(sub))
            for sym, body in targets.items():
                if normalized == body:
                    counts[sym] += 1
    return counts


def run_engine(label, terms, args):
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
        fo = engine.fo_abstractions
        return {"status": "ok", "seconds": round(time.time() - started, 1),
                "n_abstractions": len(fo), "recovered": match_abstractions(fo),
                "top_abstractions": fo[:TOP_N], **extra}
    except Exception as e:
        return {"status": f"failed: {type(e).__name__}",
                "seconds": round(time.time() - started, 1)}


def run_corpus(name: str, args) -> dict:
    corpus = json.loads((project_root / "data" / "corpora" / "aim_lc" / f"{name}.json").read_text())
    erased = erase(corpus["records"])
    terms = [r["term"] for r in erased]
    out_path = OUT / f"{name}.json"
    # merge with any earlier run of other engines on this corpus
    result = json.loads(out_path.read_text()) if out_path.exists() else {
        "corpus": name, "n_terms": len(terms),
        "n_dropped_definition_records": len(corpus["records"]) - len(erased),
        "target_occurrences": target_occurrences(terms),
        "engines": {},
    }
    for label in args.engines.split(","):
        result["engines"][label] = run_engine(label, terms, args)
    out_path.write_text(json.dumps(result, indent=1))
    return result


def summary_row(result: dict, engine_order=("stitch", "babble")) -> str:
    cells = [result["corpus"], str(result["n_terms"])]
    for label in engine_order:
        engine = result["engines"].get(label)
        if engine is None:
            cells.append("not run")
        elif engine["status"] != "ok":
            cells.append(engine["status"])
        else:
            recovered = engine["recovered"]
            cells.append(", ".join(
                f"{sym}@{recovered[sym]['rank']}{'*' if recovered[sym]['match'] == 'subterm' else ''}"
                for sym in sorted(recovered)) or "-")
    return "| " + " | ".join(cells) + " |"


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--sketches", default="first_sketch,second_sketch")
    parser.add_argument("--goals", default=",".join(GOALS))
    parser.add_argument("--expanded", action="store_true",
                        help="also run the *_expanded corpora")
    parser.add_argument("--stitch-iterations", type=int, default=10)
    parser.add_argument("--max-arity", type=int, default=3)
    parser.add_argument("--babble-rounds", type=int, default=3)
    parser.add_argument("--babble-timeout", type=int, default=600)
    parser.add_argument("--babble-beams", type=int, default=400)
    parser.add_argument("--engines", default="stitch,babble")
    args = parser.parse_args()

    OUT.mkdir(parents=True, exist_ok=True)
    names = [f"{sketch}{suffix}__{goal}"
             for sketch in args.sketches.split(",")
             for suffix in ([""] + (["_expanded"] if args.expanded else []))
             for goal in args.goals.split(",")]

    print(f"targets: {target_bodies()}\n")
    results = []
    for name in names:
        result = run_corpus(name, args)
        results.append(result)
        print(summary_row(result), flush=True)

    # results.json and summary.md are rebuilt from every per-corpus file,
    # so engine-specific runs accumulate instead of clobbering each other
    all_results = [json.loads(p.read_text())
                   for p in sorted(OUT.glob("*.json")) if p.name != "results.json"]
    (OUT / "results.json").write_text(json.dumps(all_results, indent=1))
    engines_seen = [e for e in ("stitch", "babble")
                    if any(e in r["engines"] for r in all_results)]
    engine_cols = " | ".join(f"{e} recovered" for e in engines_seen)
    lines = [f"| corpus | terms | {engine_cols} |",
             "|---" + "|---:" + "|---" * len(engines_seen) + "|"] + \
            [summary_row(r, engines_seen) for r in all_results]
    (OUT / "summary.md").write_text(
        "# Phase 2: definition-erasure recovery\n\n"
        "`sym@rank` = hidden definition recovered as whole abstraction body "
        "(alpha-equivalent) at that rank; `*` = recovered only as a subterm "
        "of a larger abstraction.\n\n" + "\n".join(lines) + "\n")
    print(f"\nwrote {OUT.relative_to(project_root)}/results.json and summary.md")
