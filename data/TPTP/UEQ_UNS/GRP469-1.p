%--------------------------------------------------------------------------
% File     : GRP469-1 : TPTP v9.2.1. Released v2.6.0.
% Domain   : Group Theory
% Problem  : Axiom for group theory, in division and inverse, part 1
% Version  : [McC93] (equality) axioms.
% English  :

% Refs     : [McC93] McCune (1993), Single Axioms for Groups and Abelian Gr
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.26 v9.1.0, 0.32 v8.2.0, 0.33 v8.1.0, 0.30 v7.5.0, 0.38 v7.4.0, 0.43 v7.3.0, 0.37 v7.1.0, 0.28 v7.0.0, 0.32 v6.4.0, 0.37 v6.3.0, 0.35 v6.2.0, 0.43 v6.1.0, 0.56 v6.0.0, 0.57 v5.5.0, 0.63 v5.4.0, 0.53 v5.3.0, 0.50 v5.1.0, 0.47 v5.0.0, 0.43 v4.1.0, 0.36 v4.0.0, 0.31 v3.7.0, 0.22 v3.4.0, 0.25 v3.3.0, 0.29 v3.2.0, 0.21 v3.1.0, 0.11 v2.7.0, 0.18 v2.6.0
% Syntax   : Number of clauses     :    3 (   3 unt;   0 nHn;   1 RR)
%            Number of literals    :    3 (   3 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   2 con; 0-2 aty)
%            Number of variables   :    6 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : A UEQ part of GRP071-1
%--------------------------------------------------------------------------
cnf(single_axiom,axiom,
    divide(inverse(divide(A,divide(B,divide(C,D)))),divide(divide(D,C),A)) = B ).

cnf(multiply,axiom,
    multiply(A,B) = divide(A,inverse(B)) ).

cnf(prove_these_axioms_1,negated_conjecture,
    multiply(inverse(a1),a1) != multiply(inverse(b1),b1) ).

%--------------------------------------------------------------------------
