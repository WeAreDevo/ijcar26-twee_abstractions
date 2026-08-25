"""Phase 3.5: build definition-free versions of the AIM problems.

Phase 2 erased the derived operations *after the fact*, from proofs that were
found with the concepts available. Phase 3.5 removes them from the **input**:
the five defining equations are deleted and every remaining axiom and goal is
unfolded into the primitive loop signature {op, ldiv, rdiv, unit}, so a prover
working on these problems has never seen `a`, `K`, `L`, `R` or `T`. Any
construction a compressor then finds in the resulting proof was genuinely
re-derived rather than copied out of the input.

Operates on the phase-0 TPTP files (already prefix, already renamed to
op/ldiv/rdiv), rewriting formula text in place: derived symbols are unfolded
innermost-first until none remain. `a` appears unquoted, `K/L/R/T` quoted
(`'K'(...)`), because ladr_to_tptp quotes symbols that are not legal TPTP.

    python src/corpus/definition_free.py

writes data/definition_free/{aim_lc,bml_aim}/*.p (TPTP, for twee)
and the matching .in (Prover9).
"""

import re
import sys
from pathlib import Path

project_root = Path(__file__).resolve().parents[2]
if project_root.as_posix() not in sys.path:
    sys.path.append(project_root.as_posix())

from src.corpus.erasure import DEFINITIONS, tree_to_fof
from src.utils import parse_fof_term

DERIVED_RE = re.compile(r"(?<![A-Za-z0-9_'])('?)([aKLRT])\1\(")


def split_args(text: str, start: int):
    """Given text and the index of '(', return (args, index_after_')')."""
    depth, args, arg_start = 0, [], start + 1
    for i in range(start, len(text)):
        ch = text[i]
        if ch == '(':
            depth += 1
        elif ch == ')':
            depth -= 1
            if depth == 0:
                args.append(text[arg_start:i])
                return args, i + 1
        elif ch == ',' and depth == 1:
            args.append(text[arg_start:i])
            arg_start = i + 1
    raise ValueError(f"unbalanced parentheses from {start}: {text[start:start+60]}")


def unfold_text(text: str) -> str:
    """Unfold every derived-symbol application in a TPTP formula string.

    Innermost-first by construction: each application's arguments are unfolded
    recursively before the application itself is rewritten, and the loop runs
    to a fixpoint so definitions whose bodies reintroduce nothing still settle.
    """
    while True:
        match = DERIVED_RE.search(text)
        if match is None:
            return text
        sym = match.group(2)
        arity, build = DEFINITIONS[sym]
        args, end = split_args(text, match.end() - 1)
        if len(args) != arity:
            raise ValueError(f"{sym} applied to {len(args)} args: {text[match.start():end]}")
        trees = [parse_fof_term(unfold_text(arg.strip())) for arg in args]
        replacement = tree_to_fof(build(*trees))
        text = text[:match.start()] + replacement + text[end:]


def is_definition(line: str) -> bool:
    """A defining equation: `<body> = sym(distinct vars)` (either side)."""
    body = line.split(",", 2)[-1].rsplit(")", 1)[0].strip()
    for side in body.split("="):
        side = side.strip()
        m = re.fullmatch(r"'?([aKLRT])'?\(([^()]*)\)", side)
        if not m:
            continue
        args = [a.strip() for a in m.group(2).split(",")]
        if len(args) == DEFINITIONS[m.group(1)][0] and \
                all(re.fullmatch(r'[A-Z]\w*', a) for a in args) and \
                len(set(args)) == len(args):
            return True
    return False


def definition_free_tptp(problem: Path) -> str:
    """Drop the definitions, unfold everything else."""
    out = []
    for line in problem.read_text().splitlines():
        stripped = line.strip()
        if not stripped or stripped.startswith('%'):
            continue
        if not (stripped.startswith('cnf(') or stripped.startswith('fof(')):
            continue
        if is_definition(stripped):
            continue
        out.append(unfold_text(stripped))
    return "\n".join(out) + "\n"


