"""
Sanity tests for the FOF term <-> babble translation in babble/Abstractions.py.

Run from the repo root with:

    python src/babble/test_translation.py

Exits with a non-zero status (via assertion) if any check fails.

These cover translation only, so they need neither BABBLE_ROOT nor the built
binary. `SAMPLE_OUTPUT` below is real output captured from the `fof` binary.
"""

import os
import re
import sys
from pathlib import Path

project_root = Path(__file__).resolve().parents[2]
sys.path.append(project_root.as_posix())
os.chdir(project_root.as_posix())

from src.babble.Abstractions import (
    Babble_Abstractions,
    NotFirstOrder,
    collect_libs,
    contains_lambda,
    convert_indices_to_vars,
    demangle,
    demangle_symbols,
    fof_to_babble,
    mangle,
    normalize_lambdas,
    parse_babble_output,
    parse_costs,
    parse_sexp,
    strip_lambdas,
    uncurry_applications,
)
from src.babble.theory import (
    axioms_to_dsrs,
    contains_subtree,
    directed_rules,
    split_equation,
    tptp_vars_in_term,
)
from src.stitch.Abstractions import parse_fof_term, to_fof


# Real output from `target/release/fof` on two terms of a twee proof.
SAMPLE_OUTPUT = (
    'BABBLE_RESULT_BEGIN\n'
    '("lib l8" (λ (@ (@ s_f $0) $0)) (list (list '
    '(λ (λ (λ (@ (@ s_f $0) (@ (@ s_f $1) (@ l8 (@ (@ s_f $2) (@ l8 $0)))))))) '
    '(λ (λ (λ (@ (@ s_f $0) (@ (@ s_f $1) (@ l8 (@ (@ s_f (@ l8 $0)) $2))))))))))\n'
    'BABBLE_RESULT_END\n'
    'BABBLE_INITIAL_COST 66\n'
    'BABBLE_FINAL_COST 49\n'
    'BABBLE_NUM_LIBS 1\n'
)


def decode(babble_expr: str, lib_names=None):
    """Run the full back-translation on an encoded term, without the binary."""
    depth, body = strip_lambdas(normalize_lambdas(parse_sexp(babble_expr)))
    tree = uncurry_applications(body)
    tree = convert_indices_to_vars(tree, depth)
    return demangle_symbols(tree, lib_names or {})


def stub_abstractions(arities, lib_names=None):
    """A Babble_Abstractions with the state to_fo_abstraction needs, no binary run."""
    obj = object.__new__(Babble_Abstractions)
    obj.arities = arities
    obj.lib_names = lib_names or {}
    return obj


# ----------------------------
# Encoding
# ----------------------------

def test_fof_to_babble_wraps_one_lambda_per_variable():
    enc = fof_to_babble("f(A,g(B,C))")  # three distinct variables
    assert enc.count("(lambda") == 3
    assert enc.endswith(")" * 3)


def test_fof_to_babble_curries_application():
    # Variables are indexed by sorted position (A -> $0), matching the
    # convention in src/stitch/Abstractions.py, so A is the innermost binder.
    assert fof_to_babble("f(A,B)") == "(lambda (lambda (@ (@ s_f $0) $1)))"


def test_fof_to_babble_uses_debruijn_indices_not_names():
    enc = fof_to_babble("f(A,B)")
    assert "$0" in enc and "$1" in enc
    assert not re.search(r'\b[A-Z]\b', enc)


def test_fof_to_babble_ground_term_still_gets_one_lambda():
    assert fof_to_babble("a") == "(lambda s_a)"


def test_mangling_round_trips_and_avoids_reserved_tokens():
    for symbol in ["f", "if", "cons", "empty", "l0", "3", "true"]:
        assert demangle(mangle(symbol)) == symbol
    # None of the mangled forms can be read as a babble reserved token.
    assert mangle("l0") == "s_l0" and mangle("3") == "s_3"


# ----------------------------
# Parsing babble output
# ----------------------------

def test_parse_sexp_handles_quoted_lib_head():
    # egg quotes operators containing a space, so `lib l8` arrives quoted.
    assert parse_sexp('("lib l8" a b)') == ["lib l8", "a", "b"]


def test_normalize_lambdas_rewrites_unicode():
    assert normalize_lambdas(["λ", ["λ", "x"]]) == ["lambda", ["lambda", "x"]]


def test_collect_libs_walks_the_chain():
    tree = ["lib l0", "defn0", ["lib l1", "defn1", "body"]]
    assert collect_libs(tree) == [("l0", "defn0"), ("l1", "defn1")]


