"""Translate the AIM_LC Prover9 inputs into per-goal TPTP problems for twee.

Reuses the ladr_to_tptp helpers from data/bml_aim/translate.py. Unlike the
bml_aim inputs, the AIM .in files carry Prover9 search directives (assign,
set, lex, list(actions), list(given_selection)) that ladr_to_tptp does not
want, so only the formulas(...) blocks are kept.

    python data/aim_lc/translate_aim.py

writes data/aim_lc/tptp/{first_sketch,second_sketch}_goal_N.p
(lc.in is skipped by default: its 140KB of hints are search guidance,
not theory, and the hint-laden axiom list is not a meaningful re-run).
"""

import importlib.util
import re
import sys
from pathlib import Path

here = Path(__file__).resolve().parent

spec = importlib.util.spec_from_file_location(
    "bml_translate", here.parent / "bml_aim" / "translate.py"
)
bml_translate = importlib.util.module_from_spec(spec)
spec.loader.exec_module(bml_translate)


def formulas_blocks_only(text: str) -> str:
    """Keep only formulas(...) ... end_of_list blocks, dropping directives."""
    blocks = re.findall(
        r'^formulas\([^)]*\)\.\n.*?^end_of_list\.', text, re.MULTILINE | re.DOTALL
    )
    return "\n".join(blocks) + "\n"


def rename_aim_constants(tptp_text: str) -> str:
    """AIM uses 1 as the loop identity; ladr_to_tptp quotes it as '1'."""
    return tptp_text.replace("'1'", "unit")


def translate_aim_file(in_path: Path, tptp_dir: Path):
    text = formulas_blocks_only(in_path.read_text())
    tptp_text = bml_translate.translate_prover9_to_tptp(text, problem_name=in_path.stem)
    tptp_text = bml_translate.rename_constants(tptp_text)
    tptp_text = rename_aim_constants(tptp_text)

    goals, axioms = [], ""
    for line in tptp_text.splitlines():
        if line.startswith("fof(") and "conjecture" in line:
            goals.append(line)
        else:
            axioms += line + "\n"

    written = []
    for i, goal in enumerate(goals):
        goal_name = f"{in_path.stem}_goal_{i + 1}"
        goal_line = re.sub(r'fof\(([^,]+), conjecture,', f'fof({goal_name}, conjecture,', goal)
        out_path = tptp_dir / f"{goal_name}.p"
        out_path.write_text(axioms + goal_line + "\n")
        written.append(out_path)
    return written


if __name__ == "__main__":
    tptp_dir = here / "tptp"
    tptp_dir.mkdir(exist_ok=True)
    sources = sys.argv[1:] or ["first_sketch.in", "second_sketch.in"]
    for name in sources:
        for out in translate_aim_file(here / name, tptp_dir):
            print(f"wrote {out.relative_to(here.parent.parent)}")
