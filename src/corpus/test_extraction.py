"""Sanity tests for the uniform proof-term extraction (Phase 1).

Run from the repo root with:

    python src/corpus/test_extraction.py

Exits with a non-zero status (via assertion) if any check fails.
"""

import os
import sys
from pathlib import Path

project_root = Path(__file__).resolve().parents[2]
sys.path.append(project_root.as_posix())
os.chdir(project_root.as_posix())

from src.corpus.extraction import (
    babble_input,
    parse_prover9_term,
    prover9_tree_to_fof,
    split_equation,
    stitch_input,
    terms_from_otter_theorem,
    terms_from_prover9_proof,
    terms_from_twee_output,
)
from src.utils import parse_fof_term


def convert(s):
    return prover9_tree_to_fof(parse_prover9_term(s))


# ----------------------------
# Prover9 infix parsing
# ----------------------------

def test_parse_associator_definition_lhs():
    assert convert("(x * (y * z)) \\ ((x * y) * z)") == \
        "ldiv(op(A, op(B, C)), op(op(A, B), C))"


def test_parse_infix_inside_prefix_application():
    # a(x,z,z \ y): an infix subterm as an argument of a prefix application
    assert convert("a(x,z,z \\ y)") == "a(A, B, ldiv(B, C))"


def test_parse_top_level_bare_op():
    assert convert("1 * x") == "op(unit, A)"


def test_variables_are_prover9_u_through_z():
    # numbered variables from big clauses, and c-constants stay constants
    assert convert("T(v5,x)") == "T(A, B)"
    assert convert("K(c6,c7)") == "K(c6, c7)"
    assert convert("a(c5,K(c6,c7),c8)") == "a(c5, K(c6, c7), c8)"


def test_alpha_normalization_is_first_occurrence_order():
    assert convert("z * (x * z)") == "op(A, op(B, A))"


def test_multiple_depth0_operators_is_an_error_not_a_guess():
    try:
        parse_prover9_term("x * y * z")
    except ValueError:
        return
    raise AssertionError("expected ValueError on ambiguous infix")


def test_split_equation_single_depth0_equals():
    lhs, rhs = split_equation("(x * y) \\ (y * x) = K(y,x)")
    assert lhs == "(x * y) \\ (y * x)" and rhs == "K(y,x)"


# ----------------------------
# Per-source extraction
# ----------------------------

FAKE_PROVER9_PROOF = {"steps": [
    {"id": "13", "text": "1 * x = x", "justification": "assumption",
     "kind": "equation", "labels": []},
    {"id": "51A", "text": "(x * y) \\ ((x * 1) * y) = a(x,1,y)",
     "justification": "para(13(a,1),19(a,1,1,2))", "kind": "equation", "labels": []},
    {"id": "24", "text": "a(x,y,z) != 1 | L(z,y,x) = z",
     "justification": "clausify(1)", "kind": "clause", "labels": []},
    {"id": "13b", "text": "1 * x = x", "justification": "assumption",
     "kind": "equation", "labels": []},
]}


def test_prover9_records_sides_flags_and_multiplicity():
    records = terms_from_prover9_proof(FAKE_PROVER9_PROOF)
    # 3 equations (clause excluded) x 2 sides, duplicates kept
    assert len(records) == 6
    assert [r["term"] for r in records[:2]] == ["op(unit, A)", "A"]
    assert records[0]["is_input"] and not records[2]["is_input"]
    assert records[2]["step"] == "51A" and records[2]["side"] == "lhs"
    # multiplicity: the duplicated axiom appears twice
    assert [r["term"] for r in records].count("op(unit, A)") == 2


FAKE_OTTER_THEOREM = {"steps": [
    {"id": 2, "tptp": "op(X,ldiv(X,Y)) = Y", "is_input": True, "negated": False},
    {"id": 13, "tptp": "op(sk_a,sk_b) != op(sk_b,sk_a)", "is_input": True, "negated": True},
    {"id": 15, "tptp": "rdiv(Y,ldiv(X,Y)) = X", "is_input": False, "negated": False},
    {"id": 99, "tptp": None, "is_input": False, "negated": False},
]}


def test_otter_records_normalize_and_skip_denials():
    records = terms_from_otter_theorem(FAKE_OTTER_THEOREM)
    assert len(records) == 4  # 2 equations x 2 sides; denial and $F skipped
    assert records[0]["term"] == "op(A, ldiv(A, B))"
    # rhs normalizes independently: Y alone becomes A
    assert records[1]["term"] == "A"
    # first-occurrence renaming inside the derived step: Y->A, X->B
    assert records[2]["term"] == "rdiv(A, ldiv(B, A))"


FAKE_TWEE_TRACE = """
Lemma 5: 'T'(op(X, Y), Y) = X.
Proof:
  'T'(op(X, Y), Y) (peak)
= { by axiom 3 }
  ldiv(Y, op(op(X, Y), Y))
= { by lemma 4 }
  X

Goal 1 (goals): foo = bar.
Proof:
  foo
= { by lemma 5 }
  bar
RESULT: Theorem (the conjecture is true).
"""


def test_twee_records_strip_quotes_and_keep_chain_multiplicity():
    records = terms_from_twee_output(FAKE_TWEE_TRACE)
    terms = [r["term"] for r in records]
    assert terms[0] == "T(op(A, B), B)"          # quotes stripped, peak marker gone
    assert "ldiv(A, op(op(B, A), A))" in terms
    assert terms.count("foo") == 1 and terms.count("bar") == 1
    assert all(not r["is_input"] and r["step"] is None for r in records)


# ----------------------------
# Compressor input export
# ----------------------------

def test_exports_align_with_records_and_are_wellformed():
    records = terms_from_prover9_proof(FAKE_PROVER9_PROOF)
    stitch = stitch_input(records)
    babble = babble_input(records)
    assert len(stitch) == len(babble) == len(records)
    assert stitch[0] == "(lam (op unit $0))"
    assert babble[0] == "(lambda (@ (@ s_op s_unit) $0))"
    # every term must round-trip through the shared FOF parser
    for r in records:
        assert parse_fof_term(r["term"]) is not None


if __name__ == "__main__":
    tests = [fn for name, fn in sorted(globals().items()) if name.startswith("test_")]
    for fn in tests:
        fn()
        print(f"ok  {fn.__name__}")
    print(f"\nAll {len(tests)} extraction tests passed.")
