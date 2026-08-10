"""
Smoke test for the babble compression backend.

Runs library learning over the terms of a small hand-copied proof fragment and
prints the abstractions it finds. The counterpart of `run_stitch.py`, on the
same input, so the two engines can be compared directly.

Pass a TPTP problem file to also compress *modulo its axioms* -- babble's
library-learning-modulo-theory mode, which Stitch has no equivalent of:

    python run_babble.py
    python run_babble.py data/TPTP/LAT_UEQ_UNSAT/LAT005-10.p

The rules only bite when they mention symbols the terms actually use. In the
pipeline that is automatic, since the terms come from that problem's own
proof; here the proof fragment is hard-coded, so most problems will produce
rules that never fire, and the script says so.

Requires `BABBLE_ROOT` in `.env` and the `fof` binary built; see the README
section "Optional: the babble compression backend".
"""

import os
import sys
from pathlib import Path

project_root = Path(__file__).resolve().parents[0]
sys.path.append(project_root.as_posix())
os.chdir(project_root.as_posix())

from src.babble.Abstractions import Babble_Abstractions
from src.babble.theory import dsrs_for_problem, rules_apply_to
from src.utils import extract_terms

if __name__ == "__main__":
    proof_fragment = """
Proof:
  f(X, f(Y, f(f(Z, f(X, X)), f(Z, f(X, X))))) (peak)
= { by lemma 27 R->L }
  f(X, f(Y, f(f(Z, f(X, X)), f(f(X, X), Z)))) (peak)
= { by lemma 28 }
  f(X, f(Y, f(f(f(X, X), Z), f(f(X, X), Z))))
= { by lemma 10 R->L }
  f(f(f(X, X), f(X, X)), f(Y, f(f(f(X, X), Z), f(f(X, X), Z)))) (peak)
"""

    # Same extraction settings as the local_abs stage (src/stitch/configs/local_abs.yaml).
    # Passing a config matters: `extract_terms(text)` with no config returns early
    # and leaves the "(peak)" markers on the terms.
    terms = extract_terms(proof_fragment, {"onlyProofTerms": True, "onlyPeakTerms": False})
    print(f"{len(terms)} terms extracted:")
    for term in terms:
        print(f"  {term}")

    rules = None
    if len(sys.argv) > 1:
        rules = dsrs_for_problem(sys.argv[1])
        print(f"\n{len(rules)} rewrite rules from the axioms of {sys.argv[1]}:")
        for rule in rules:
            print(f"  {rule}")

        if not rules_apply_to(rules, terms):
            print("\n  NOTE: no rule mentions a symbol these terms use, so the"
                  "\n  theory cannot fire. Expect the same result as without it.")

    compression = Babble_Abstractions(terms, iterations=1, max_arity=3, dsrs=rules)

    print(f"\ncost {compression.initial_cost} -> {compression.final_cost} "
          f"(compression ratio {compression.compression_ratio:.4f})")

    print(f"\n{len(compression.fo_abstractions)} abstractions:")
    for abstraction in compression.fo_abstractions:
        print(f"  {abstraction}")

    if compression.skipped:
        print(f"\n{len(compression.skipped)} skipped as not first-order:")
        for name, reason in compression.skipped:
            print(f"  {name}: {reason}")
