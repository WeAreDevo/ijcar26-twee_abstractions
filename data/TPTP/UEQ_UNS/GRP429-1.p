%--------------------------------------------------------------------------
% File     : GRP429-1 : TPTP v9.2.1. Released v2.6.0.
% Domain   : Group Theory
% Problem  : Axiom for group theory, in product & inverse, part 3
% Version  : [McC93] (equality) axioms.
% English  :

% Refs     : [Neu81] Neumann (1981), Another Single Law for Groups
%          : [McC93] McCune (1993), Single Axioms for Groups and Abelian Gr
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.09 v9.1.0, 0.14 v8.2.0, 0.21 v8.1.0, 0.25 v7.4.0, 0.35 v7.3.0, 0.26 v7.1.0, 0.17 v7.0.0, 0.16 v6.4.0, 0.21 v6.3.0, 0.24 v6.2.0, 0.21 v6.1.0, 0.19 v6.0.0, 0.43 v5.5.0, 0.37 v5.4.0, 0.20 v5.3.0, 0.08 v5.2.0, 0.14 v5.1.0, 0.27 v5.0.0, 0.29 v4.1.0, 0.18 v4.0.1, 0.14 v4.0.0, 0.15 v3.7.0, 0.22 v3.4.0, 0.25 v3.3.0, 0.07 v3.2.0, 0.14 v3.1.0, 0.11 v2.7.0, 0.18 v2.6.0
% Syntax   : Number of clauses     :    2 (   2 unt;   0 nHn;   1 RR)
%            Number of literals    :    2 (   2 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    9 (   3 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   3 con; 0-2 aty)
%            Number of variables   :    4 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : A UEQ part of GRP057-1
%--------------------------------------------------------------------------
cnf(single_axiom,axiom,
    multiply(A,inverse(multiply(multiply(inverse(multiply(inverse(B),multiply(inverse(A),C))),D),inverse(multiply(B,D))))) = C ).

cnf(prove_these_axioms_3,negated_conjecture,
    multiply(multiply(a3,b3),c3) != multiply(a3,multiply(b3,c3)) ).

%--------------------------------------------------------------------------
