"""Uniform proof-term extraction across the three proof sources (Phase 1).

Sources and their shapes:

  prover9   parsed .pf JSONs (data/aim_lc/parsed/*.json): infix Prover9 text
            per step, e.g. "(x * (y * z)) \\ ((x * y) * z) = a(x,y,z)"
  otter     parsed archive JSON (data/bol_moufang/parsed/qbm.json): steps
            already carry a prefix `tptp` rendering, e.g. "op(X,ldiv(X,Y)) = Y"
  twee      raw trace text (data/*/twee/*.out): prefix terms, extracted by the
            existing src.utils.extract_terms

Every source is reduced to the same thing: a list of *term records*

    {"term": <alpha-normalized prefix FOF term>,
     "step": <source step id or None>,
     "side": "lhs" | "rhs" | None,
     "is_input": <term comes from an input clause (axiom/definition)>}

- top-level terms only: each proof equation contributes its two sides
  (a twee proof chain contributes each chain line);
- multiplicity preserved: one record per occurrence, in proof order;
- alpha-normalized: variables renamed A, B, C, ... by first occurrence,
  per term (so both sides of an equation normalize independently);
- the uniform signature is op/ldiv/rdiv (+ unit, a, K, L, R, T, Skolem
  constants), matching the TPTP problems from phase 0.

`stitch_input` / `babble_input` turn a record list into the encoder inputs.
"""

import re
import sys
from pathlib import Path

project_root = Path(__file__).resolve().parents[2]
if project_root.as_posix() not in sys.path:
    sys.path.append(project_root.as_posix())

from src.utils import extract_terms, normalize_fof_term

INFIX_OPS = {'*': 'op', '\\': 'ldiv', '/': 'rdiv'}
# 'e0' is the definition-free encoding of `zero` (see definition_free.py):
# `zero` itself begins with `z` and would be read as a variable.
CONSTANT_MAP = {'1': 'unit', '0': 'zero', 'e': 'unit', 'e0': 'zero'}
ATOM_RE = re.compile(r"[A-Za-z0-9_']+")
APPLICATION_RE = re.compile(r"([A-Za-z0-9_']+)\((.*)\)", re.DOTALL)


# ----------------------------
# Prover9 infix -> prefix FOF
# ----------------------------

def _depth0_positions(s: str, chars) -> list:
    positions, depth = [], 0
    for i, ch in enumerate(s):
        if ch == '(':
            depth += 1
        elif ch == ')':
            depth -= 1
        elif depth == 0 and ch in chars:
            positions.append(i)
    return positions


def _split_depth0_commas(s: str) -> list:
    parts, depth, start = [], 0, 0
    for i, ch in enumerate(s):
        if ch == '(':
            depth += 1
        elif ch == ')':
            depth -= 1
        elif ch == ',' and depth == 0:
            parts.append(s[start:i])
            start = i + 1
    parts.append(s[start:])
    return parts


def parse_prover9_term(s: str):
    """Parse a Prover9/Otter-style term into a nested prefix list.

    Handles binary infix *, \\, / (renamed to op/ldiv/rdiv), prefix
    applications like a(x,z,z \\ y), and atoms. Prover9 output parenthesizes
    every infix application except the outermost one per level, so exactly
    one depth-0 operator can occur; more than one is a parse error rather
    than a precedence guess.
    """
    s = re.sub(r'\s+', '', s)

    def parse(t: str):
        if not t:
            raise ValueError("empty term")
        ops = _depth0_positions(t, INFIX_OPS)
        if len(ops) > 1:
            raise ValueError(f"ambiguous infix term (multiple depth-0 operators): {t}")
        if ops:
            i = ops[0]
            return [INFIX_OPS[t[i]], parse(t[:i]), parse(t[i + 1:])]
        if t.startswith('('):
            if not t.endswith(')'):
                raise ValueError(f"unbalanced parentheses: {t}")
            return parse(t[1:-1])
        m = APPLICATION_RE.fullmatch(t)
        if m:
            head, args = m.groups()
            return [head] + [parse(a) for a in _split_depth0_commas(args)]
        if not ATOM_RE.fullmatch(t):
            raise ValueError(f"cannot parse atom: {t}")
        return t

    return parse(s)


def prover9_tree_to_fof(tree) -> str:
    """Render a parsed Prover9 tree as an alpha-normalized prefix FOF term.

    Prover9's variable rule is exact: a symbol is a variable iff it starts
    with u-z (covering x, y, z, u, w, v and the numbered v5, v6, ... that
    appear once a clause needs more than six variables). Variables become
    A, B, C, ... by first occurrence; 0/1 become zero/unit.
    """
    mapping = {}

    def render(t) -> str:
        if isinstance(t, str):
            if t[0] in 'uvwxyz':
                if t not in mapping:
                    if len(mapping) >= 26:
                        raise ValueError("more than 26 distinct variables")
                    mapping[t] = chr(ord('A') + len(mapping))
                return mapping[t]
            return CONSTANT_MAP.get(t, t)
        head, args = t[0], t[1:]
        return f"{head}({', '.join(render(a) for a in args)})"

    return render(tree)


