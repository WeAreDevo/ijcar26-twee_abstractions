%--------------------------------------------------------------------------
% File     : GRP120-1 : TPTP v9.2.1. Released v1.2.0.
% Domain   : Group Theory
% Problem  : Derive left identity from a single axiom for groups order 4
% Version  : [Wos96] (equality) axioms.
% English  :

% Refs     : [Wos96] Wos (1996), The Automation of Reasoning: An Experiment
% Source   : [OTTER]
% Names    : groups.exp4.in part 2 [OTTER]

% Status   : Unsatisfiable
% Rating   : 0.09 v9.1.0, 0.14 v8.2.0, 0.21 v8.1.0, 0.30 v7.5.0, 0.21 v7.4.0, 0.30 v7.3.0, 0.21 v7.1.0, 0.11 v7.0.0, 0.16 v6.4.0, 0.21 v6.3.0, 0.24 v6.2.0, 0.21 v6.1.0, 0.12 v6.0.0, 0.38 v5.5.0, 0.32 v5.4.0, 0.13 v5.3.0, 0.00 v5.2.0, 0.07 v4.1.0, 0.09 v4.0.1, 0.07 v4.0.0, 0.08 v3.7.0, 0.11 v3.4.0, 0.12 v3.3.0, 0.00 v3.1.0, 0.11 v2.7.0, 0.00 v2.2.1, 0.44 v2.2.0, 0.57 v2.1.0, 0.43 v2.0.0
% Syntax   : Number of clauses     :    3 (   3 unt;   0 nHn;   2 RR)
%            Number of literals    :    3 (   3 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    3 (   3 usr;   2 con; 0-2 aty)
%            Number of variables   :    3 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
cnf(single_axiom,axiom,
    multiply(Y,multiply(multiply(Y,multiply(multiply(Y,Y),multiply(X,Z))),multiply(Z,multiply(Z,Z)))) = X ).

cnf(single_axiom2,axiom,
    multiply(identity,identity) = identity ).

cnf(prove_order3,negated_conjecture,
    multiply(identity,a) != a ).

%--------------------------------------------------------------------------
