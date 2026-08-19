% Every LG2 quasigroup is a right loop.
% Reconstructed from the Otter proof's input clauses.
cnf(ax1, axiom, op(X,ldiv(X,Y)) = Y).
cnf(ax2, axiom, ldiv(X,op(X,Y)) = Y).
cnf(ax3, axiom, rdiv(op(X,Y),Y) = X).
cnf(ax4, axiom, op(rdiv(X,Y),Y) = X).
cnf(ax5, axiom, op(op(X,Y),op(Z,Z)) = op(op(X,op(Y,Z)),Z)).
cnf(goal, negated_conjecture, ldiv(sk_a,sk_a) != ldiv(sk_b,sk_b)).
