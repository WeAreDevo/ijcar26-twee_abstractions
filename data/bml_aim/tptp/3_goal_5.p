
% The LADR formulas contain function or predicate symbols
% that are not legal TPTP symbols, and we have replaced those
% symbols with new symbols.  Here is the list of the unaccepted
% symbols and the corresponding replacements.
%
%   (arity 3)        R    'R'
%   (arity 3)        L    'L'
%   (arity 2)        T    'T'
%   (arity 0)        1    '1'
%   (arity 2)        K    'K'
%   (arity 2)        *    op
%   (arity 2)        \    ldiv
%   (arity 2)        /    rdiv
%   (arity 0)        0    zero

cnf(sos,axiom,op(zero,A) = A).
cnf(sos,axiom,op(A,zero) = A).
cnf(sos,axiom,op(A,ldiv(A,B)) = B).
cnf(sos,axiom,ldiv(A,op(A,B)) = B).
cnf(sos,axiom,rdiv(op(A,B),B) = A).
cnf(sos,axiom,op(rdiv(A,B),B) = A).
cnf(sos,axiom,op(op(A,B),C) = op(op(A,op(B,C)),a(A,B,C))).
cnf(sos,axiom,op(A,B) = op(op(B,A),'K'(A,B))).
cnf(sos,axiom,'R'(A,B,C) = rdiv(op(op(A,B),C),op(B,C))).
cnf(sos,axiom,'L'(A,B,C) = ldiv(op(C,B),op(C,op(B,A)))).
cnf(sos,axiom,'T'(A,B) = ldiv(B,op(A,B))).
cnf(sos,axiom,'K'('K'(A,B),C) ='1').
cnf(sos,axiom,'K'(A,'K'(B,C)) ='1').
cnf(sos,axiom,'K'(a(A,B,C),D) ='1').
cnf(sos,axiom,'K'(A,a(B,C,D)) ='1').
cnf(sos,axiom,a('K'(A,B),C,D) ='1').
cnf(sos,axiom,a(A,'K'(B,C),D) ='1').
cnf(sos,axiom,a(A,B,'K'(C,D)) ='1').
cnf(sos,axiom,a(a(A,B,C),D,E) ='1').
cnf(sos,axiom,a(A,a(B,C,D),E) ='1').
cnf(sos,axiom,a(A,B,a(C,D,E)) ='1').
fof(goals,conjecture,! [X16] : ! [X17] : ! [X18] : ! [X19] : ! [X20] :'L'('L'(X16,X17,X18),X19,X20) ='L'('L'(X16,X19,X20),X17,X18)).