def test_collect_libs_empty_when_nothing_learned():
    assert collect_libs(["list", "a", "b"]) == []


def test_strip_lambdas_counts_leading_binders():
    assert strip_lambdas(["lambda", ["lambda", ["f", "x"]]]) == (2, ["f", "x"])


def test_uncurry_applications_collapses_spine():
    tree = ["@", ["@", "f", "x"], "y"]
    assert uncurry_applications(tree) == ["f", "x", "y"]


def test_uncurry_keeps_variable_headed_spine_for_the_downstream_filter():
    # `filter_out_higer_order_abstractions` in src/utils.py drops these.
    assert uncurry_applications(["@", ["@", "$0", "x"], "y"]) == ["$0", "x", "y"]


def test_contains_lambda_detects_internal_binder():
    assert contains_lambda(["f", ["lambda", "x"]])
    assert not contains_lambda(["f", "x", ["g", "y"]])


def test_parse_costs_reads_both_costs():
    initial, final, ratio = parse_costs(SAMPLE_OUTPUT)
    assert (initial, final) == (66, 49)
    assert abs(ratio - 66 / 49) < 1e-9


def test_parse_babble_output_finds_the_single_lib():
    libs = parse_babble_output(SAMPLE_OUTPUT)
    assert [lib_id for lib_id, _ in libs] == ["l8"]
    assert libs[0][1] == ["lambda", ["@", ["@", "s_f", "$0"], "$0"]]


def test_parse_babble_output_rejects_output_without_a_result_block():
    try:
        parse_babble_output("running...\nno result here\n")
    except ValueError:
        return
    raise AssertionError("expected ValueError on missing result block")


# ----------------------------
# Round-tripping
# ----------------------------

def test_encode_decode_round_trips():
    # Exact round-trip for terms already using the canonical variable names,
    # i.e. A, B, C... in sorted order -- see the alpha-renaming test below.
    for term in ["f(A,B)", "f(g(A),h(B,C))", "f(A, f(B, f(A, A)))", "g(a, h(A, c))"]:
        assert decode(fof_to_babble(term)) == parse_fof_term(term), term


def test_encode_decode_alpha_renames_variables_to_canonical_names():
    # Variables come back named by position, so a term whose variables are not
    # already A, B, C... round-trips up to renaming. Constants are untouched.
    assert decode(fof_to_babble("g(a,B)")) == ["g", "a", "A"]
    assert decode(fof_to_babble("f(X,Y)")) == ["f", "A", "B"]


def test_decoded_term_prints_back_to_the_original():
    term = "f(g(A), h(B, C))"
    assert to_fof(decode(fof_to_babble(term))) == term


# ----------------------------
# to_fo_abstraction
# ----------------------------

def test_to_fo_abstraction_basic():
    s = stub_abstractions(arities={"f": 2})
    body = normalize_lambdas(parse_sexp("(λ (λ (@ (@ s_f $1) $0)))"))
    assert s.to_fo_abstraction("fn_0", body) == "fn_0(A, B) = f(B, A)"


def test_to_fo_abstraction_on_real_captured_lib():
    s = stub_abstractions(arities={"f": 2})
    _, body = parse_babble_output(SAMPLE_OUTPUT)[0]
    assert s.to_fo_abstraction("fn_0", body) == "fn_0(A) = f(A, A)"


def test_to_fo_abstraction_is_deterministic():
    s = stub_abstractions(arities={"f": 2})
    body = normalize_lambdas(parse_sexp("(λ (@ (@ s_f $0) $0))"))
    assert s.to_fo_abstraction("fn_0", body) == s.to_fo_abstraction("fn_0", body)


def test_to_fo_abstraction_renames_lib_references():
    s = stub_abstractions(arities={"f": 2}, lib_names={"l8": "fn_0"})
    body = normalize_lambdas(parse_sexp("(λ (@ (@ s_f (@ l8 $0)) $0))"))
    assert s.to_fo_abstraction("fn_1", body) == "fn_1(A) = f(fn_0(A), A)"


def test_to_fo_abstraction_pads_partial_application_to_derived_arity():
    s = stub_abstractions(arities={"f": 2})
    body = normalize_lambdas(parse_sexp("(λ (@ s_f $0))"))  # f applied to one arg
    # The missing argument is filled from the arity f has in the input problem.
    assert s.to_fo_abstraction("fn_0", body) == "fn_0(A, B) = f(A, B)"


