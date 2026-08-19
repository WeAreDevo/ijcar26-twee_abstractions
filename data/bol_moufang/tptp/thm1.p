% Let Q be a quasigroup satisfying D14. Then it satisfies F14.
% Reconstructed from the Otter proof's input clauses.
cnf(ax1, axiom, op(X,ldiv(X,Y)) = Y).
cnf(ax2, axiom, ldiv(X,op(X,Y)) = Y).
cnf(ax3, axiom, rdiv(op(X,Y),Y) = X).
cnf(ax4, axiom, op(rdiv(X,Y),Y) = X).
cnf(ax5, axiom, op(X,op(Y,op(Z,X))) = op(op(X,op(Y,Z)),X)).
cnf(goal, negated_conjecture, op(sk_a,op(sk_b,op(sk_c,sk_c))) != op(op(sk_a,op(sk_b,sk_c)),sk_c)).
