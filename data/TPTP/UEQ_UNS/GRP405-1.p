%--------------------------------------------------------------------------
% File     : GRP405-1 : TPTP v9.2.1. Released v2.6.0.
% Domain   : Group Theory
% Problem  : Axiom for group theory, in product & inverse, part 3
% Version  : [McC93] (equality) axioms.
% English  :

% Refs     : [Kun92] Kunen (1992), Single Axioms for Groups
%          : [McC93] McCune (1993), Single Axioms for Groups and Abelian Gr
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.22 v9.1.0, 0.23 v8.2.0, 0.29 v8.1.0, 0.45 v7.5.0, 0.50 v7.4.0, 0.61 v7.3.0, 0.58 v7.1.0, 0.50 v7.0.0, 0.42 v6.4.0, 0.47 v6.3.0, 0.53 v6.2.0, 0.43 v6.1.0, 0.56 v6.0.0, 0.67 v5.5.0, 0.63 v5.4.0, 0.53 v5.3.0, 0.50 v5.1.0, 0.47 v5.0.0, 0.43 v4.1.0, 0.36 v4.0.0, 0.31 v3.7.0, 0.22 v3.4.0, 0.25 v3.3.0, 0.29 v3.2.0, 0.21 v3.1.0, 0.33 v2.7.0, 0.27 v2.6.0
% Syntax   : Number of clauses     :    2 (   2 unt;   0 nHn;   1 RR)
%            Number of literals    :    2 (   2 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    8 (   3 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   3 con; 0-2 aty)
%            Number of variables   :    3 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : A UEQ part of GRP049-1
%--------------------------------------------------------------------------
cnf(single_axiom,axiom,
    multiply(A,inverse(multiply(inverse(multiply(inverse(multiply(A,B)),C)),inverse(multiply(B,multiply(inverse(B),B)))))) = C ).

cnf(prove_these_axioms_3,negated_conjecture,
    multiply(multiply(a3,b3),c3) != multiply(a3,multiply(b3,c3)) ).

%--------------------------------------------------------------------------
