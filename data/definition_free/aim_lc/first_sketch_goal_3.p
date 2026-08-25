cnf(sos,axiom,op(unit,A) = A).
cnf(sos,axiom,op(A,unit) = A).
cnf(sos,axiom,ldiv(A,op(A,B)) = B).
cnf(sos,axiom,op(A,ldiv(A,B)) = B).
cnf(sos,axiom,rdiv(op(A,B),B) = A).
cnf(sos,axiom,op(rdiv(A,B),B) = A).
fof(sos,axiom,! [X0] : ! [X1] : ! [X2] : (ldiv(op(X0, op(X1, X2)), op(op(X0, X1), X2)) =unit =>ldiv(op(X0, X1), op(X0, op(X1, X2))) = X2)).
fof(sos,axiom,! [X3] : ! [X4] : ! [X5] : (ldiv(op(X5, X4), op(X5, op(X4, X3))) = X3 => ldiv(op(X5, op(X4, X3)), op(op(X5, X4), X3)) =unit)).
fof(sos,axiom,! [X6] : ! [X7] : (ldiv(X7, op(X6, X7)) = X6 =>ldiv(X6, op(X7, X6)) = X7)).
fof(sos,axiom,! [X8] : ! [X9] : (ldiv(X9, op(X8, X9)) = X8 =>ldiv(op(X9, X8), op(X8, X9)) =unit)).
fof(sos,axiom,! [X10] : ! [X11] : (ldiv(op(X11, X10), op(X10, X11)) =unit =>ldiv(X11, op(X10, X11)) = X10)).
cnf(sos,axiom,ldiv(C, op(ldiv(B, op(A, B)), C)) =ldiv(B, op(ldiv(C, op(A, C)), B))).
cnf(sos,axiom,ldiv(D, op(ldiv(op(C, B), op(C, op(B, A))), D)) =ldiv(op(C, B), op(C, op(B, ldiv(D, op(A, D)))))).
cnf(sos,axiom,ldiv(D, op(rdiv(op(op(A, B), C), op(B, C)), D)) =rdiv(op(op(ldiv(D, op(A, D)), B), C), op(B, C))).
cnf(sos,axiom,ldiv(op(E, D), op(E, op(D, rdiv(op(op(A, B), C), op(B, C))))) =rdiv(op(op(ldiv(op(E, D), op(E, op(D, A))), B), C), op(B, C))).
cnf(sos,axiom,ldiv(op(E, D), op(E, op(D, ldiv(op(C, B), op(C, op(B, A)))))) =ldiv(op(C, B), op(C, op(B, ldiv(op(E, D), op(E, op(D, A))))))).
cnf(sos,axiom,rdiv(op(op(rdiv(op(op(A, B), C), op(B, C)), D), E), op(D, E)) =rdiv(op(op(rdiv(op(op(A, D), E), op(D, E)), B), C), op(B, C))).
cnf(sos,axiom,op(op(op(A,B),A),C) = op(A,op(B,op(A,C)))).
cnf(sos,axiom,op(op(A,op(A,B)),C) = op(A,op(A,op(B,C)))).
fof(goals,conjecture,! [X20] : ! [X21] : ! [X22] : ! [X23] : ldiv(op(X20, op(X21, ldiv(op(X23, X22), op(X22, X23)))), op(op(X20, X21), ldiv(op(X23, X22), op(X22, X23)))) =unit).
