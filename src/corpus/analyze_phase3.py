"""Phase 3 fallback analysis: what the engines found instead.

The five standard constructions are not recovered on the primitive
Bol-Moufang corpora (see data/concept_recovery/phase3/summary.md). The spec's
fallback then applies: "retain the highest-ranking repeated constructions and
inspect them instead". This script produces that inspection —

  * how often each standard construction occurs at all (the reason for the
    negative result);
  * the most common top-5 abstraction bodies across all runs;
  * per corpus, the best rank achieved by a *local identity* (x\\x or x/x),
    the quasigroup stand-in for the identity element;

writing data/concept_recovery/phase3/fallback.md.

    python src/corpus/analyze_phase3.py
"""

import json
import sys
from collections import Counter
from pathlib import Path

project_root = Path(__file__).resolve().parents[2]
sys.path.append(project_root.as_posix())

from src.utils import normalize_fof_term, parse_fof_term

PHASE3 = project_root / "data" / "concept_recovery" / "phase3"
CORPORA = project_root / "data" / "corpora" / "bol_moufang"
LOCAL_IDENTITY = {"ldiv(A, A)", "rdiv(A, A)"}
SYMS = ["a", "K", "L", "R", "T"]


def to_fof(tree):
    return tree if isinstance(tree, str) else \
        f"{tree[0]}({', '.join(to_fof(a) for a in tree[1:])})"


def subterms(tree):
    yield tree
    if not isinstance(tree, str):
        for arg in tree[1:]:
            yield from subterms(arg)


def local_identity_occurrences(terms) -> int:
    count = 0
    for term in terms:
        for sub in subterms(parse_fof_term(term)):
            if not isinstance(sub, str) and normalize_fof_term(to_fof(sub)) in LOCAL_IDENTITY:
                count += 1
    return count


def results():
    return sorted((json.loads(p.read_text()) for p in PHASE3.glob("thm*.json")),
                  key=lambda r: (int(r["problem"][3:]), r["prover"]))


if __name__ == "__main__":
    rows, tally, totals = [], Counter(), Counter()
    for result in results():
        name = f"{result['problem']}__{result['prover']}"
        corpus = json.loads((CORPORA / f"{name}.json").read_text())
        terms = [r["term"] for r in corpus["records"]]
        for sym in SYMS:
            totals[sym] += result["target_occurrences"][sym]

        best = {}
        for engine_name, engine in result["engines"].items():
            if engine["status"] != "ok":
                continue
            for rank, abstraction in enumerate(engine.get("expanded_abstractions", []), 1):
                body = abstraction.split("=", 1)[1].strip()
                if any(identity in body for identity in LOCAL_IDENTITY):
                    best[engine_name] = rank
                    break
            for abstraction in engine.get("expanded_abstractions", [])[:5]:
                tally[abstraction.split("=", 1)[1].strip()] += 1

        rows.append((name, result["statement"], len(terms),
                     local_identity_occurrences(terms), best))

    lines = ["# Phase 3 fallback: what was found instead", "",
             "## Why the standard constructions were not recovered", "",
             "Occurrences as a subterm across all 18 primitive corpora "
             f"({sum(len(json.loads((CORPORA / (f'{r[0]}.json')).read_text())['records']) for r in rows)} term occurrences):", "",
             "| construction | occurrences |", "|---|---:|"]
    lines += [f"| {sym} | {totals[sym]} |" for sym in SYMS]
    lines += ["", "A compressor cannot abstract a pattern the proofs never build.", "",
              "## Local identity (`x\\x`, `x/x`) — the concept these proofs *are* about", "",
              "| corpus | statement | terms | local-id occurrences | best rank |",
              "|---|---|---:|---:|---|"]
    for name, statement, n_terms, occurrences, best in rows:
        ranks = ", ".join(f"{e}@{r}" for e, r in sorted(best.items())) or "-"
        lines.append(f"| {name} | {statement} | {n_terms} | {occurrences} | {ranks} |")
    lines += ["", "## Most common top-5 abstraction bodies (all runs)", "",
               "| count | body |", "|---:|---|"]
    lines += [f"| {n} | `{body}` |" for body, n in tally.most_common(15)]

    (PHASE3 / "fallback.md").write_text("\n".join(lines) + "\n")
    print(f"wrote {(PHASE3 / 'fallback.md').relative_to(project_root)}")
