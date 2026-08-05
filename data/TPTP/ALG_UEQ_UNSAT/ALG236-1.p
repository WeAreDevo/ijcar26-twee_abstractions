%------------------------------------------------------------------------------
% File     : ALG236-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Algebra (Non-associative)
% Problem  : Short equational base for two varieties of groupoids - part 1b
% Version  : Especial.
% English  :

% Refs     : [Phi06] Phillips (2006), Short Equational Bases for Two Variet
%          : [PS08]  Phillips & Stanovsky (2008), Using Automated Theorem P
%          : [Sta08] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08]
% Names    : P06_1b [Sta08]

% Status   : Unsatisfiable
% Rating   : 0.04 v9.1.0, 0.09 v9.0.0, 0.05 v8.2.0, 0.21 v8.1.0, 0.15 v7.5.0, 0.12 v7.4.0, 0.30 v7.3.0, 0.16 v7.1.0, 0.06 v7.0.0, 0.11 v6.4.0, 0.16 v6.3.0, 0.18 v6.2.0, 0.21 v6.1.0, 0.19 v6.0.0, 0.33 v5.5.0, 0.37 v5.4.0, 0.20 v5.3.0, 0.08 v5.2.0, 0.14 v5.1.0, 0.20 v5.0.0, 0.21 v4.1.0, 0.18 v4.0.1, 0.36 v4.0.0
% Syntax   : Number of clauses     :    4 (   4 unt;   0 nHn;   1 RR)
%            Number of literals    :    4 (   4 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   5 con; 0-2 aty)
%            Number of variables   :   10 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%------------------------------------------------------------------------------
cnf(c01,axiom,
    mult(A,mult(B,mult(A,B))) = mult(A,B) ).

cnf(c02,axiom,
    mult(A,mult(B,mult(C,D))) = mult(C,mult(B,mult(A,D))) ).

cnf(c03,axiom,
    mult(mult(A,mult(B,mult(C,B))),D) = mult(A,mult(D,mult(mult(C,B),D))) ).

cnf(goals,negated_conjecture,
    mult(mult(a,b),mult(c,mult(d,e))) != mult(a,mult(c,mult(mult(d,b),e))) ).

%------------------------------------------------------------------------------