# Prover9 reserves `op` (operator declarations), so the shared signature is
# renamed on the way in and renamed back when the proof is parsed; see
# PROVER9_TO_TPTP in src/corpus/extraction.py.
# Every target name must avoid Prover9's variable range: a symbol beginning
# with u-z is a *variable* by default. `zero` begins with `z`, so leaving it
# alone turns the identity axioms into `mult(x,y) = y` and `mult(x,y) = x`,
# which are jointly inconsistent and make everything provable in four steps.
TPTP_TO_PROVER9 = {"op": "mult", "ldiv": "ld", "rdiv": "rd",
                   "unit": "e", "zero": "e0", "'1'": "one"}


def rename_variables_for_prover9(body: str) -> str:
    """TPTP variables (A, B, X0, ...) -> Prover9 variables (v0, v1, ...).

    This is not cosmetic. Prover9's default convention is that a *variable* is
    a symbol beginning with u-z; everything else, including anything
    upper-case, is a **constant**. Leaving TPTP's upper-case variables in
    place silently turns every universally quantified axiom into a ground
    fact about constants named A, B, C -- the problem still parses and the
    prover still runs, it just proves nothing. `v0, v1, ...` begin with `v`,
    so they are variables under the default convention and are also what
    `prover9_tree_to_fof` recognises when the proof is read back.
    """
    names = []
    for token in re.findall(r'\b[A-Z]\w*\b', body):
        if token not in names:
            names.append(token)
    for i, name in enumerate(names):
        body = re.sub(rf'\b{name}\b', f'v{i}', body)
    return body


def tptp_to_prover9(tptp: str) -> str:
    """A Prover9 input for the same problem (prefix form, no infix needed).

    Prover9 accepts prefix function symbols, so op/ldiv/rdiv are renamed to
    plain identifiers rather than reconstructed as infix * \\ / -- less
    machinery, and the proof output stays in the uniform prefix signature the
    phase-1 extraction already understands.
    """
    assumptions, goals = [], []
    for line in tptp.splitlines():
        body = line.split(",", 2)[-1].rsplit(").", 1)[0].strip()
        for source, target in TPTP_TO_PROVER9.items():
            if source.startswith("'"):
                body = body.replace(source, target)
            else:
                body = re.sub(rf"\b{source}\b", target, body)
        leftover = re.search(r"'[^']*'", body)
        if leftover:
            raise ValueError(f"unmapped quoted symbol {leftover.group(0)} in: {body}")
        body = re.sub(r'!\s*\[[^\]]*\]\s*:\s*', '', body)
        if "conjecture" in line or "negated_conjecture" in line:
            goals.append(rename_variables_for_prover9(body))
        else:
            assumptions.append(rename_variables_for_prover9(body.replace("=>", "->")))
    text = "formulas(assumptions).\n"
    text += "".join(f"   {a}.\n" for a in assumptions)
    text += "end_of_list.\n\nformulas(goals).\n"
    text += "".join(f"   {g}.\n" for g in goals)
    text += "end_of_list.\n"
    return text


if __name__ == "__main__":
    out_root = project_root / "data" / "definition_free"
    sources = {
        "aim_lc": sorted((project_root / "data" / "aim_lc" / "tptp").glob("first_sketch_goal_*.p")),
        "bml_aim": sorted((project_root / "data" / "bml_aim" / "tptp").glob("3_goal_*.p")),
    }
    for corpus, problems in sources.items():
        out_dir = out_root / corpus
        out_dir.mkdir(parents=True, exist_ok=True)
        for problem in problems:
            tptp = definition_free_tptp(problem)
            (out_dir / problem.name).write_text(tptp)
            (out_dir / f"{problem.stem}.in").write_text(tptp_to_prover9(tptp))
            n = len(tptp.strip().splitlines())
            derived = DERIVED_RE.search(tptp)
            print(f"{corpus}/{problem.name}: {n} formulas, "
                  f"derived symbols remaining: {'YES ' + derived.group(0) if derived else 'none'}")
