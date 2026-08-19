
% The LADR formulas contain function or predicate symbols
% that are not legal TPTP symbols, and we have replaced those
% symbols with new symbols.  Here is the list of the unaccepted
% symbols and the corresponding replacements.
%
%   (arity 0)        1    unit
%   (arity 2)        K    'K'
%   (arity 2)        *    op
%   (arity 3)        R    'R'
%   (arity 3)        L    'L'
%   (arity 2)        T    'T'
%   (arity 2)        \    ldiv
%   (arity 2)        /    rdiv

cnf(sos,axiom,op(unit,A) = A).
cnf(sos,axiom,op(A,unit) = A).
cnf(sos,axiom,ldiv(A,op(A,B)) = B).
cnf(sos,axiom,op(A,ldiv(A,B)) = B).
cnf(sos,axiom,rdiv(op(A,B),B) = A).
cnf(sos,axiom,op(rdiv(A,B),B) = A).
cnf(sos,axiom,ldiv(op(A,op(B,C)),op(op(A,B),C)) = a(A,B,C)).
cnf(sos,axiom,ldiv(op(A,B),op(B,A)) ='K'(B,A)).
cnf(sos,axiom,ldiv(op(A,B),op(A,op(B,C))) ='L'(C,B,A)).
cnf(sos,axiom,rdiv(op(op(A,B),C),op(B,C)) ='R'(A,B,C)).
cnf(sos,axiom,ldiv(A,op(B,A)) ='T'(B,A)).
fof(sos,axiom,! [X0] : ! [X1] : ! [X2] : (a(X0,X1,X2) =unit =>'L'(X2,X1,X0) = X2)).
fof(sos,axiom,! [X3] : ! [X4] : ! [X5] : ('L'(X3,X4,X5) = X3 => a(X5,X4,X3) =unit)).
fof(sos,axiom,! [X6] : ! [X7] : ('T'(X6,X7) = X6 =>'T'(X7,X6) = X7)).
fof(sos,axiom,! [X8] : ! [X9] : ('T'(X8,X9) = X8 =>'K'(X8,X9) =unit)).
fof(sos,axiom,! [X10] : ! [X11] : ('K'(X10,X11) =unit =>'T'(X10,X11) = X10)).
cnf(sos,axiom,'T'('T'(A,B),C) ='T'('T'(A,C),B)).
cnf(sos,axiom,'T'('L'(A,B,C),D) ='L'('T'(A,D),B,C)).
cnf(sos,axiom,'T'('R'(A,B,C),D) ='R'('T'(A,D),B,C)).
cnf(sos,axiom,'L'('R'(A,B,C),D,E) ='R'('L'(A,D,E),B,C)).
cnf(sos,axiom,'L'('L'(A,B,C),D,E) ='L'('L'(A,D,E),B,C)).
cnf(sos,axiom,'R'('R'(A,B,C),D,E) ='R'('R'(A,D,E),B,C)).
cnf(sos,axiom,op(op(op(A,B),A),C) = op(A,op(B,op(A,C)))).
cnf(sos,axiom,op(op(A,op(A,B)),C) = op(A,op(A,op(B,C)))).
fof(goals,conjecture,! [X16] : ! [X17] : ! [X18] : ! [X19] : a(X16,'K'(X17,X18),X19) =unit).
