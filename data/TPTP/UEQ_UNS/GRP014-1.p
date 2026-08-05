%--------------------------------------------------------------------------
% File     : GRP014-1 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Group Theory
% Problem  : Product is associative in this group theory
% Version  : [Ove90] (equality) axioms : Incomplete.
% English  : The group theory specified by the axiom given implies the
%            associativity of multiply.

% Refs     : [Ove90] Overbeek (1990), ATP competition announced at CADE-10
%          : [Ove93] Overbeek (1993), The CADE-11 Competitions: A Personal
%          : [LM93]  Lusk & McCune (1993), Uniform Strategies: The CADE-11
%          : [Zha93] Zhang (1993), Automated Proofs of Equality Problems in
% Source   : [Ove90]
% Names    : CADE-11 Competition Eq-4 [Ove90]
%          : THEOREM EQ-4 [LM93]
%          : PROBLEM 4 [Zha93]

% Status   : Unsatisfiable
% Rating   : 0.13 v9.1.0, 0.18 v8.2.0, 0.25 v7.4.0, 0.35 v7.3.0, 0.21 v7.1.0, 0.11 v7.0.0, 0.16 v6.4.0, 0.21 v6.3.0, 0.24 v6.2.0, 0.21 v6.1.0, 0.19 v6.0.0, 0.43 v5.5.0, 0.37 v5.4.0, 0.20 v5.3.0, 0.08 v5.2.0, 0.14 v5.1.0, 0.27 v5.0.0, 0.29 v4.1.0, 0.27 v4.0.1, 0.21 v4.0.0, 0.23 v3.7.0, 0.22 v3.4.0, 0.25 v3.3.0, 0.07 v3.2.0, 0.14 v3.1.0, 0.11 v2.7.0, 0.18 v2.6.0, 0.00 v2.2.1, 0.33 v2.2.0, 0.43 v2.1.0, 0.50 v2.0.0
% Syntax   : Number of clauses     :    2 (   2 unt;   0 nHn;   1 RR)
%            Number of literals    :    2 (   2 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    9 (   3 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   3 con; 0-2 aty)
%            Number of variables   :    4 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : The group_axiom is in fact a single axiom for group theory
%            [LM93].
%--------------------------------------------------------------------------
cnf(group_axiom,axiom,
    multiply(X,inverse(multiply(multiply(inverse(multiply(inverse(Y),multiply(inverse(X),W))),Z),inverse(multiply(Y,Z))))) = W ).

cnf(prove_associativity,negated_conjecture,
    multiply(a,multiply(b,c)) != multiply(multiply(a,b),c) ).

%--------------------------------------------------------------------------
