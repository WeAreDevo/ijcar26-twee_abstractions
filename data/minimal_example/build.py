"""A minimal example isolating why twee and Prover9 proofs yield different
construction counts.

The hypothesis under test: the gap is a *proof-presentation* effect, not a
difference in the inferences performed. twee prints an equational chain — the
whole term at every rewrite step — so any subterm that survives the rewriting
is re-counted once per step. Prover9 prints one equation per inference, and
demodulation keeps terms normalised, so a persistent subterm is stated once.

The problem below makes that explicit. `K` is the commutator body
`ldiv(op(a,b), op(b,a))`; the goal wraps it in a stack of identity
multiplications that must be peeled one at a time. `K` itself is never
rewritten — it just sits there while the context around it is simplified.

    python data/minimal_example/build.py
"""

from pathlib import Path

here = Path(__file__).resolve().parent
K = "ldiv(op(a,b), op(b,a))"
DEPTH = 5

# goal: op(unit, op(unit, ... op(unit, K))) = K
lhs = K
for _ in range(DEPTH):
    lhs = f"op(unit, {lhs})"

TPTP = f"""cnf(ax1, axiom, op(unit,X) = X).
cnf(ax2, axiom, op(X,unit) = X).
cnf(ax3, axiom, ldiv(X,op(X,Y)) = Y).
cnf(ax4, axiom, op(X,ldiv(X,Y)) = Y).
cnf(ax5, axiom, rdiv(op(X,Y),Y) = X).
cnf(ax6, axiom, op(rdiv(X,Y),Y) = X).
fof(goal, conjecture, {lhs} = {K}).
"""

P9_K = K.replace("op(", "mult(").replace("ldiv(", "ld(")
p9_lhs = P9_K
for _ in range(DEPTH):
    p9_lhs = f"mult(e, {p9_lhs})"

PROVER9 = f"""formulas(assumptions).
   mult(e,v0) = v0.
   mult(v0,e) = v0.
   ld(v0,mult(v0,v1)) = v1.
   mult(v0,ld(v0,v1)) = v1.
   rd(mult(v0,v1),v1) = v0.
   mult(rd(v0,v1),v1) = v0.
end_of_list.

formulas(goals).
   {p9_lhs} = {P9_K}.
end_of_list.
"""

if __name__ == "__main__":
    (here / "peel.p").write_text(TPTP)
    (here / "peel.in").write_text(PROVER9)
    print(f"goal (TPTP):    {lhs} = {K}")
    print(f"goal (Prover9): {p9_lhs} = {P9_K}")
    print("the commutator body K is never rewritten; only its context is")
