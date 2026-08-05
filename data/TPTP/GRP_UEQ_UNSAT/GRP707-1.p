%------------------------------------------------------------------------------
% File     : GRP707-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : A C-loop of exponent four with central squares is flexible
% Version  : Especial.
% English  :

% Refs     : [KPV07] Kinyon et al. (2007), C-loops: Extensions and Construc
%          : [PS08]  Phillips & Stanovsky (2008), Automated Theorem Proving
%          : [Sta08] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08]
% Names    : KPV07 [PS08]

% Status   : Unsatisfiable
% Rating   : 0.04 v9.1.0, 0.14 v9.0.0, 0.09 v8.2.0, 0.17 v8.1.0, 0.20 v7.5.0, 0.25 v7.4.0, 0.30 v7.3.0, 0.21 v7.1.0, 0.11 v7.0.0, 0.16 v6.4.0, 0.26 v6.3.0, 0.29 v6.1.0, 0.19 v6.0.0, 0.38 v5.5.0, 0.37 v5.4.0, 0.20 v5.3.0, 0.17 v5.2.0, 0.21 v5.1.0, 0.27 v5.0.0, 0.21 v4.1.0, 0.18 v4.0.1, 0.57 v4.0.0
% Syntax   : Number of clauses     :   10 (  10 unt;   0 nHn;   1 RR)
%            Number of literals    :   10 (  10 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   3 con; 0-2 aty)
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
    mult(A,mult(B,mult(B,C))) = mult(mult(mult(A,B),B),C) ).

cnf(c08,axiom,
    mult(A,mult(A,mult(A,A))) = unit ).

cnf(c09,axiom,
    mult(mult(A,A),B) = mult(B,mult(A,A)) ).

cnf(goals,negated_conjecture,
    mult(mult(a,b),a) != mult(a,mult(b,a)) ).

%------------------------------------------------------------------------------
