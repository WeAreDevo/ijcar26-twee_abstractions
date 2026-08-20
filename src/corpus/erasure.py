"""Phase 2: AIM definition erasure and recovery matching.

The AIM input defines five derived operations over the loop signature:

    (x * (y * z)) \\ ((x * y) * z) = a(x,y,z)     associator
    (x * y) \\ (y * x)             = K(y,x)       commutator
    (y * x) \\ (y * (x * u))       = L(u,x,y)
    ((u * x) * y) / (x * y)        = R(u,x,y)
    x \\ (u * x)                   = T(u,x)

`erase` rewrites a phase-1 record list into one where these concepts are
never named: every occurrence of a/K/L/R/T is unfolded into its definition
(bottom-up, so nested occurrences like L(R(u,x,y),z,w) unfold fully), and the
records of the five defining equations themselves are dropped (after
unfolding they would be trivial t = t pairs that inject the answer verbatim).

`match_abstractions` then checks a compressor's learned abstractions against
the hidden definition bodies, alpha-equivalence being the match criterion.
"""

import sys
from pathlib import Path

project_root = Path(__file__).resolve().parents[2]
if project_root.as_posix() not in sys.path:
    sys.path.append(project_root.as_posix())

from src.utils import normalize_fof_term, parse_fof_term

# Definition bodies as tree builders over already-unfolded argument trees.
# Argument order matters and follows the AIM definitions verbatim:
# e.g. K(y,x) = (x*y) \ (y*x), so K(t1,t2) has y=t1, x=t2.
DEFINITIONS = {
    "a": (3, lambda t1, t2, t3:
          ["ldiv", ["op", t1, ["op", t2, t3]], ["op", ["op", t1, t2], t3]]),
    "K": (2, lambda t1, t2:
          ["ldiv", ["op", t2, t1], ["op", t1, t2]]),
    "L": (3, lambda t1, t2, t3:
          ["ldiv", ["op", t3, t2], ["op", t3, ["op", t2, t1]]]),
    "R": (3, lambda t1, t2, t3:
          ["rdiv", ["op", ["op", t1, t2], t3], ["op", t2, t3]]),
    "T": (2, lambda t1, t2:
          ["ldiv", t2, ["op", t1, t2]]),
}


def tree_to_fof(tree) -> str:
    if isinstance(tree, str):
        return tree
    return f"{tree[0]}({', '.join(tree_to_fof(a) for a in tree[1:])})"


def unfold_tree(tree, defs=DEFINITIONS):
    """Unfold every application of a symbol in `defs`, bottom-up."""
    if isinstance(tree, str):
        return tree
    head, args = tree[0], [unfold_tree(a, defs) for a in tree[1:]]
    if head in defs:
        arity, build = defs[head]
        if len(args) == arity:
            return build(*args)
    return [head] + args


def unfold_term(term: str, defs=DEFINITIONS) -> str:
    """Unfold a prefix FOF term and re-alpha-normalize it.

    Renormalization matters: unfolding changes the order in which variables
    first occur (K swaps its arguments' roles), so the phase-1 A,B,C naming
    is stale after unfolding.
    """
    return normalize_fof_term(tree_to_fof(unfold_tree(parse_fof_term(term), defs)))


def is_definition_application(term: str, defs=DEFINITIONS) -> bool:
    """Whether a term is `sym(vars)` for a derived sym with distinct var args:
    the shape of a defining equation's named side."""
    tree = parse_fof_term(term)
    if isinstance(tree, str) or tree[0] not in defs:
        return False
    args = tree[1:]
    return (len(args) == defs[tree[0]][0]
            and all(isinstance(a, str) and len(a) == 1 and a.isupper() for a in args)
            and len(set(args)) == len(args))


def defining_steps(records: list, defs=DEFINITIONS) -> set:
    """Step ids of the defining equations of the erased symbols (input steps
    with a bare derived-symbol application on one side)."""
    return {r["step"] for r in records
            if r["is_input"] and is_definition_application(r["term"], defs)}


def erase(records: list, targets=None) -> list:
    """Unfold derived symbols and drop their defining equations' records.

    `targets` limits erasure to a subset of {a,K,L,R,T}; default is all five.
    Non-erased symbols keep their names and their defining equations.
    Returns new records; the input list is untouched.
    """
    defs = DEFINITIONS if targets is None else \
        {k: v for k, v in DEFINITIONS.items() if k in targets}
    drop = defining_steps(records, defs)
    return [{**r, "term": unfold_term(r["term"], defs)}
            for r in records if r["step"] not in drop]


# ----------------------------
# Recovery matching
# ----------------------------

def target_bodies(defs=DEFINITIONS) -> dict:
    """The hidden definition bodies, alpha-normalized: what recovery means."""
    bodies = {}
    for sym, (arity, build) in defs.items():
        args = [chr(ord('A') + i) for i in range(arity)]
        bodies[sym] = normalize_fof_term(tree_to_fof(build(*args)))
    return bodies


def _subterms(tree):
    yield tree
    if not isinstance(tree, str):
        for arg in tree[1:]:
            yield from _subterms(arg)


def match_abstractions(fo_abstractions: list) -> dict:
    """Check learned abstractions against the hidden definition bodies.

    fo_abstractions: the engine's ranked "fn_i(...) = body" strings.
    Returns {sym: {rank, match, abstraction}} for each recovered target;
    match is "alpha" (the whole body is alpha-equivalent to the definition)
    or "subterm" (the definition body occurs inside a larger abstraction).
    A whole-body match beats a subterm match; earlier rank beats later.
    """
    targets = target_bodies()
    recovered = {}
    for rank, abstraction in enumerate(fo_abstractions, start=1):
        body = abstraction.split("=", 1)[1].strip()
        normalized = normalize_fof_term(body)
        sub_normalized = {normalize_fof_term(tree_to_fof(s))
                          for s in _subterms(parse_fof_term(body))}
        for sym, target in targets.items():
            if normalized == target:
                match = "alpha"
            elif target in sub_normalized:
                match = "subterm"
            else:
                continue
            best = recovered.get(sym)
            if best is None or (best["match"], best["rank"]) > (match, rank):
                # ("alpha" < "subterm" lexically, so alpha wins; then rank)
                recovered[sym] = {"rank": rank, "match": match,
                                  "abstraction": abstraction}
    return recovered
