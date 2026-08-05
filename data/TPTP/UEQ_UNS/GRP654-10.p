%------------------------------------------------------------------------------
% File     : GRP654-10 : TPTP v9.2.1. Released v8.1.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : A quasigroup satisfying Moufang 1 is a loop
% Version  : Especial.
% English  :

% Refs     : [Kun96] Kunen (1996), Moufang Quasigroups
%          : [PS08]  Phillips & Stanovsky (2008), Automated Theorem Proving
%          : [Sma21] Smallbone (2021), Email to Geoff Sutcliffe
% Source   : [Sma21]
% Names    : 

% Status   : Unsatisfiable
% Rating   : 0.78 v9.1.0, 0.77 v8.2.0, 0.75 v8.1.0
% Syntax   : Number of clauses     :    6 (   6 unt;   0 nHn;   1 RR)
%            Number of literals    :    6 (   6 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   0 con; 1-2 aty)
%            Number of variables   :   12 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : UEQ version, converted from GRP654+1.p
%------------------------------------------------------------------------------
cnf(f01,axiom,
    mult(A,ld(A,B)) = B ).

cnf(f02,axiom,
    ld(A,mult(A,B)) = B ).

cnf(f03,axiom,
    mult(rd(A,B),B) = A ).

cnf(f04,axiom,
    rd(mult(A,B),B) = A ).

cnf(f05,axiom,
    mult(A,mult(B,mult(A,C))) = mult(mult(mult(A,B),A),C) ).

cnf(goal,negated_conjecture,
    tuple(mult(X0,x1(X0)),mult(x1_2(X0),X0)) != tuple(x1(X0),x1_2(X0)) ).

%------------------------------------------------------------------------------
