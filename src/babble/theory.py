"""
Translate a TPTP problem's axioms into babble domain-specific rewrites (DSRs).

This is what makes babble "library learning modulo theory": instead of
compressing proof terms purely syntactically, babble first saturates them with
an equational theory, so it can find abstractions shared between subterms that
are equal under the axioms but not syntactically identical. Stitch has no
equivalent.

A babble rewrites file is one rule per line (see
`third_party/babble/src/rewrites.rs`):

    name: (@ (@ s_meet ?v0) ?v1) => (@ (@ s_meet ?v1) ?v0)

Terms use the same curried, symbol-mangled encoding as the corpus (see
`fof_to_babble`), except that variables become egg pattern variables `?v0,
?v1, ...` rather than de Bruijn indices.

TPTP unit equations are symmetric but babble's rules are directed, so each
axiom yields up to two rules. A direction is dropped when egg could not use
it -- see `directed_rules` for the two conditions.
"""

import re
from pathlib import Path

from src.babble.Abstractions import mangle, to_curried
from src.stitch.Abstractions import parse_fof_term

# TPTP's actual variable rule: an upper-case letter followed by alphanumerics
# or underscores. This is deliberately broader than `get_vars_in_term` in the
# Stitch module, which only recognises single letters (enough for twee's proof
# output, but not for arbitrary axiom files, where `X1` or `VAR` are legal).
_TPTP_VAR_RE = re.compile(r'\b[A-Z][A-Za-z0-9_]*\b')

# A negated equation; UEQ axioms are positive, so these are goals, not axioms.
_DISEQUATION = "!="


def tptp_vars_in_term(term: str):
    """Variables in a TPTP term, in order of first occurrence."""
    seen = []
    for match in _TPTP_VAR_RE.findall(term):
        if match not in seen:
            seen.append(match)
    return seen


def split_equation(axiom: str):
    """
    Split a TPTP unit equation into its two sides.

    Returns None if the axiom is not a positive unit equation (a disequation,
    or a non-equational literal such as a bare predicate).
    """
    axiom = axiom.strip().rstrip('.').strip()
    if _DISEQUATION in axiom:
        return None
    if '=' not in axiom:
        return None
    lhs, rhs = axiom.split('=', 1)
    lhs, rhs = lhs.strip(), rhs.strip()
    if not lhs or not rhs:
        return None
    return lhs, rhs


def contains_subtree(haystack, needle) -> bool:
    """Whether `needle` occurs as a proper subtree of `haystack`."""
    if isinstance(haystack, str):
        return False
    return any(arg == needle or contains_subtree(arg, needle) for arg in haystack[1:])


def encode_pattern(term: str, var_names):
    """Encode one side of an equation as a curried babble pattern."""
    return to_curried(
        parse_fof_term(term),
        lambda tok: var_names.get(tok),
    )


def is_collapsing(source_tree, target_tree) -> bool:
    """
    Whether a rule rewrites a term to one of its own subterms.

    Absorption (`meet(X, join(X,Y)) = X`), idempotence (`meet(X,X) = X`) and
    the identity laws (`join(X,n0) = X`) are all of this shape.
    """
    return isinstance(target_tree, str) and (
        target_tree == source_tree or contains_subtree(source_tree, target_tree)
    )


