"""Definition-FUL counterparts of the phase-3.5 hint goals.

`hint_goals.py` builds each hint conjecture over the *definition-free* AIM
axioms. This builds the same conjectures over the axioms with `a/K/L/R/T` still
defined, so the prover may use the derived operations. The pair is the control
for "does erasing definitions put a proof out of GAPT's reach?" -- for these
goals it does not, because the conjectures themselves are primitive (see
PROGRESS_herbrand.md).

    python src/corpus/hint_goals_defful.py

writes data/definition_ful/aim_lc_hints/hint<NN>_d<depth>.{p,in} plus
`_probe_xy.in`, the consistency probe.
"""

import sys
from pathlib import Path

project_root = Path(__file__).resolve().parents[2]
if project_root.as_posix() not in sys.path:
    sys.path.append(project_root.as_posix())

import src.corpus.definition_free as df
from src.corpus.hint_goals import primitive_hints, to_tptp_conjecture, max_depth

# Prover9 reads any symbol beginning u-z as a variable and everything else,
# *including upper case*, as a constant -- and `rename_variables_for_prover9`
# rewrites every [A-Z] token into a variable. So 'K' must not map to `K`, or
# the commutator silently becomes a variable. Lowercase, not u-z:
DERIVED_MAP = {"'K'": "k", "'L'": "l", "'R'": "r", "'T'": "t"}


def build(count: int = 10) -> list:
    df.TPTP_TO_PROVER9.update(DERIVED_MAP)

    source = project_root / "data" / "aim_lc" / "tptp" / "first_sketch_goal_1.p"
    axioms = [line for line in source.read_text().splitlines()
              if line.strip() and not line.startswith("%")
              and not line.startswith("fof(goals")]

    hints = primitive_hints(project_root / "data" / "aim_lc" / "second_sketch.in")
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
    pool = [h for h in unique if max_depth(h) >= 3]
    step = max(1, len(pool) // count)
    chosen = pool[::step][:count]

    out_dir = project_root / "data" / "definition_ful" / "aim_lc_hints"
    out_dir.mkdir(parents=True, exist_ok=True)
    written = []
    for i, hint in enumerate(chosen, 1):
        name = f"hint{i:02d}_d{max_depth(hint)}"
        tptp = "\n".join(axioms) + "\n" + to_tptp_conjecture(hint, name) + "\n"
        (out_dir / f"{name}.p").write_text(tptp)
        (out_dir / f"{name}.in").write_text(df.tptp_to_prover9(tptp))
        written.append((name, hint))

    # The axioms must not prove x = y; run this before trusting any result.
    (out_dir / "_probe_xy.in").write_text(
        df.tptp_to_prover9("\n".join(axioms) + "\n"
                           + "fof(probe,conjecture,! [A,B] : A = B).\n"))
    return written


if __name__ == "__main__":
    for name, hint in build(int(sys.argv[1]) if len(sys.argv) > 1 else 10):
        print(f"{name}: {hint[:78]}")
