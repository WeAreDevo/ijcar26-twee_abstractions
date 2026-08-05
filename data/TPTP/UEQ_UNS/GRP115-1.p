%--------------------------------------------------------------------------
% File     : GRP115-1 : TPTP v9.2.1. Released v1.2.0.
% Domain   : Group Theory
% Problem  : Derive order 3 from a single axiom for groups order 3
% Version  : [Wos96] (equality) axioms.
% English  :

% Refs     : [Wos96] Wos (1996), The Automation of Reasoning: An Experiment
% Source   : [OTTER]
% Names    : groups.exp3.in part 1 [OTTER]

% Status   : Unsatisfiable
% Rating   : 0.04 v9.1.0, 0.09 v8.2.0, 0.12 v8.1.0, 0.15 v7.5.0, 0.12 v7.4.0, 0.22 v7.3.0, 0.11 v7.1.0, 0.06 v7.0.0, 0.05 v6.3.0, 0.12 v6.2.0, 0.14 v6.1.0, 0.06 v6.0.0, 0.19 v5.5.0, 0.16 v5.4.0, 0.00 v5.2.0, 0.07 v5.0.0, 0.00 v2.2.1, 0.22 v2.2.0, 0.29 v2.1.0, 0.14 v2.0.0
% Syntax   : Number of clauses     :    2 (   2 unt;   0 nHn;   1 RR)
%            Number of literals    :    2 (   2 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    3 (   3 usr;   2 con; 0-2 aty)
%            Number of variables   :    3 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
cnf(single_axiom,axiom,
    multiply(X,multiply(multiply(X,multiply(multiply(X,Y),Z)),multiply(identity,multiply(Z,Z)))) = Y ).

cnf(prove_order3,negated_conjecture,
    multiply(a,multiply(a,a)) != identity ).

%--------------------------------------------------------------------------
