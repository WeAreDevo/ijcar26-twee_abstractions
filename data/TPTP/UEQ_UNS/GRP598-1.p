%--------------------------------------------------------------------------
% File     : GRP598-1 : TPTP v9.2.1. Released v2.6.0.
% Domain   : Group Theory (Abelian)
% Problem  : Axiom for Abelian group theory, in double div and inv, part 2
% Version  : [McC93] (equality) axioms.
% English  :

% Refs     : [McC93] McCune (1993), Single Axioms for Groups and Abelian Gr
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.09 v9.1.0, 0.14 v8.2.0, 0.21 v8.1.0, 0.25 v7.4.0, 0.30 v7.3.0, 0.26 v7.1.0, 0.17 v7.0.0, 0.21 v6.4.0, 0.26 v6.3.0, 0.24 v6.2.0, 0.21 v6.1.0, 0.19 v6.0.0, 0.33 v5.5.0, 0.32 v5.4.0, 0.13 v5.3.0, 0.08 v5.2.0, 0.14 v5.1.0, 0.13 v5.0.0, 0.14 v4.1.0, 0.09 v4.0.1, 0.14 v4.0.0, 0.15 v3.7.0, 0.11 v3.4.0, 0.12 v3.3.0, 0.07 v3.1.0, 0.11 v2.7.0, 0.00 v2.6.0
% Syntax   : Number of clauses     :    3 (   3 unt;   0 nHn;   1 RR)
%            Number of literals    :    3 (   3 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    7 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   2 con; 0-2 aty)
%            Number of variables   :    5 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : A UEQ part of GRP107-1
%--------------------------------------------------------------------------
cnf(single_axiom,axiom,
    double_divide(double_divide(A,B),inverse(double_divide(A,inverse(double_divide(inverse(C),B))))) = C ).

cnf(multiply,axiom,
    multiply(A,B) = inverse(double_divide(B,A)) ).

cnf(prove_these_axioms_2,negated_conjecture,
    multiply(multiply(inverse(b2),b2),a2) != a2 ).

%--------------------------------------------------------------------------
