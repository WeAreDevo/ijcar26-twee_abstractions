%--------------------------------------------------------------------------
% File     : GRP445-1 : TPTP v9.2.1. Released v2.6.0.
% Domain   : Group Theory
% Problem  : Axiom for group theory, in division, part 1
% Version  : [McC93] (equality) axioms.
% English  :

% Refs     : [HN52]  Higman & Neumann (1952), Groups as Groupoids with One
%          : [McC93] McCune (1993), Single Axioms for Groups and Abelian Gr
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.09 v9.0.0, 0.14 v8.2.0, 0.04 v8.1.0, 0.10 v7.5.0, 0.04 v7.4.0, 0.09 v7.3.0, 0.05 v7.1.0, 0.00 v7.0.0, 0.11 v6.4.0, 0.05 v6.3.0, 0.12 v6.2.0, 0.14 v6.1.0, 0.06 v6.0.0, 0.19 v5.5.0, 0.16 v5.4.0, 0.00 v5.1.0, 0.07 v5.0.0, 0.00 v2.6.0
% Syntax   : Number of clauses     :    4 (   4 unt;   0 nHn;   1 RR)
%            Number of literals    :    4 (   4 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   2 con; 0-2 aty)
%            Number of variables   :    8 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : A UEQ part of GRP063-1
%--------------------------------------------------------------------------
cnf(single_axiom,axiom,
    divide(A,divide(divide(divide(divide(A,A),B),C),divide(divide(divide(A,A),A),C))) = B ).

cnf(multiply,axiom,
    multiply(A,B) = divide(A,divide(divide(C,C),B)) ).

cnf(inverse,axiom,
    inverse(A) = divide(divide(B,B),A) ).

cnf(prove_these_axioms_1,negated_conjecture,
    multiply(inverse(a1),a1) != multiply(inverse(b1),b1) ).

%--------------------------------------------------------------------------
