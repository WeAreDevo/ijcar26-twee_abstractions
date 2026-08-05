%------------------------------------------------------------------------------
% File     : GRP667-10 : TPTP v9.2.1. Released v7.5.0.
% Domain   : Puzzles
% Problem  : 2-divisible ARIF loops are Moufang
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.52 v9.1.0, 0.55 v8.2.0, 0.58 v8.1.0, 0.55 v7.5.0
% Syntax   : Number of clauses     :   14 (  14 unt;   0 nHn;   1 RR)
%            Number of literals    :   14 (  14 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    9 (   9 usr;   4 con; 0-4 aty)
%            Number of variables   :   28 (   1 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from GRP667+1 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(ifeq_axiom,axiom,
    ifeq(A,A,B,C) = B ).

cnf(f01,axiom,
    mult(A,ld(A,B)) = B ).

cnf(f02,axiom,
    ld(A,mult(A,B)) = B ).

cnf(f03,axiom,
    mult(rd(A,B),B) = A ).

cnf(f04,axiom,
    rd(mult(A,B),B) = A ).

cnf(f05,axiom,
    mult(A,unit) = A ).

cnf(f06,axiom,
    mult(unit,A) = A ).

cnf(f07,axiom,
    mult(mult(A,B),mult(mult(C,B),C)) = mult(mult(A,mult(mult(B,C),B)),C) ).

cnf(f08,axiom,
    mult(mult(A,B),A) = mult(A,mult(B,A)) ).

cnf(f09,axiom,
    mult(f(A),f(A)) = A ).

cnf(f10,axiom,
    ifeq(mult(X0,mult(X1,mult(X2,X1))),mult(mult(mult(X0,X1),X2),X1),mult(X1,mult(X0,mult(X1,X2))),mult(mult(mult(X1,X0),X1),X2)) = mult(mult(mult(X1,X0),X1),X2) ).

cnf(f11,axiom,
    ifeq(mult(mult(X3,X4),mult(X5,X3)),mult(mult(X3,mult(X4,X5)),X3),mult(X3,mult(X4,mult(X3,X5))),mult(mult(mult(X3,X4),X3),X5)) = mult(mult(mult(X3,X4),X3),X5) ).

cnf(f12,axiom,
    ifeq(mult(mult(X6,X7),mult(X8,X6)),mult(X6,mult(mult(X7,X8),X6)),mult(X6,mult(X7,mult(X6,X8))),mult(mult(mult(X6,X7),X6),X8)) = mult(mult(mult(X6,X7),X6),X8) ).

cnf(goals,negated_conjecture,
    mult(a,mult(b,mult(a,c))) != mult(mult(mult(a,b),a),c) ).

%------------------------------------------------------------------------------
