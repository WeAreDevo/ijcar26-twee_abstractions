"""Build data/aim_lc/metadata.json from the parsed proofs.

One record per (sketch, goal, expansion). `expanded: true` records come from
`prooftrans expand -f` output (see *_expanded.pf), where every compound
para+rewrite justification is broken into explicit primitive paramodulation
steps; their proof_length is the actual step count of the expanded proof,
while source_length keeps the original .pf "Length of proof" figure.

    python data/aim_lc/build_metadata.py
"""

import json
from pathlib import Path

here = Path(__file__).resolve().parent

USES_HINTS = {"first_sketch": False, "second_sketch": True, "lc": True}
DEMOD_FREE = {"first_sketch": False, "second_sketch": True, "lc": False}
SIGNATURE = ["*", "\\", "/", "1", "a", "K", "L", "R", "T"]

records = []
for stem in ["first_sketch", "second_sketch", "lc"]:
    for expanded in [False, True]:
        parsed = here / "parsed" / f"{stem}{'_expanded' if expanded else ''}.json"
        for proof in json.loads(parsed.read_text()):
            meta = proof["meta"]
            records.append({
                "corpus": "aim_lc",
                "problem": f"{stem}:{meta['goal']}",
                "prover": "prover9",
                "expanded": expanded,
                "proof_length": len(proof["steps"]),
                "equations": sum(1 for s in proof["steps"] if s["kind"] == "equation"),
                "source_length": meta["length"],
                "level": meta["level"],
                "seconds": meta["seconds"],
                "given_clauses": meta["given_clauses"],
                "uses_hints": USES_HINTS[stem],
                "demodulation_free": DEMOD_FREE[stem],
                "signature": SIGNATURE,
                "derived_symbols_present": True,
            })

(here / "metadata.json").write_text(json.dumps(records, indent=1))
plain = sum(1 for r in records if not r["expanded"])
print(f"{len(records)} records ({plain} plain + {len(records) - plain} expanded)")
