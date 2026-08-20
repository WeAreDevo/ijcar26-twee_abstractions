"""Re-run phase 3's equational tier with a real budget.

The first pass capped twee checking at 60s per engine-corpus and exhausted it
on 22/36 runs, so its "no equational match" was partial. This recheck redoes
tier 3 from the stored abstraction lists with a 240s budget and a per-problem
memo (stitch and babble share candidate bodies), updating the per-corpus
JSONs and the summary in place.

    python src/corpus/recheck_phase3_equational.py
"""

import json
import sys
from pathlib import Path

project_root = Path(__file__).resolve().parents[2]
sys.path.append(project_root.as_posix())

import src.corpus.equiv as equiv
from src.corpus.equiv import axioms_from_tptp
from src.corpus.run_phase3 import OUT, match_all_tiers, summary_row

_uncached = equiv.provably_equal
_memo = {}


def _cached(body, target, axioms, timeout=3, deadline=None):
    key = (body, target, id(axioms))
    if key in _memo:
        return _memo[key]
    result = _uncached(body, target, axioms, timeout=timeout, deadline=deadline)
    if result is not None or deadline is None:
        _memo[key] = result  # only cache definitive answers, not budget aborts
    return result


equiv.provably_equal = _cached

if __name__ == "__main__":
    import src.corpus.run_phase3 as p3
    for path in sorted(OUT.glob("thm*.json")):
        result = json.loads(path.read_text())
        axioms = axioms_from_tptp(
            project_root / "data" / "bol_moufang" / "tptp" / f"{result['problem']}.p")
        changed = False
        for label, engine in result["engines"].items():
            if engine["status"] != "ok" or not engine.get("equational_budget_exhausted"):
                continue
            recovered, exhausted = p3.match_all_tiers(
                engine["top_abstractions"], axioms, equational_budget=240)
            engine["recovered"] = recovered
            engine["equational_budget_exhausted"] = exhausted
            changed = True
        if changed:
            path.write_text(json.dumps(result, indent=1))
        print(summary_row(result), flush=True)

    all_results = [json.loads(p.read_text())
                   for p in sorted(OUT.glob("*.json")) if p.name != "results.json"]
    (OUT / "results.json").write_text(json.dumps(all_results, indent=1))
    lines = ["| problem | prover | terms | stitch recovered | babble recovered |",
             "|---|---|---:|---|---|"] + [summary_row(r) for r in all_results]
    (OUT / "summary.md").write_text(
        "# Phase 3: primitive Bol-Moufang concept recovery\n\n"
        "`sym@rank` = alpha-equivalent whole-body match; `*` = as subterm; "
        "`~` = provably equal under the problem's axioms (twee-checked, "
        "modulo argument permutation).\n\n" + "\n".join(lines) + "\n")
    print("\nsummary rebuilt")
