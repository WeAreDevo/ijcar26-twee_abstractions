"""
Smoke test for the Stitch compression backend. Counterpart of `run_babble.py`,
on the same proof fragment.

    python run_stitch.py
"""

import os
import sys
from pathlib import Path

project_root = Path(__file__).resolve().parents[0]
sys.path.append(project_root.as_posix())
os.chdir(project_root.as_posix())

from src.stitch.Abstractions import Stitch_Abstractions
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

    compression = Stitch_Abstractions(terms, 1, 3)

    print(f"\n{len(compression.fo_abstractions)} abstractions:")
    for abstraction in compression.fo_abstractions:
        print(f"  {abstraction}")