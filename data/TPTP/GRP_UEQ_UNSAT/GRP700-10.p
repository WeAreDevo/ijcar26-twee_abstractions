%------------------------------------------------------------------------------
% File     : GRP700-10 : TPTP v9.2.1. Released v8.1.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : Variety of power associative, WIP conjugacy closed loops - 2c
% Version  : Especial.
% English  :

% Refs     : [Phi06] Phillips (2006), A Short Basis for the Variety of WIP
%          : [PS08]  Phillips & Stanovsky (2008), Automated Theorem Proving
%          : [Sma21] Smallbone (2021), Email to Geoff Sutcliffe
% Source   : [Sma21]
% Names    : 

% Status   : Unsatisfiable
% Rating   : 0.09 v9.1.0, 0.18 v9.0.0, 0.14 v8.2.0, 0.17 v8.1.0
% Syntax   : Number of clauses     :    9 (   9 unt;   0 nHn;   1 RR)
%            Number of literals    :    9 (   9 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   2 con; 0-2 aty)
%            Number of variables   :   17 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : UEQ version, converted from GRP700+1.p
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
    mult(A,unit) = A ).

cnf(f06,axiom,
    mult(unit,A) = A ).

cnf(f07,axiom,
    mult(mult(mult(A,B),A),mult(A,C)) = mult(A,mult(mult(mult(B,A),A),C)) ).

cnf(f08,axiom,
    mult(mult(A,B),mult(B,mult(C,B))) = mult(mult(A,mult(B,mult(B,C))),B) ).

cnf(goal,negated_conjecture,
    tuple(mult(X1,x0),mult(x0,X1)) != tuple(unit,unit) ).

%------------------------------------------------------------------------------
