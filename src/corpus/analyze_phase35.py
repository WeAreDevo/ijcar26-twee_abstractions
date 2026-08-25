"""Phase 3.5 analysis: what survives when the concepts are removed from the input.

Produces data/concept_recovery/phase35/summary.md with, per problem/prover:

  * whether the prover proved the goal in its 60s (or produced a partial proof);
  * how often each construction's body occurs in the definition-free *input*
    versus in the resulting *proof terms* -- the distinction that matters,
    since unfolding necessarily leaves the bodies in the axioms, so the real
    question is which of them the prover's own derivation amplifies;
  * which constructions each compressor then recovers, and at what rank.

    python src/corpus/analyze_phase35.py
"""

import json
import re
import sys
from pathlib import Path

project_root = Path(__file__).resolve().parents[2]
sys.path.append(project_root.as_posix())

from src.corpus.erasure import target_bodies
from src.corpus.extraction import split_equation
from src.corpus.run_phase2 import target_occurrences
from src.utils import parse_fof_term

OUT = project_root / "data" / "concept_recovery" / "phase35"
DEF_FREE = project_root / "data" / "definition_free"
SYMS = ["a", "K", "L", "R", "T"]
MARK = {"alpha": "", "subterm": "*", "equational": "~"}


def input_terms(problem: Path) -> list:
    """The terms of a definition-free problem's axioms and goal."""
    terms = []
    for line in problem.read_text().splitlines():
        body = line.split(",", 2)[-1].rsplit(").", 1)[0]
        body = re.sub(r'!\s*\[[^\]]*\]\s*:\s*', '', body).strip()
        # X0, X1, ... -> A, B, ... so alpha-normalization recognises them
        names = sorted(set(re.findall(r'\bX\d+\b', body)), key=lambda v: int(v[1:]))
        for i, name in enumerate(names):
            body = re.sub(rf'\b{name}\b', chr(ord('A') + i), body)
        for part in re.split(r'=>|\|', body):
            part = part.strip()
            if part.count("=") != 1:
                continue
            try:
                lhs, rhs = split_equation(part)
            except ValueError:
                continue
            terms += [lhs.strip(), rhs.strip()]
    return terms


def matches(pattern, term, binding) -> bool:
    """First-order pattern match; single uppercase letters are wildcards."""
    if isinstance(pattern, str) and len(pattern) == 1 and pattern.isupper():
        if pattern in binding:
            return binding[pattern] == term
        binding[pattern] = term
        return True
    if isinstance(pattern, str) or isinstance(term, str):
        return pattern == term
    if len(pattern) != len(term) or pattern[0] != term[0]:
        return False
    return all(matches(p, t, binding) for p, t in zip(pattern[1:], term[1:]))


def all_subterms(tree):
    yield tree
    if not isinstance(tree, str):
        for arg in tree[1:]:
            yield from all_subterms(arg)


def pattern_occurrences(terms) -> dict:
    """How often each construction's *pattern* occurs, allowing arbitrary
    subterms in its argument positions.

    This is the metric that corresponds to what a compressor recovers: an
    abstraction `fn(A,B) = ldiv(A, op(B,A))` applies wherever that shape
    occurs, not only where the arguments happen to be variables. Counting
    literal alpha-normalized occurrences (target_occurrences) badly
    understates it -- on one partial proof here T's pattern occurs 67 times
    while its variable-argument form occurs zero times.
    """
    patterns = {sym: parse_fof_term(body) for sym, body in target_bodies().items()}
    counts = dict.fromkeys(patterns, 0)
    for term in terms:
        try:
            tree = parse_fof_term(term)
        except Exception:
            continue
        for sub in all_subterms(tree):
            for sym, pattern in patterns.items():
                if matches(pattern, sub, {}):
                    counts[sym] += 1
    return counts


def safe_occurrences(terms):
    counts = {sym: 0 for sym in SYMS}
    for term in terms:
        try:
            for sym, n in target_occurrences([term]).items():
                counts[sym] += n
        except Exception:
            continue  # unparseable fragment (ifeq encodings etc.)
    return counts


def proof_terms(result, raw_path: Path) -> list:
    # Must mirror exactly what run_phase35 fed to the compressors, or the
    # pattern counts describe a different corpus than the recovery column.
    from src.corpus.run_phase35 import prover9_terms, twee_terms
    if not raw_path.exists():
        return []
    text = raw_path.read_text()
    proved = result.get("proved", False)
    records = (twee_terms(text, proved) if result["prover"] == "twee"
               else prover9_terms(text, proved))
    return [r["term"] for r in records]


if __name__ == "__main__":
    results = [json.loads(p.read_text())
               for p in sorted(OUT.glob("*.json")) if p.name != "results.json"]
    pattern_cache = {}

    lines = ["# Phase 3.5: concepts removed from the prover's input", "",
             "The five defining equations are deleted and every axiom and goal is",
             "unfolded into the primitive loop signature, so the prover never sees",
             "`a`, `K`, `L`, `R` or `T`. Each prover gets 60s; a failed search still",
             "contributes its partial proof (twee's lemmas, Prover9's `kept:` clauses).",
             "",
             "`sym@rank` = alpha-equivalent match, `*` = subterm, `~` = provably equal",
             "under the problem's axioms. **!** marks a run whose terms are mostly",
             "input axioms rather than derived content.", "",
             "**derived** is the share of terms the prover actually derived. Prover9's",
             "`kept:` clauses include the input axioms, and unfolding leaves the",
             "construction bodies *inside* those axioms -- so a run that derived almost",
             "nothing can appear to \"recover\" constructions it was simply handed.",
             "Recovery is only evidence of discovery where the derived share is high.",
             "",
             "**pattern a/K/L/R/T** counts occurrences of each construction's shape",
             "with arbitrary subterms in argument positions -- what a compressor can",
             "actually abstract.", "",
             "| corpus | problem | prover | outcome | terms (derived) | pattern a/K/L/R/T | stitch | babble |",
             "|---|---|---|---|---|---|---|---|"]

    for result in results:
        raw = DEF_FREE / result["corpus"] / "out" / \
            f"{result['problem']}__{result['prover']}.out"
        in_proof = pattern_cache.get(raw)
        if in_proof is None:
            in_proof = pattern_occurrences(proof_terms(result, raw))
            pattern_cache[raw] = in_proof

        cells = []
        for label in ("stitch", "babble"):
            engine = result["engines"].get(label)
            if engine is None:
                cells.append("not run")
            elif engine["status"] != "ok":
                cells.append(engine["status"])
            else:
                recovered = engine["recovered"]
                cells.append(", ".join(
                    f"{s}@{recovered[s]['rank']}{MARK[recovered[s]['match']]}"
                    for s in sorted(recovered)) or "-")

        derived = result.get("n_derived_terms")
        share = "" if derived is None else f" ({derived} derived)"
        flag = "" if derived is None or result["n_terms"] == 0 or \
            derived / result["n_terms"] > 0.5 else " **!**"
        lines.append(
            f"| {result['corpus']} | {result['problem']} | {result['prover']} | "
            f"{result['prover_status']}{flag} | {result['n_terms']}{share} | "
            f"{'/'.join(str(in_proof.get(s, 0)) for s in SYMS)} | "
            f"{cells[0]} | {cells[1]} |")

    (OUT / "summary.md").write_text("\n".join(lines) + "\n")
    print(f"wrote {(OUT / 'summary.md').relative_to(project_root)} ({len(results)} runs)")
