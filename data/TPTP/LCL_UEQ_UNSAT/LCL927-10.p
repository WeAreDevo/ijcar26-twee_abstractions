%------------------------------------------------------------------------------
% File     : LCL927-10 : TPTP v9.2.1. Released v7.3.0.
% Domain   : Puzzles
% Problem  : AxK and AxC in TW+ [AxL,AxTO] + (Resid)
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 1.00 v9.1.0, 0.95 v8.2.0, 0.96 v8.1.0, 0.90 v7.5.0, 0.96 v7.3.0
% Syntax   : Number of clauses     :    8 (   8 unt;   0 nHn;   1 RR)
%            Number of literals    :    8 (   8 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   3 con; 0-4 aty)
%            Number of variables   :   21 (   1 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from LCL927-1 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(ifeq_axiom,axiom,
    ifeq(A,A,B,C) = B ).

cnf(modus_ponens,axiom,
    ifeq(p(i(A,B)),true,ifeq(p(A),true,p(B),true),true) = true ).

cnf(resid1,axiom,
    ifeq(p(i(f(A,B),C)),true,p(i(A,i(B,C))),true) = true ).

cnf(resid2,axiom,
    ifeq(p(i(A,i(B,C))),true,p(i(f(A,B),C)),true) = true ).

cnf(axBp,axiom,
    p(i(i(A,B),i(i(B,C),i(A,C)))) = true ).

cnf(axL,axiom,
    p(i(i(i(X,Y),Y),i(i(Y,X),X))) = true ).

cnf(axTO,axiom,
    p(i(i(i(X,Y),i(Y,X)),i(Y,X))) = true ).

cnf(axK_axC,negated_conjecture,
    tuple(p(i(i(A,i(B,C)),i(B,i(A,C)))),p(i(c1,i(c2,c1)))) != tuple(true,true) ).

%------------------------------------------------------------------------------
