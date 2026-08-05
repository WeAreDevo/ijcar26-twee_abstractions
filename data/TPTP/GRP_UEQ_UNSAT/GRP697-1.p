%------------------------------------------------------------------------------
% File     : GRP697-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : Variety of power associative, WIP conjugacy closed loops - 1b
% Version  : Especial.
% English  :

% Refs     : [Phi06] Phillips (2006), A Short Basis for the Variety of WIP
%          : [PS08]  Phillips & Stanovsky (2008), Automated Theorem Proving
%          : [Sta08] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08]
% Names    : Phi06 [PS08]

% Status   : Unsatisfiable
% Rating   : 0.35 v9.1.0, 0.41 v8.2.0, 0.38 v8.1.0, 0.55 v7.5.0, 0.58 v7.4.0, 0.52 v7.3.0, 0.58 v7.2.0, 0.53 v7.1.0, 0.50 v7.0.0, 0.47 v6.4.0, 0.53 v6.3.0, 0.47 v6.2.0, 0.43 v6.1.0, 0.50 v6.0.0, 0.62 v5.5.0, 0.63 v5.4.0, 0.47 v5.3.0, 0.50 v5.2.0, 0.57 v5.1.0, 0.60 v5.0.0, 0.57 v4.1.0, 0.45 v4.0.1, 0.79 v4.0.0
% Syntax   : Number of clauses     :   12 (  12 unt;   0 nHn;   1 RR)
%            Number of literals    :   12 (  12 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   4 con; 0-2 aty)
%            Number of variables   :   20 (   0 sgn)
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
    mult(A,i(mult(B,A))) = i(B) ).

cnf(c08,axiom,
    mult(A,mult(B,C)) = mult(rd(mult(A,B),A),mult(A,C)) ).

cnf(c09,axiom,
    mult(mult(A,B),C) = mult(mult(A,C),ld(C,mult(B,C))) ).

cnf(c10,axiom,
    mult(i(A),A) = unit ).

cnf(c11,axiom,
    mult(A,i(A)) = unit ).

cnf(goals,negated_conjecture,
    mult(mult(a,b),mult(b,mult(c,b))) != mult(mult(a,mult(b,mult(b,c))),b) ).

%------------------------------------------------------------------------------