def split_equation(text: str):
    """Split 'lhs = rhs' at the (single) depth-0 '=' of a positive equation."""
    positions = _depth0_positions(text, '=')
    if len(positions) != 1:
        raise ValueError(f"not a unit equation: {text}")
    i = positions[0]
    return text[:i].strip(), text[i + 1:].strip()


# ----------------------------
# Per-source record extraction
# ----------------------------

def terms_from_prover9_proof(proof: dict) -> list:
    """Term records from one parsed .pf proof (plain or expanded)."""
    records = []
    for step in proof["steps"]:
        if step["kind"] != "equation":
            continue
        lhs, rhs = split_equation(step["text"])
        is_input = step["justification"] == "assumption"
        for side, text in (("lhs", lhs), ("rhs", rhs)):
            records.append({
                "term": prover9_tree_to_fof(parse_prover9_term(text)),
                "step": step["id"],
                "side": side,
                "is_input": is_input,
            })
    return records


def terms_from_otter_theorem(theorem: dict) -> list:
    """Term records from one parsed Otter theorem (steps carry prefix tptp)."""
    records = []
    for step in theorem["steps"]:
        if step["negated"] or step["tptp"] is None:
            continue
        lhs, rhs = split_equation(step["tptp"])
        for side, text in (("lhs", lhs), ("rhs", rhs)):
            records.append({
                "term": normalize_fof_term(text),
                "step": str(step["id"]),
                "side": side,
                "is_input": step["is_input"],
            })
    return records


# Prover9 reserves `op`, so definition-free problems are posed over renamed
# symbols (see src/corpus/definition_free.py); undo that here so proof terms
# land in the same signature as every other source.
PROVER9_TO_TPTP = {"mult": "op", "ld": "ldiv", "rd": "rdiv"}
KEPT_RE = re.compile(r'^kept:\s+\d+\s+(.*?)\.\s*\[(.*)\]\.?\s*$')


def rename_prover9_symbols(term: str) -> str:
    """Rename the function symbols only.

    The identity constant `e` is deliberately left alone and mapped by
    CONSTANT_MAP at render time: renaming it to `unit` here would hand the
    parser a symbol starting with `u`, which Prover9's variable rule treats
    as a variable.
    """
    for source, target in PROVER9_TO_TPTP.items():
        term = re.sub(rf'\b{source}\b(?=\()', target, term)
    return term


def terms_from_prover9_kept(text: str) -> list:
    """Term records from a Prover9 run's `kept:` clauses (`set(print_kept)`).

    This is the Prover9 analogue of a twee partial proof: when the search
    fails, the kept clauses are what it managed to derive. Non-equations and
    clauses containing a negated literal are skipped, matching the other
    sources.
    """
    records = []
    for line in text.splitlines():
        match = KEPT_RE.match(line)
        if not match:
            continue
        body, justification = match.groups()
        body = body.split("#", 1)[0].strip()
        if "|" in body or "!=" in body or "=" not in body:
            continue
        lhs, rhs = split_equation(rename_prover9_symbols(body))
        for side, text_side in (("lhs", lhs), ("rhs", rhs)):
            records.append({
                "term": prover9_tree_to_fof(parse_prover9_term(text_side)),
                "step": None,
                "side": side,
                "is_input": justification == "assumption",
            })
    return records


def terms_from_twee_output(text: str) -> list:
    """Term records from a twee proof trace (the equational chain lines).

    twee quotes symbols that were quoted in the TPTP input ('K', 'L', ...);
    the quotes are stripped so the signature matches the other sources.
    All chain terms are derived, so is_input is always False.
    """
    terms = extract_terms(text, {"onlyProofTerms": True, "onlyPeakTerms": False})
    return [{
        "term": normalize_fof_term(t.replace("'", "")),
        "step": None,
        "side": None,
        "is_input": False,
    } for t in terms]


# ----------------------------
# Compressor input export
# ----------------------------

def stitch_input(records: list) -> list:
    """The FOF->lambda encodings Stitch consumes (see Stitch_Abstractions)."""
    from src.stitch.Abstractions import fof_to_lambda
    return [fof_to_lambda(r["term"]) for r in records]


def babble_input(records: list) -> list:
    """The curried encodings babble consumes (see Babble_Abstractions)."""
    from src.babble.Abstractions import fof_to_babble
    return [fof_to_babble(r["term"]) for r in records]
