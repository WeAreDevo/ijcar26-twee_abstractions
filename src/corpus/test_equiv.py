"""Tests for the phase-3 equational match tier.

These exist mainly as a *warrant for a negative result*: phase 3 reports that
no standard construction is recovered on any primitive Bol-Moufang corpus, and
that claim is only worth anything if the checker demonstrably fires when a
construction really is present.

    python src/corpus/test_equiv.py
"""

import os
import sys
from pathlib import Path

project_root = Path(__file__).resolve().parents[2]
sys.path.append(project_root.as_posix())
os.chdir(project_root.as_posix())

from src.corpus.equiv import axioms_from_tptp, checkable, provably_equal
from src.corpus.erasure import target_bodies
from src.corpus.run_phase3 import match_all_tiers

AXIOMS = axioms_from_tptp(Path("data/bol_moufang/tptp/thm1.p"))
TARGETS = target_bodies()

# op(rdiv(op(A,B),B),B) == op(A,B) in any quasigroup, so this is R the long way
R_VARIANT = "rdiv(op(op(rdiv(op(A, B), B), B), C), op(B, C))"


def test_axioms_exclude_the_denial():
    assert all("negated_conjecture" not in a for a in AXIOMS)
    assert len(AXIOMS) == 5


def test_true_equivalence_is_proved_with_a_witness():
    witness = provably_equal(R_VARIANT, TARGETS["R"], AXIOMS)
    assert witness == TARGETS["R"]


def test_false_equivalence_is_rejected():
    assert provably_equal("op(op(A, B), C)", TARGETS["R"], AXIOMS) is None


def test_alpha_equivalent_pairs_are_left_to_the_stronger_tier():
    # identical body and target: no permutation differs, so tier 3 declines
    assert provably_equal(TARGETS["R"], TARGETS["R"], AXIOMS) is None


def test_differing_variable_counts_are_skipped():
    # A documented limitation: an abstraction with an eliminable extra
    # variable is never compared against a lower-arity construction.
    assert provably_equal("ldiv(A, op(A, B))", "B", AXIOMS) is None


def test_checkable_rejects_skolems_and_unexpanded_references():
    assert checkable("op(A, B)")
    assert not checkable("op(sk_a, B)")
    assert not checkable("op(fn_0(A), B)")


def test_tier3_fires_end_to_end_through_the_matcher():
    recovered, exhausted = match_all_tiers(
        [f"fn_0(A, B, C) = {R_VARIANT}"], AXIOMS, equational_budget=120)
    assert not exhausted
    assert recovered["R"]["match"] == "equational"
    assert recovered["R"]["rank"] == 1


def test_alpha_tier_still_wins_when_applicable():
    recovered, _ = match_all_tiers(
        [f"fn_0(A, B) = {TARGETS['T']}"], AXIOMS, equational_budget=30)
    assert recovered["T"]["match"] == "alpha"


if __name__ == "__main__":
    tests = [fn for name, fn in sorted(globals().items()) if name.startswith("test_")]
    for fn in tests:
        fn()
        print(f"ok  {fn.__name__}")
    print(f"\nAll {len(tests)} equivalence tests passed.")
