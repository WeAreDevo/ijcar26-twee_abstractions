%--------------------------------------------------------------------------
% File     : GRP536-1 : TPTP v9.2.1. Bugfixed v2.7.0.
% Domain   : Group Theory (Abelian)
% Problem  : Axiom for Abelian group theory, in division, part 4
% Version  : [McC93] (equality) axioms.
% English  :

% Refs     : [McC93] McCune (1993), Single Axioms for Groups and Abelian Gr
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.00 v9.1.0, 0.05 v8.2.0, 0.04 v8.1.0, 0.05 v7.5.0, 0.04 v7.4.0, 0.13 v7.3.0, 0.05 v7.1.0, 0.00 v6.0.0, 0.10 v5.5.0, 0.05 v5.4.0, 0.00 v5.1.0, 0.07 v5.0.0, 0.00 v2.7.0
% Syntax   : Number of clauses     :    5 (   5 unt;   0 nHn;   1 RR)
%            Number of literals    :    5 (   5 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   3 con; 0-2 aty)
%            Number of variables   :    9 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : A UEQ part of GRP091-1
% Bugfixes : v2.7.0 - Grounded conjecture
%--------------------------------------------------------------------------
cnf(single_axiom,axiom,
    divide(divide(A,divide(divide(A,B),C)),B) = C ).

cnf(multiply,axiom,
    multiply(A,B) = divide(A,divide(divide(C,C),B)) ).

cnf(inverse,axiom,
    inverse(A) = divide(divide(B,B),A) ).

cnf(identity,axiom,
    identity = divide(A,A) ).

cnf(prove_these_axioms_4,negated_conjecture,
    multiply(a,b) != multiply(b,a) ).

%--------------------------------------------------------------------------
