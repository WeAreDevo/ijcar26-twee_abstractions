"""Sanity tests for phase-2 definition erasure and recovery matching.

    python src/corpus/test_erasure.py
"""

import json
import os
import sys
from pathlib import Path

project_root = Path(__file__).resolve().parents[2]
sys.path.append(project_root.as_posix())
os.chdir(project_root.as_posix())

from src.corpus.erasure import (
    defining_steps,
    erase,
    match_abstractions,
    target_bodies,
    unfold_term,
)


def test_target_bodies_are_the_aim_definitions():
    assert target_bodies() == {
        "a": "ldiv(op(A, op(B, C)), op(op(A, B), C))",
        "K": "ldiv(op(A, B), op(B, A))",
        "L": "ldiv(op(A, B), op(A, op(B, C)))",
        "R": "rdiv(op(op(A, B), C), op(B, C))",
        "T": "ldiv(A, op(B, A))",
    }


def test_unfold_handles_nesting_and_arguments():
    # T(T(A,B),C): the inner T unfolds inside the outer one
    assert unfold_term("T(T(A, B), C)") == "ldiv(A, op(ldiv(B, op(C, B)), A))"
    # K's definition swaps its arguments' roles
    assert unfold_term("K(A, B)") == "ldiv(op(A, B), op(B, A))"
    # symbols outside the definitions are untouched
    assert unfold_term("op(unit, A)") == "op(unit, A)"
    # Skolem constants are legal arguments and are not alpha-renamed;
    # K(y,x) = (x*y) \ (y*x) puts the second argument first in the body
    assert unfold_term("K(c6, c7)") == "ldiv(op(c7, c6), op(c6, c7))"


FAKE_RECORDS = [
    # the defining equation of T (step 23): both sides must be dropped
    {"term": "ldiv(A, op(B, A))", "step": "23", "side": "lhs", "is_input": True},
    {"term": "T(A, B)", "step": "23", "side": "rhs", "is_input": True},
    # an AIM axiom using T: kept, unfolded
    {"term": "T(T(A, B), C)", "step": "29", "side": "lhs", "is_input": True},
    {"term": "T(T(A, C), B)", "step": "29", "side": "rhs", "is_input": True},
    # a derived step with a bare T application: NOT a defining equation
    {"term": "T(A, B)", "step": "700", "side": "rhs", "is_input": False},
]


def test_erase_drops_defining_equation_and_unfolds_the_rest():
    erased = erase(FAKE_RECORDS)
    assert defining_steps(FAKE_RECORDS) == {"23"}
    assert [r["step"] for r in erased] == ["29", "29", "700"]
    assert erased[0]["term"] == "ldiv(A, op(ldiv(B, op(C, B)), A))"
    # the derived bare application unfolds into exactly the hidden body
    assert erased[2]["term"] == "ldiv(A, op(B, A))"
    # no derived symbol survives anywhere
    assert not any(s in r["term"] for r in erased for s in ["a(", "K(", "L(", "R(", "T("])


def test_erase_with_targets_keeps_other_definitions():
    erased = erase(FAKE_RECORDS, targets={"K"})  # K not present: nothing changes
    assert [r["step"] for r in erased] == ["23", "23", "29", "29", "700"]
    assert erased[2]["term"] == "T(T(A, B), C)"


def test_match_prefers_whole_body_and_earlier_rank():
    fo = [
        "fn_0(A, B, C) = op(ldiv(A, op(B, A)), C)",        # T as subterm, rank 1
        "fn_1(A, B) = ldiv(B, op(A, B))",                   # T alpha-equivalent, rank 2
        "fn_2(A, B) = ldiv(B, op(A, B))",                   # T again, later rank
        "fn_3(A, B) = op(A, B)",                            # noise
    ]
    recovered = match_abstractions(fo)
    assert recovered["T"]["match"] == "alpha" and recovered["T"]["rank"] == 2
    assert set(recovered) == {"T"}


def test_match_on_a_real_erased_corpus_is_clean():
    # data/corpora/ is generated and gitignored; skip rather than fail when it
    # has not been built (`python src/corpus/build_corpora.py`).
    path = Path("data/corpora/aim_lc/first_sketch__aK2.json")
    if not path.exists():
        print("    (skipped: data/corpora not built)")
        return
    corpus = json.loads(path.read_text())
    erased = erase(corpus["records"])
    # defining equations: exactly the 5 definition steps (both sides dropped)
    assert len(corpus["records"]) - len(erased) == 10
    for r in erased:
        for sym in ["a", "K", "L", "R", "T"]:
            assert f"{sym}(" not in r["term"], (sym, r)


if __name__ == "__main__":
    tests = [fn for name, fn in sorted(globals().items()) if name.startswith("test_")]
    for fn in tests:
        fn()
        print(f"ok  {fn.__name__}")
    print(f"\nAll {len(tests)} erasure tests passed.")
