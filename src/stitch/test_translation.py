"""
Sanity tests for the FOF term <-> lambda-calculus translation in Abstractions.py.

Run from the repo root with:

    python src/stitch/test_translation.py

Exits with a non-zero status (via assertion) if any check fails.
"""

import os
import re
import sys
from pathlib import Path

project_root = Path(__file__).resolve().parents[2]
sys.path.append(project_root.as_posix())
os.chdir(project_root.as_posix())

from src.stitch.Abstractions import (
    parse_fof_term,
    to_lisp,
    to_fof,
    get_vars_in_term,
    fof_to_lambda,
    parse_lisp_body,
    remove_lambdas,
    Stitch_Abstractions,
)


def normalize_fof(s: str) -> str:
    """Cheap normalization: remove whitespace."""
    return re.sub(r"\s+", "", s)


def test_parse_fof_term_basic():
    assert parse_fof_term("f(g(A),h(B,C))") == ["f", ["g", "A"], ["h", "B", "C"]]


def test_to_lisp_basic():
    assert to_lisp(["f", ["g", "A"], ["h", "B", "C"]]) == "(f (g A) (h B C))"


def test_get_vars_in_term_basic():
    assert get_vars_in_term("f(g(A),h(B,C))") == ["A", "B", "C"]


def test_fof_to_lambda_wraps_one_lambda_per_variable():
    lam = fof_to_lambda("f(A,g(B,C))")  # three distinct variables
    assert lam.count("(lam") == 3
    assert lam.endswith(")" * 3)


def test_fof_to_lambda_replaces_vars_with_debruijn_indices():
    lam = fof_to_lambda("f(A,B)")
    assert "$0" in lam and "$1" in lam
    assert "A" not in lam and "B" not in lam


def test_parse_lisp_body_basic():
    tree = parse_lisp_body("(+ 3 (* 0 (+ #1 #0)))")
    assert tree == ["+", "3", ["*", "0", ["+", "#1", "#0"]]]


def test_remove_lambdas_strips_all_lam_nodes():
    assert remove_lambdas(["lam", ["lam", ["f", "$1", "$0"]]]) == ["f", "$1", "$0"]


def test_to_fof_printer_basic():
    assert to_fof(["f", ["g", "A"], ["h", "B", "C"]]) == "f(g(A), h(B, C))"


def test_uncurry_pads_to_known_arity():
    s = Stitch_Abstractions(terms=["f(A,B)"])  # derives arity f = 2
    out = s.uncurry(["f", "A"])                 # missing one argument
    assert out[0] == "f"
    assert len(out) == 3  # f + 2 args


def test_roundtrip_parse_print_is_stable():
    t = "f(g(A),h(B,C))"
    tree1 = parse_fof_term(t)
    tree2 = parse_fof_term(normalize_fof(to_fof(tree1)))
    assert tree1 == tree2


def test_to_fo_abstraction_is_deterministic():
    s = Stitch_Abstractions(terms=["f(A)"])

    class _Abs:
        def __init__(self, name, body):
            self.name = name
            self.body = body

    abs_obj = _Abs("fn_0", "(lam (f #0 $0))")
    assert s.to_fo_abstraction(abs_obj) == s.to_fo_abstraction(abs_obj)


if __name__ == "__main__":
    tests = [fn for name, fn in sorted(globals().items()) if name.startswith("test_")]
    for fn in tests:
        fn()
        print(f"ok  {fn.__name__}")
    print(f"\nAll {len(tests)} translation tests passed.")
