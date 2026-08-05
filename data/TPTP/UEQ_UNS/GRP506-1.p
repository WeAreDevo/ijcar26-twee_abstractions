%--------------------------------------------------------------------------
% File     : GRP506-1 : TPTP v9.2.1. Released v2.6.0.
% Domain   : Group Theory (Abelian)
% Problem  : Axiom for Abelian group theory, in product and inverse, part 2
% Version  : [McC93] (equality) axioms.
% English  :

% Refs     : [Neu81] Neumann (1981), Another Single Law for Groups
%          : [LW92]  Lusk & Wos (1992), Benchmark Problems in Which Equalit
%          : [McC93] McCune (1993), Single Axioms for Groups and Abelian Gr
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.74 v9.1.0, 0.68 v9.0.0, 0.77 v8.2.0, 0.75 v8.1.0, 0.65 v7.5.0, 0.71 v7.4.0, 0.78 v7.3.0, 0.74 v7.1.0, 0.67 v7.0.0, 0.63 v6.4.0, 0.68 v6.3.0, 0.65 v6.2.0, 0.64 v6.1.0, 0.75 v6.0.0, 0.81 v5.5.0, 0.84 v5.4.0, 0.87 v5.3.0, 0.83 v5.2.0, 0.86 v5.1.0, 0.87 v5.0.0, 0.86 v4.1.0, 0.73 v4.0.1, 0.79 v4.0.0, 0.77 v3.7.0, 0.67 v3.4.0, 0.75 v3.3.0, 0.71 v3.2.0, 0.64 v3.1.0, 0.67 v2.7.0, 0.73 v2.6.0
% Syntax   : Number of clauses     :    2 (   2 unt;   0 nHn;   1 RR)
%            Number of literals    :    2 (   2 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :   10 (   3 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    4 (   4 usr;   2 con; 0-2 aty)
%            Number of variables   :    6 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : A UEQ part of GRP084-1
%--------------------------------------------------------------------------
cnf(single_axiom,axiom,
    multiply(inverse(multiply(inverse(multiply(inverse(multiply(A,B)),multiply(B,A))),multiply(inverse(multiply(C,D)),multiply(C,inverse(multiply(multiply(E,inverse(F)),inverse(D))))))),F) = E ).

cnf(prove_these_axioms_2,negated_conjecture,
    multiply(multiply(inverse(b2),b2),a2) != a2 ).

%--------------------------------------------------------------------------
