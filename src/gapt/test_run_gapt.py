"""Tests for the GAPT output parser.

Fixtures are real output captured from `src/gapt/cutintro.scala`, so these run
without GAPT, Java or prooftrans.

    python src/gapt/test_run_gapt.py
"""

import os
import sys
from pathlib import Path

project_root = Path(__file__).resolve().parents[2]
sys.path.append(project_root.as_posix())
os.chdir(project_root.as_posix())

from src.gapt.run_gapt import parse

# Real output for examples/prover9/alex2.out (many_dtable). Note the two
# distinct metric line shapes: our own "METRIC<tab>k<tab>v", and GAPT's
# MetricsPrinter emitting "METRICS {json}" of its own accord. Only the former
# is parsed; the latter must not corrupt the record.
OK_OUTPUT = """FILE\t/abs/examples/prover9/alex2.out
METHOD\tmany_dtable
BACKGROUND_THEORY\tEquality
END_SEQUENT\t∀x f(x, x) = x ⊢ f(a, b) = b
TERMSET_SIZE\t10
TERMSET_DISTINCT_ROOTS\t5
METRICS {"quant_input":14}
METRICS {"termset":10}
STATUS\tOK
GRAMMAR_SIZE\t13
GRAMMAR_WSIZE\t17
NUM_CUTS\t1
LEMMA\t0\t∀x1 ∀x2 ∀x3 f(x1, f(x1, f(x2, x3))) = f(x2, x3)
SEHS_SIZE\t13
SEHS_NUMVARS\t1
METRIC\tbeausol\tVector(f(x1, f(x1, f(x2, x3))) = f(x2, x3))
METRIC\tgrammar_size\t13
"""

NO_LEMMA_OUTPUT = """FILE\t/abs/examples/prover9/farmer.out
METHOD\tmany_dtable
BACKGROUND_THEORY\tPureFOL
TERMSET_SIZE\t9
TERMSET_DISTINCT_ROOTS\t8
STATUS\tNO_LEMMA
"""

TRIVIAL_OUTPUT = """TERMSET_SIZE\t7
TERMSET_DISTINCT_ROOTS\t7
STATUS\tNO_LEMMA
"""

ERROR_OUTPUT = """STATUS\tERROR
ERROR\tjava.io.IOException: Cannot run program "prooftrans": error=2
"""


def test_parses_the_ok_path():
    r = parse(OK_OUTPUT)
    assert r["status"] == "OK"
    assert r["background_theory"] == "Equality"
    assert r["termset_size"] == 10 and r["termset_distinct_roots"] == 5
    assert r["grammar_size"] == 13 and r["grammar_wsize"] == 17
    assert r["num_cuts"] == 1
    assert r["lemmas"] == ["∀x1 ∀x2 ∀x3 f(x1, f(x1, f(x2, x3))) = f(x2, x3)"]


def test_numeric_fields_are_ints_not_strings():
    r = parse(OK_OUTPUT)
    for field in ("termset_size", "grammar_size", "num_cuts", "sehs_numvars"):
        assert isinstance(r[field], int), field


def test_metricsprinter_json_lines_do_not_corrupt_the_record():
    # GAPT prints its own "METRICS {json}" lines; they contain no tab and must
    # be ignored rather than parsed as key/value pairs.
    r = parse(OK_OUTPUT)
    assert "METRICS" not in r
    assert set(r["metrics"]) == {"beausol", "grammar_size"}


def test_triviality_is_derived_from_distinct_roots():
    # The paper's notion: trivial iff every term has a distinct root symbol.
    assert parse(TRIVIAL_OUTPUT)["termset_trivial"] is True
    assert parse(NO_LEMMA_OUTPUT)["termset_trivial"] is False


def test_no_lemma_is_a_result_not_a_failure():
    r = parse(NO_LEMMA_OUTPUT)
    assert r["status"] == "NO_LEMMA"
    assert "lemmas" not in r


def test_error_output_is_surfaced():
    r = parse(ERROR_OUTPUT)
    assert r["status"] == "ERROR"
    assert "prooftrans" in r["error"]


def test_partial_output_from_an_external_kill_still_parses():
    # When the outer subprocess timeout fires, the term set has been printed
    # but nothing after it. That record must still be usable.
    r = parse("BACKGROUND_THEORY\tEquality\nTERMSET_SIZE\t55\nTERMSET_DISTINCT_ROOTS\t11\n")
    assert r["termset_size"] == 55
    assert "status" not in r  # caller fills this in from the exit code


if __name__ == "__main__":
    tests = [fn for name, fn in sorted(globals().items()) if name.startswith("test_")]
    for fn in tests:
        fn()
        print(f"ok  {fn.__name__}")
    print(f"\nAll {len(tests)} GAPT parser tests passed.")
