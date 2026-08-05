%--------------------------------------------------------------------------
% File     : BOO005-2 : TPTP v9.2.1. Bugfixed v1.2.1.
% Domain   : Boolean Algebra
% Problem  : Addition is bounded (X + 1 = 1)
% Version  : [ANL] (equality) axioms.
% English  :

% Refs     :
% Source   : [ANL]
% Names    : prob3_part1.ver2.in [ANL]

% Status   : Unsatisfiable
% Rating   : 0.04 v9.1.0, 0.05 v8.2.0, 0.04 v8.1.0, 0.05 v7.5.0, 0.04 v7.4.0, 0.09 v7.3.0, 0.05 v7.1.0, 0.06 v7.0.0, 0.11 v6.3.0, 0.12 v6.2.0, 0.14 v6.1.0, 0.12 v6.0.0, 0.19 v5.5.0, 0.16 v5.4.0, 0.00 v5.1.0, 0.07 v4.1.0, 0.09 v4.0.1, 0.07 v4.0.0, 0.08 v3.7.0, 0.00 v2.1.0, 0.14 v2.0.0
% Syntax   : Number of clauses     :   15 (  15 unt;   0 nHn;   1 RR)
%            Number of literals    :   15 (  15 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   1 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   3 con; 0-2 aty)
%            Number of variables   :   24 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
% Bugfixes : v1.2.1 - Clause prove_a_plus_1_is_a fixed.
%--------------------------------------------------------------------------
%----Include boolean algebra axioms for equality formulation
include('Axioms/BOO003-0.ax').
%--------------------------------------------------------------------------
cnf(prove_a_plus_1_is_a,negated_conjecture,
    add(a,multiplicative_identity) != multiplicative_identity ).

%--------------------------------------------------------------------------