def directed_rules(axiom: str, include_collapsing: bool = False):
    """
    Turn one unit equation into up to two directed rewrite rules.

    A direction is dropped when egg cannot use it:

    1. The left-hand side is a bare variable. Such a pattern matches every
       e-class, so the rule is both useless and ruinously expensive.
    2. The right-hand side uses a variable the left-hand side does not bind.
       egg rejects these outright, since it would have nothing to instantiate
       the variable with.

    3. The right-hand side contains the left-hand side as a subterm. Such a
       rule always matches its own output, so it puts an e-class inside
       itself; babble's extractor then has no acyclic representative to
       return and panics. TPTP's `ifeq`-style conditional axioms are the
       usual source, e.g.
       `ifeq3(meet(X,Z), X, meet(Z,join(X,Y)), join(X,meet(Y,Z))) = join(X,meet(Y,Z))`,
       which is meant to be read left-to-right as a guarded rewrite anyway.

    4. The rule collapses a term to one of its own subterms, and
       `include_collapsing` is false (the default). This too puts an e-class
       inside itself, and combined with associativity and commutativity the
       e-matcher then explores an enormous space: on a 40-term corpus the
       lattice axioms do not finish in two minutes with these rules and take
       ten seconds without them. egg only checks its node and time limits
       between iterations, so no limit rescues a single runaway search.

       These are also the least useful rules for the task. Absorption and
       idempotence *destroy* structure, whereas commutativity, associativity
       and distributivity are what let babble see two differently-written
       subterms as equal -- which is the entire point of compressing modulo a
       theory.

    So `meet(X,Y) = meet(Y,X)` yields both directions, `meet(X,X) = X`
    neither (it collapses), and `ifeq(A,A,B,C) = B` neither (its reverse
    would need to invent A and C, and its forward direction collapses).

    Returns `[(suffix, rule_body), ...]`, with variables numbered by first
    occurrence within each direction. That numbering is canonical, so the two
    directions of a self-symmetric axiom such as commutativity come out as
    identical strings and `axioms_to_dsrs` can drop the duplicate.
    """
    split = split_equation(axiom)
    if split is None:
        return []
    lhs, rhs = split

    all_vars = set(tptp_vars_in_term(axiom))
    lhs_vars = set(tptp_vars_in_term(lhs))
    rhs_vars = set(tptp_vars_in_term(rhs))

    rules = []
    for suffix, (source, target, source_vars, target_vars) in (
        ("l", (lhs, rhs, lhs_vars, rhs_vars)),
        ("r", (rhs, lhs, rhs_vars, lhs_vars)),
    ):
        if source in all_vars:  # condition 1: bare variable on the left
            continue
        if not target_vars <= source_vars:  # condition 2: unbound on the right
            continue
        source_tree, target_tree = parse_fof_term(source), parse_fof_term(target)
        # condition 3: the rule would embed its own left-hand side
        if contains_subtree(target_tree, source_tree):
            continue
        # condition 4: the rule collapses a term to its own subterm
        if not include_collapsing and is_collapsing(source_tree, target_tree):
            continue
        # Number variables by first occurrence, source side first.
        order = tptp_vars_in_term(source)
        order += [v for v in tptp_vars_in_term(target) if v not in order]
        var_names = {v: f"?v{i}" for i, v in enumerate(order)}
        rules.append(
            (suffix, f"{encode_pattern(source, var_names)}"
                     f" => {encode_pattern(target, var_names)}")
        )
    return rules


def axioms_to_dsrs(axioms, include_collapsing: bool = False):
    """
    Translate a list of TPTP axiom strings into babble rewrite rules.

    Rules that are identical after canonical variable numbering are emitted
    once. The common case is a symmetric axiom like `meet(X,Y) = meet(Y,X)`,
    whose two directions are the same rule.
    """
    rules = []
    seen = set()
    for i, axiom in enumerate(axioms):
        for suffix, body in directed_rules(axiom, include_collapsing):
            if body in seen:
                continue
            seen.add(body)
            rules.append(f"ax{i}_{suffix}: {body}")
    return rules


def dsrs_for_problem(problem_file_path, include_collapsing: bool = False):
    """
    Read a TPTP problem's axioms (following `include`s) and translate them.

    Returns a list of rule strings, empty if the problem has no usable axioms.
    """
    from src.utils import extract_axioms_from_tptp_file

    return axioms_to_dsrs(
        extract_axioms_from_tptp_file(problem_file_path), include_collapsing
    )


def function_symbols(terms):
    """Every function symbol occurring in a list of FOF terms."""
    symbols = set()

    def walk(tree):
        if isinstance(tree, str):
            return
        symbols.add(tree[0])
        for arg in tree[1:]:
            walk(arg)

    for term in terms:
        walk(parse_fof_term(term))
    return symbols


def rules_apply_to(rules, terms) -> bool:
    """
    Whether any rule mentions a symbol the terms actually use.

    A theory over symbols the corpus never mentions is a silent no-op, which
    is easy to mistake for "the theory did not help".
    """
    used = {mangle(symbol) for symbol in function_symbols(terms)}
    return any(symbol in rule for rule in rules for symbol in used)


def write_dsr_file(rules, path):
    """Write rules to a babble rewrites file and return the path."""
    path = Path(path)
    path.write_text("".join(f"{rule}\n" for rule in rules))
    return path
