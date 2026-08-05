%--------------------------------------------------------------------------
% File     : GRP468-1 : TPTP v9.2.1. Released v2.6.0.
% Domain   : Group Theory
% Problem  : Axiom for group theory, in division and inverse, part 3
% Version  : [McC93] (equality) axioms.
% English  :

% Refs     : [McC93] McCune (1993), Single Axioms for Groups and Abelian Gr
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.09 v9.1.0, 0.14 v8.2.0, 0.21 v8.1.0, 0.25 v7.5.0, 0.21 v7.4.0, 0.30 v7.3.0, 0.21 v7.1.0, 0.11 v7.0.0, 0.16 v6.4.0, 0.21 v6.3.0, 0.12 v6.2.0, 0.07 v6.1.0, 0.25 v6.0.0, 0.38 v5.5.0, 0.37 v5.4.0, 0.20 v5.3.0, 0.17 v5.2.0, 0.21 v5.1.0, 0.20 v5.0.0, 0.07 v4.1.0, 0.00 v3.4.0, 0.12 v3.3.0, 0.07 v3.2.0, 0.00 v2.6.0
% Syntax   : Number of clauses     :    3 (   3 unt;   0 nHn;   1 RR)
%            Number of literals    :    3 (   3 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   3 con; 0-2 aty)
%            Number of variables   :    6 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : A UEQ part of GRP070-1
%--------------------------------------------------------------------------
cnf(single_axiom,axiom,
    divide(divide(A,A),divide(B,divide(divide(C,divide(D,B)),inverse(D)))) = C ).

cnf(multiply,axiom,
    multiply(A,B) = divide(A,inverse(B)) ).

cnf(prove_these_axioms_3,negated_conjecture,
    multiply(multiply(a3,b3),c3) != multiply(a3,multiply(b3,c3)) ).

%--------------------------------------------------------------------------
