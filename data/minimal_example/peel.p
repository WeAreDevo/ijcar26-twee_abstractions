cnf(ax1, axiom, op(unit,X) = X).
cnf(ax2, axiom, op(X,unit) = X).
cnf(ax3, axiom, ldiv(X,op(X,Y)) = Y).
cnf(ax4, axiom, op(X,ldiv(X,Y)) = Y).
cnf(ax5, axiom, rdiv(op(X,Y),Y) = X).
cnf(ax6, axiom, op(rdiv(X,Y),Y) = X).
fof(goal, conjecture, op(unit, op(unit, op(unit, op(unit, op(unit, ldiv(op(a,b), op(b,a))))))) = ldiv(op(a,b), op(b,a))).
