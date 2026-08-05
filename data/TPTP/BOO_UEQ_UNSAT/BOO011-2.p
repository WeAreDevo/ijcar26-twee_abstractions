%--------------------------------------------------------------------------
% File     : BOO011-2 : TPTP v9.2.1. Bugfixed v1.2.1.
% Domain   : Boolean Algebra
% Problem  : Inverse of additive identity = Multiplicative identity
% Version  : [ANL] (equality) axioms.
% English  : The inverse of the additive identity is the multiplicative
%            identity.

% Refs     :
% Source   : [ANL]
% Names    : prob7.ver2.in [ANL]

% Status   : Unsatisfiable
% Rating   : 0.00 v7.4.0, 0.04 v7.3.0, 0.00 v7.0.0, 0.05 v6.4.0, 0.11 v6.3.0, 0.12 v6.2.0, 0.14 v6.1.0, 0.06 v6.0.0, 0.10 v5.5.0, 0.05 v5.4.0, 0.00 v2.0.0
% Syntax   : Number of clauses     :   15 (  15 unt;   0 nHn;   1 RR)
%            Number of literals    :   15 (  15 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   1 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   2 con; 0-2 aty)
%            Number of variables   :   24 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
% Bugfixes : v1.2.1 - Clause prove_inverse_of_1_is_0 fixed.
%--------------------------------------------------------------------------
%----Include boolean algebra axioms for equality formulation
include('Axioms/BOO003-0.ax').
%--------------------------------------------------------------------------
cnf(prove_inverse_of_1_is_0,negated_conjecture,
    inverse(additive_identity) != multiplicative_identity ).

%--------------------------------------------------------------------------
