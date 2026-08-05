%--------------------------------------------------------------------------
% File     : BOO013-2 : TPTP v9.2.1. Bugfixed v1.2.1.
% Domain   : Boolean Algebra
% Problem  : The inverse of X is unique
% Version  : [ANL] (equality) axioms.
% English  :

% Refs     :
% Source   : [ANL]
% Names    : prob9.ver2.in [ANL]

% Status   : Unsatisfiable
% Rating   : 0.00 v8.1.0, 0.05 v7.5.0, 0.04 v7.4.0, 0.13 v7.3.0, 0.05 v7.1.0, 0.00 v7.0.0, 0.05 v6.3.0, 0.06 v6.2.0, 0.07 v6.1.0, 0.06 v6.0.0, 0.24 v5.5.0, 0.21 v5.4.0, 0.00 v5.2.0, 0.07 v5.0.0, 0.00 v2.2.1, 0.11 v2.2.0, 0.14 v2.1.0, 0.14 v2.0.0
% Syntax   : Number of clauses     :   19 (  19 unt;   0 nHn;   5 RR)
%            Number of literals    :   19 (  19 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   1 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   5 con; 0-2 aty)
%            Number of variables   :   24 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
% Bugfixes : v1.2.1 - Clauses b_and_multiplicative_identity and
%            c_and_multiplicative_identity fixed.
%--------------------------------------------------------------------------
%----Include boolean algebra axioms for equality formulation
include('Axioms/BOO003-0.ax').
%--------------------------------------------------------------------------
cnf(b_and_multiplicative_identity,hypothesis,
    add(a,b) = multiplicative_identity ).

cnf(c_and_multiplicative_identity,hypothesis,
    add(a,c) = multiplicative_identity ).

cnf(b_a_additive_identity,hypothesis,
    multiply(a,b) = additive_identity ).

cnf(c_a_additive_identity,hypothesis,
    multiply(a,c) = additive_identity ).

cnf(prove_b_is_a,negated_conjecture,
    b != c ).

%--------------------------------------------------------------------------
