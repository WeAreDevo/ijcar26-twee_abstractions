%--------------------------------------------------------------------------
% File     : GRP444-1 : TPTP v9.2.1. Released v2.6.0.
% Domain   : Group Theory
% Problem  : Axiom for group theory, in product & inverse, part 3
% Version  : [McC93] (equality) axioms.
% English  :

% Refs     : [McC93] McCune (1993), Single Axioms for Groups and Abelian Gr
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.17 v9.1.0, 0.23 v8.2.0, 0.29 v8.1.0, 0.30 v7.5.0, 0.38 v7.4.0, 0.48 v7.3.0, 0.37 v7.1.0, 0.28 v7.0.0, 0.21 v6.4.0, 0.26 v6.3.0, 0.24 v6.2.0, 0.29 v6.1.0, 0.44 v6.0.0, 0.57 v5.5.0, 0.53 v5.4.0, 0.40 v5.3.0, 0.33 v5.2.0, 0.36 v5.1.0, 0.33 v5.0.0, 0.29 v4.1.0, 0.27 v4.0.1, 0.21 v4.0.0, 0.15 v3.7.0, 0.22 v3.4.0, 0.25 v3.3.0, 0.21 v3.1.0, 0.22 v2.7.0, 0.27 v2.6.0
% Syntax   : Number of clauses     :    2 (   2 unt;   0 nHn;   1 RR)
%            Number of literals    :    2 (   2 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    8 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   3 con; 0-2 aty)
%            Number of variables   :    4 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : A UEQ part of GRP062-1
%--------------------------------------------------------------------------
cnf(single_axiom,axiom,
    inverse(multiply(A,multiply(B,multiply(multiply(C,inverse(C)),inverse(multiply(D,multiply(A,B))))))) = D ).

cnf(prove_these_axioms_3,negated_conjecture,
    multiply(multiply(a3,b3),c3) != multiply(a3,multiply(b3,c3)) ).

%--------------------------------------------------------------------------
