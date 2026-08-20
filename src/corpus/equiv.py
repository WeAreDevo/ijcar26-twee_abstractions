"""Equational equivalence of learned abstractions, checked with twee.

Phase 3's third match tier: a learned abstraction body that is not
alpha-equivalent to a standard construction may still be *provably equal to
it under the background equations* (the quasigroup axioms + the theorem's
hypothesis identity). That is a unit-equality proof obligation, and twee is
sitting right there, so each candidate pair (body, target) becomes a tiny
TPTP problem:

    <the problem's axioms>
    fof(equiv, conjecture, ! [A,B,C] : <body> = <target-with-permuted-vars>).

tried over every permutation of the target's variables (operations that
differ only in argument order count as the same construction, extending the
spec's "trivially equivalent by variable renaming" clause modulo the theory).

Bodies containing Skolem constants (sk_*) or unexpanded fn_* references are
not checkable this way; `equational_match` skips them.
"""

import re
import sys
import tempfile
import time
from itertools import permutations
from pathlib import Path

project_root = Path(__file__).resolve().parents[2]
if project_root.as_posix() not in sys.path:
    sys.path.append(project_root.as_posix())

from src.stitch.Abstractions import get_vars_in_term
from src.utils import run_twee_on_file, substitute, parse_fof_term
from src.corpus.erasure import tree_to_fof


def axioms_from_tptp(problem_file: Path) -> list:
    """The cnf axiom lines of a phase-0 problem file (denial dropped)."""
    return [line for line in problem_file.read_text().splitlines()
            if line.startswith("cnf(") and "negated_conjecture" not in line]


def checkable(body: str) -> bool:
    """Quantifiable first-order body: no Skolem constants, no fn_ refs."""
    return "sk_" not in body and not re.search(r'\bfn_\d+\b', body)


def provably_equal(body: str, target: str, axioms: list, timeout: int = 3,
                   deadline: float = None):
    """Try to prove body = target (over some permutation of target's
    variables) from the axioms. Returns the winning permuted target, or None.

    Both inputs are alpha-normalized terms over single-uppercase variables.
    `deadline` (time.time()-based) aborts between permutations.
    """
    body_vars = get_vars_in_term(body)
    target_vars = get_vars_in_term(target)
    if len(body_vars) != len(target_vars):
        return None

    target_tree = parse_fof_term(target)
    for perm in permutations(body_vars):
        if deadline is not None and time.time() > deadline:
            return None
        permuted = tree_to_fof(substitute(target_tree, dict(zip(target_vars, perm))))
        if permuted == body:  # alpha-equivalent; caller handles that tier
            continue
        quantifier = f"! [{', '.join(body_vars)}] : " if body_vars else ""
        problem = "\n".join(axioms) + \
            f"\nfof(equiv, conjecture, {quantifier}{body} = {permuted}).\n"
        with tempfile.NamedTemporaryFile("w", suffix=".p", delete=False) as f:
            f.write(problem)
            path = f.name
        try:
            # --max-time makes twee terminate itself: unprovable obligations
            # are the common case, and they would otherwise burn the whole
            # subprocess timeout on every permutation.
            result = run_twee_on_file(path, timeout=timeout + 2,
                                      flags=[f"--max-time {timeout}"])
        finally:
            Path(path).unlink()
        if "RESULT: Theorem" in (result["output"] or ""):
            return permuted
    return None


def equational_match(abstractions: list, targets: dict, axioms: list,
                     already: set = frozenset(), timeout: int = 3,
                     budget: float = 90.0) -> dict:
    """Third-tier matching for `(name, body, rank)` triples.

    `targets` is {sym: body}; syms in `already` (matched at a stronger tier)
    are skipped. Returns ({sym: {rank, match: "equational", abstraction,
    provably_equal_to}}, budget_exhausted); the earliest rank per sym wins,
    and `budget` caps the total wall-clock spent on twee checks.
    """
    deadline = time.time() + budget
    recovered = {}
    exhausted = False
    for name, body, rank in abstractions:
        if not checkable(body):
            continue
        for sym, target in targets.items():
            if sym in already or sym in recovered:
                continue
            if time.time() > deadline:
                exhausted = True
                break
            witness = provably_equal(body, target, axioms,
                                     timeout=timeout, deadline=deadline)
            if witness is not None:
                recovered[sym] = {"rank": rank, "match": "equational",
                                  "abstraction": f"{name} = {body}",
                                  "provably_equal_to": witness}
        if exhausted:
            break
    return recovered, exhausted