def test_to_fo_abstraction_rejects_internal_lambda():
    s = stub_abstractions(arities={"f": 2})
    body = normalize_lambdas(parse_sexp("(λ (@ (@ s_f $0) (λ $0)))"))
    try:
        s.to_fo_abstraction("fn_0", body)
    except NotFirstOrder:
        return
    raise AssertionError("expected NotFirstOrder on an internal lambda")


def test_to_fo_abstraction_rejects_index_escaping_the_definition():
    s = stub_abstractions(arities={"f": 2})
    body = normalize_lambdas(parse_sexp("(λ (@ (@ s_f $0) $3))"))  # $3 under one lambda
    try:
        s.to_fo_abstraction("fn_0", body)
    except NotFirstOrder:
        return
    raise AssertionError("expected NotFirstOrder on an out-of-range index")


# ----------------------------
# TPTP axioms -> babble rewrites (theory.py)
# ----------------------------

def rule_bodies(axiom, **kwargs):
    return [body for _, body in directed_rules(axiom, **kwargs)]


def test_split_equation_basic():
    assert split_equation("meet(X,Y) = meet(Y,X)") == ("meet(X,Y)", "meet(Y,X)")


def test_split_equation_rejects_non_equations():
    assert split_equation("p(X)") is None          # not an equation
    assert split_equation("a != b") is None        # a goal, not an axiom


def test_tptp_vars_recognises_multi_character_names():
    # Broader than the Stitch module's single-letter `get_vars_in_term`.
    assert tptp_vars_in_term("f(X1, VAR, c)") == ["X1", "VAR"]


def test_tptp_vars_are_in_first_occurrence_order():
    assert tptp_vars_in_term("f(Y, X, Y)") == ["Y", "X"]


def test_contains_subtree_finds_proper_subterms_only():
    tree = parse_fof_term("f(g(A), B)")
    assert contains_subtree(tree, parse_fof_term("g(A)"))
    assert contains_subtree(tree, "B")
    assert not contains_subtree(tree, tree)  # not a *proper* subterm


def test_commutativity_yields_one_rule_after_dedup():
    # Both directions are the same rule once variables are numbered canonically.
    assert axioms_to_dsrs(["meet(X,Y) = meet(Y,X)"]) == [
        "ax0_l: (@ (@ s_meet ?v0) ?v1) => (@ (@ s_meet ?v1) ?v0)"
    ]


def test_associativity_yields_both_directions():
    rules = axioms_to_dsrs(["meet(meet(X,Y),Z) = meet(X,meet(Y,Z))"])
    assert len(rules) == 2
    assert rules[0].startswith("ax0_l:") and rules[1].startswith("ax0_r:")


def test_condition_1_drops_bare_variable_on_the_left():
    # The reverse of `f(X,Y) = X` would have a bare `?v0` as its pattern.
    assert not any("=> " in b and b.startswith("?v") for b in rule_bodies("f(X,Y) = X"))


def test_condition_2_drops_unbound_variable_on_the_right():
    # `n0 => meet(?v0, n0)` cannot be instantiated, so only the forward rule.
    bodies = rule_bodies("meet(X,n0) = n0", include_collapsing=True)
    assert bodies == ["(@ (@ s_meet ?v0) s_n0) => s_n0"]


def test_condition_3_drops_rules_that_embed_their_own_left_hand_side():
    # The reverse would rewrite join(...) into an ifeq3 term containing it.
    axiom = "ifeq3(meet(X,Z),X,meet(Z,join(X,Y)),join(X,meet(Y,Z))) = join(X,meet(Y,Z))"
    assert all("s_ifeq3" in body.split("=>")[0] for body in rule_bodies(axiom))


def test_condition_4_drops_collapsing_rules_by_default():
    for axiom in ["meet(X,X) = X", "meet(X,join(X,Y)) = X", "join(X,n0) = X"]:
        assert rule_bodies(axiom) == [], axiom
        assert rule_bodies(axiom, include_collapsing=True) != [], axiom


def test_rules_use_the_same_encoding_as_the_corpus():
    # A rule's pattern must match corpus terms, so symbol mangling and
    # currying have to agree with `fof_to_babble`.
    body = rule_bodies("meet(X,Y) = meet(Y,X)")[0]
    lhs = body.split("=>")[0].strip()
    corpus = fof_to_babble("meet(A,B)")
    assert "s_meet" in lhs and "s_meet" in corpus
    assert lhs.replace("?v0", "$0").replace("?v1", "$1") in corpus


if __name__ == "__main__":
    tests = [fn for name, fn in sorted(globals().items()) if name.startswith("test_")]
    for fn in tests:
        fn()
        print(f"ok  {fn.__name__}")
    print(f"\nAll {len(tests)} translation tests passed.")
