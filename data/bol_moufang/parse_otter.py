"""Parse the Phillips-Vojtechovsky Otter proof archive and emit TPTP problems.

qbm_otter_proofs.txt holds 9 Otter proofs over the quasigroup signature
{*, \\, /}. Steps look like

    19 [para_into,11.1.1.1.2,11.1.1,demod,12] x* (y* ((z* (u*y))*x))=...
    3,2 [] x* (x\\y)=y.

where a leading "d,n" pair means clause n also acts as demodulator d.
Lines with justification [] are the input clauses: the quasigroup axioms,
the hypothesis identity, and one denial (!=) whose uppercase letters are
Skolem constants.

Outputs:
    parsed/qbm.json          all proofs, structured
    tptp/thmN.p              one TPTP problem per theorem (axioms + denial)

Term syntax: infix *, \\, / are fully parenthesized except at the top level
of each equation side, so parsing only ever has to find one depth-0 operator.
Otter's lowercase x,y,z,u,v,w are variables; uppercase A,B,C are constants.
The TPTP rendering matches data/bml_aim (op/ldiv/rdiv), so downstream twee
output has one uniform signature.
"""

import json
import re
from pathlib import Path

here = Path(__file__).resolve().parent

STEP_RE = re.compile(r'^\s*(?:\d+,)?(\d+)\s+\[([^\]]*)\]\s+(.*?)\.\s*$')
THEOREM_RE = re.compile(r'^THEOREM (\d+): (.*)$', re.MULTILINE)
PROOF_META_RE = re.compile(
    r'PROOF:\s*\[\s*([\d.]+)\s*sec,\s*\w+ of proof is (\d+),\s*level of proof is (\d+)\s*\]')  # \\w+: the archive misspells one 'length'

OPS = {'*': 'op', '\\': 'ldiv', '/': 'rdiv'}
VARIABLES = set('xyzuvw')


def parse_term(s: str):
    """Parse one side of an Otter equation into a nested prefix list."""
    s = s.replace(' ', '')
    if not s:
        raise ValueError("empty term")
    # find a top-level operator
    depth = 0
    for i, ch in enumerate(s):
        if ch == '(':
            depth += 1
        elif ch == ')':
            depth -= 1
        elif depth == 0 and ch in OPS:
            return [OPS[ch], parse_term(s[:i]), parse_term(s[i + 1:])]
    if s.startswith('(') and s.endswith(')'):
        return parse_term(s[1:-1])
    return s  # atom


def to_tptp(tree, top=False) -> str:
    if isinstance(tree, str):
        if tree in VARIABLES:
            return tree.upper()
        if tree.isupper():        # Otter Skolem constant
            return f"sk_{tree.lower()}"
        return tree
    head, lhs, rhs = tree
    return f"{head}({to_tptp(lhs)},{to_tptp(rhs)})"


def parse_equation(text: str):
    """-> (lhs_tree, rhs_tree, negated), or None for the final $F step."""
    if text.strip() == '$F':
        return None
    if '!=' in text:
        lhs, rhs = text.split('!=', 1)
        return parse_term(lhs), parse_term(rhs), True
    lhs, rhs = text.split('=', 1)
    return parse_term(lhs), parse_term(rhs), False


def parse_archive(path: Path):
    content = path.read_text()
    theorems = []
    matches = list(THEOREM_RE.finditer(content))
    for i, m in enumerate(matches):
        end = matches[i + 1].start() if i + 1 < len(matches) else len(content)
        block = content[m.start():end]
        meta = PROOF_META_RE.search(block)
        steps = []
        for line in block.splitlines():
            sm = STEP_RE.match(line)
            if not sm:
                continue
            step_id, justification, text = sm.groups()
            parsed = parse_equation(text)
            if parsed is None:
                steps.append({"id": int(step_id), "text": "$F", "tptp": None,
                              "justification": justification,
                              "is_input": False, "negated": False})
                continue
            lhs, rhs, negated = parsed
            steps.append({
                "id": int(step_id),
                "text": text.strip(),
                "tptp": f"{to_tptp(lhs)} {'!=' if negated else '='} {to_tptp(rhs)}",
                "justification": justification,
                "is_input": justification == "",
                "negated": negated,
            })
        theorems.append({
            "number": int(m.group(1)),
            "statement": m.group(2).strip(),
            "seconds": float(meta.group(1)) if meta else None,
            "length": int(meta.group(2)) if meta else None,
            "level": int(meta.group(3)) if meta else None,
            "steps": steps,
        })
    return theorems


def write_tptp(theorem, tptp_dir: Path):
    lines = [f"% {theorem['statement']}",
             f"% Reconstructed from the Otter proof's input clauses."]
    n = 0
    for step in theorem["steps"]:
        if not step["is_input"]:
            continue
        if step["negated"]:
            lines.append(f"cnf(goal, negated_conjecture, {step['tptp']}).")
        else:
            n += 1
            lines.append(f"cnf(ax{n}, axiom, {step['tptp']}).")
    out = tptp_dir / f"thm{theorem['number']}.p"
    out.write_text("\n".join(lines) + "\n")
    return out


if __name__ == "__main__":
    theorems = parse_archive(here / "qbm_otter_proofs.txt")
    (here / "parsed").mkdir(exist_ok=True)
    (here / "parsed" / "qbm.json").write_text(json.dumps(theorems, indent=1))
    (here / "tptp").mkdir(exist_ok=True)
    for theorem in theorems:
        out = write_tptp(theorem, here / "tptp")
        inputs = sum(s["is_input"] for s in theorem["steps"])
        print(f"thm{theorem['number']}: len={theorem['length']} level={theorem['level']} "
              f"steps_parsed={len(theorem['steps'])} inputs={inputs} -> {out.name}")
