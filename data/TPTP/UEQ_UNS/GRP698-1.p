%------------------------------------------------------------------------------
% File     : GRP698-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : Variety of power associative, WIP conjugacy closed loops - 2a
% Version  : Especial.
% English  :

% Refs     : [Phi06] Phillips (2006), A Short Basis for the Variety of WIP
%          : [PS08]  Phillips & Stanovsky (2008), Automated Theorem Proving
%          : [Sta08] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08]
% Names    : Phi06 [PS08]

% Status   : Unsatisfiable
% Rating   : 0.13 v9.1.0, 0.23 v9.0.0, 0.18 v8.2.0, 0.25 v7.5.0, 0.29 v7.4.0, 0.39 v7.3.0, 0.32 v7.1.0, 0.22 v7.0.0, 0.21 v6.4.0, 0.37 v6.3.0, 0.35 v6.2.0, 0.29 v6.1.0, 0.31 v6.0.0, 0.48 v5.5.0, 0.42 v5.4.0, 0.27 v5.3.0, 0.25 v5.2.0, 0.29 v5.1.0, 0.33 v5.0.0, 0.36 v4.1.0, 0.27 v4.0.1, 0.57 v4.0.0
% Syntax   : Number of clauses     :    9 (   9 unt;   0 nHn;   1 RR)
%            Number of literals    :    9 (   9 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   4 con; 0-2 aty)
%            Number of variables   :   16 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%------------------------------------------------------------------------------
cnf(c01,axiom,
    mult(A,ld(A,B)) = B ).

cnf(c02,axiom,
    ld(A,mult(A,B)) = B ).

cnf(c03,axiom,
    mult(rd(A,B),B) = A ).

cnf(c04,axiom,
    rd(mult(A,B),B) = A ).

cnf(c05,axiom,
    mult(A,unit) = A ).

cnf(c06,axiom,
    mult(unit,A) = A ).

cnf(c07,axiom,
    mult(mult(mult(A,B),A),mult(A,C)) = mult(A,mult(mult(mult(B,A),A),C)) ).

cnf(c08,axiom,
    mult(mult(A,B),mult(B,mult(C,B))) = mult(mult(A,mult(B,mult(B,C))),B) ).

cnf(goals,negated_conjecture,
    mult(a,mult(b,c)) != mult(rd(mult(a,b),a),mult(a,c)) ).

%------------------------------------------------------------------------------
