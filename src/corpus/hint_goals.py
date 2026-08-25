"""Phase 3.5: easier definition-free goals drawn from the AIM hint pool.

The seven AIM goals are hard even *with* the derived operations available;
without them they are unlikely to fall in 60s. `second_sketch.in` carries
5,717 hints — intermediate lemmas from the first_sketch proofs — of which 552
mention only the primitive loop signature. Those are genuine consequences of
the definition-free axioms and make graded, tractable goals.

    python src/corpus/hint_goals.py [count]

writes data/definition_free/aim_lc_hints/hint<NN>_d<depth>.{p,in},
each the definition-free AIM axioms plus one hint as the conjecture.
"""

import re
import sys
from pathlib import Path

project_root = Path(__file__).resolve().parents[2]
if project_root.as_posix() not in sys.path:
    sys.path.append(project_root.as_posix())

from src.corpus.definition_free import tptp_to_prover9
from src.corpus.extraction import parse_prover9_term, prover9_tree_to_fof

DERIVED = re.compile(r'\b[aKLRT]\(')


def max_depth(text: str) -> int:
    depth = best = 0
    for ch in text:
        if ch == '(':
            depth += 1
            best = max(best, depth)
        elif ch == ')':
            depth -= 1
    return best


def primitive_hints(path: Path) -> list:
    body = path.read_text().split("formulas(hints).")[1]
    hints = []
    for line in body.splitlines():
        line = line.strip().rstrip('.')
        if not line or line.startswith('%') or line.startswith('end_of_list'):
            continue
        if DERIVED.search(line) or '->' in line or '#' in line or '=' not in line:
            continue
        hints.append(line)
    return hints


def to_tptp_conjecture(hint: str, name: str) -> str:
    """Prover9 infix hint -> a TPTP conjecture over op/ldiv/rdiv/unit."""
    lhs, rhs = hint.split('=', 1)
    sides = [prover9_tree_to_fof(parse_prover9_term(s)) for s in (lhs, rhs)]
    variables = sorted({v for side in sides for v in re.findall(r'\b[A-Z]\b', side)})
    quantifier = f"! [{', '.join(variables)}] : " if variables else ""
    return f"fof({name},conjecture,{quantifier}{sides[0]} = {sides[1]})."


if __name__ == "__main__":
    count = int(sys.argv[1]) if len(sys.argv) > 1 else 10
    source = project_root / "data" / "definition_free" / "aim_lc" / "first_sketch_goal_1.p"
    axioms = [line for line in source.read_text().splitlines()
              if not line.startswith("fof(goals")]

    hints = primitive_hints(project_root / "data" / "aim_lc" / "second_sketch.in")
    # de-duplicate up to alpha-equivalence, then spread across the depth range
    seen, unique = set(), []
    for hint in hints:
        try:
            key = to_tptp_conjecture(hint, "k")
        except Exception:
            continue
        if key not in seen:
            seen.add(key)
            unique.append(hint)
    unique.sort(key=max_depth)
    # skip the trivial first few (axioms themselves), then sample evenly
    pool = [h for h in unique if max_depth(h) >= 3]
    step = max(1, len(pool) // count)
    chosen = pool[::step][:count]

    out_dir = project_root / "data" / "definition_free" / "aim_lc_hints"
    out_dir.mkdir(parents=True, exist_ok=True)
    for i, hint in enumerate(chosen, 1):
        name = f"hint{i:02d}_d{max_depth(hint)}"
        tptp = "\n".join(axioms) + "\n" + to_tptp_conjecture(hint, name) + "\n"
        (out_dir / f"{name}.p").write_text(tptp)
        (out_dir / f"{name}.in").write_text(tptp_to_prover9(tptp))
        print(f"{name}: {hint[:78]}")
