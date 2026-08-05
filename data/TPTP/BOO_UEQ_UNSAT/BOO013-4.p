%--------------------------------------------------------------------------
% File     : BOO013-4 : TPTP v9.2.1. Released v1.1.0.
% Domain   : Boolean Algebra
% Problem  : The inverse of X is unique
% Version  : [Ver94] (equality) axioms.
% English  :

% Refs     : [Ver94] Veroff (1994), Problem Set
% Source   : [Ver94]
% Names    : TE [Ver94]

% Status   : Unsatisfiable
% Rating   : 0.00 v7.4.0, 0.04 v7.3.0, 0.00 v7.0.0, 0.05 v6.3.0, 0.12 v6.2.0, 0.14 v6.1.0, 0.06 v6.0.0, 0.19 v5.5.0, 0.21 v5.4.0, 0.07 v5.3.0, 0.00 v5.2.0, 0.07 v5.1.0, 0.00 v2.2.1, 0.22 v2.2.0, 0.29 v2.1.0, 0.25 v2.0.0
% Syntax   : Number of clauses     :   11 (  11 unt;   0 nHn;   3 RR)
%            Number of literals    :   11 (  11 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   1 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   4 con; 0-2 aty)
%            Number of variables   :   14 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Include boolean algebra axioms for equality formulation
include('Axioms/BOO004-0.ax').
%--------------------------------------------------------------------------
cnf(b_a_multiplicative_identity,hypothesis,
    add(a,b) = multiplicative_identity ).

cnf(b_an_additive_identity,hypothesis,
    multiply(a,b) = additive_identity ).

cnf(prove_a_inverse_is_b,negated_conjecture,
    b != inverse(a) ).

%--------------------------------------------------------------------------
