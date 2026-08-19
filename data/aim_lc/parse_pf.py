"""Parse Prover9 `prooftrans` .pf files into structured proofs.

A .pf file (as produced for the AIM_LC corpus) contains one PROOF block per
proved goal. Each block has comment metadata followed by numbered steps:

    54 (x * (y * z)) * a(x,y,z) = (x * y) * z.  [para(19(a,1),16(a,1,2))].

This parser keeps every step, records its justification, and classifies it,
so later phases can select e.g. only positive unit equations for compression.

    python data/aim_lc/parse_pf.py            # parses *.pf here -> parsed/*.json

Output: one JSON file per .pf, a list of proofs, each with:

    goal        the goal label, e.g. "aK2"
    meta        the "% Length of proof is ..." comment block, parsed
    steps       [{id, text, justification, kind, labels}]

where kind is one of:
    equation    positive unit equation (the compression corpus material)
    negated     a denial / negated equation (contains !=)
    clause      anything with logical structure (| or ->)
    false       the final $F step
"""

import json
import re
import sys
from pathlib import Path

# Step ids are plain integers in ordinary proofs; `prooftrans expand` breaks
# compound justifications into primitive paramodulation steps with
# letter-suffixed ids (51A, 51B, ...), so the id is kept as a string.
STEP_RE = re.compile(r'^\s*(\d+[A-Z]*)\s+(.*?)\s*\.\s*\[(.*)\]\.?\s*$')
META_RE = re.compile(
    r'% Proof (\d+) at ([\d.]+) .*? seconds: "([^"]+)"\.'
    r'.*?% Length of proof is (\d+)\.'
    r'.*?% Level of proof is (\d+)\.'
    r'.*?% Maximum clause weight is (\d+)\.'
    r'.*?% Given clauses (\d+)\.',
    re.DOTALL,
)
LABEL_RE = re.compile(r'#\s*(?:label|answer)\("?([^")]+)"?\)')


def classify(text: str) -> str:
    if text.strip() == "$F":
        return "false"
    if "|" in text or "->" in text:
        return "clause"
    if "!=" in text:
        return "negated"
    if "=" in text:
        return "equation"
    return "clause"


def parse_proof_block(block: str):
    meta = None
    m = META_RE.search(block)
    if m:
        meta = {
            "proof_number": int(m.group(1)),
            "seconds": float(m.group(2)),
            "goal": m.group(3),
            "length": int(m.group(4)),
            "level": int(m.group(5)),
            "max_clause_weight": int(m.group(6)),
            "given_clauses": int(m.group(7)),
        }

    steps = []
    for line in block.splitlines():
        sm = STEP_RE.match(line)
        if not sm:
            continue
        step_id, body, justification = sm.groups()
        labels = LABEL_RE.findall(body)
        # strip the "# label(...)" annotations off the logical content
        text = body.split("#", 1)[0].strip()
        steps.append({
            "id": step_id,
            "text": text,
            "justification": justification,
            "kind": classify(text),
            "labels": labels,
        })

    return {"goal": meta["goal"] if meta else None, "meta": meta, "steps": steps}


def parse_pf(path: Path):
    content = path.read_text()
    # Split on the PROOF banner; the first chunk is the file header.
    chunks = re.split(r'=+ PROOF =+', content)[1:]
    return [parse_proof_block(chunk) for chunk in chunks]


if __name__ == "__main__":
    here = Path(__file__).resolve().parent
    out_dir = here / "parsed"
    out_dir.mkdir(exist_ok=True)
    for pf in sorted(here.glob("*.pf")):
        proofs = parse_pf(pf)
        out = out_dir / f"{pf.stem}.json"
        out.write_text(json.dumps(proofs, indent=1))
        eq = sum(sum(1 for s in p["steps"] if s["kind"] == "equation") for p in proofs)
        print(f"{pf.name}: {len(proofs)} proofs, "
              f"{sum(len(p['steps']) for p in proofs)} steps, {eq} equations "
              f"-> {out.relative_to(here.parent.parent)}")
