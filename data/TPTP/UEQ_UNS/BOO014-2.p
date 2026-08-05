%--------------------------------------------------------------------------
% File     : BOO014-2 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Boolean Algebra
% Problem  : DeMorgan for inverse and product (X+Y)^-1 = (X^-1) * (Y^-1)
% Version  : [ANL] (equality) axioms.
% English  :

% Refs     :
% Source   : [ANL]
% Names    : prob10.ver2.in [ANL]

% Status   : Unsatisfiable
% Rating   : 0.04 v9.1.0, 0.05 v8.2.0, 0.04 v8.1.0, 0.10 v7.5.0, 0.08 v7.4.0, 0.22 v7.3.0, 0.16 v7.1.0, 0.06 v7.0.0, 0.05 v6.4.0, 0.11 v6.3.0, 0.12 v6.2.0, 0.14 v6.1.0, 0.12 v6.0.0, 0.29 v5.5.0, 0.32 v5.4.0, 0.13 v5.3.0, 0.00 v5.2.0, 0.07 v5.0.0, 0.00 v2.2.1, 0.22 v2.2.0, 0.29 v2.1.0, 0.75 v2.0.0
% Syntax   : Number of clauses     :   17 (  17 unt;   0 nHn;   3 RR)
%            Number of literals    :   17 (  17 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   1 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    9 (   9 usr;   6 con; 0-2 aty)
%            Number of variables   :   24 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Include boolean algebra axioms for equality formulation
include('Axioms/BOO003-0.ax').
%--------------------------------------------------------------------------
cnf(a_plus_b_is_c,hypothesis,
    add(a,b) = c ).

cnf(a_inverse_times_b_inverse_is_d,hypothesis,
    multiply(inverse(a),inverse(b)) = d ).

cnf(prove_c_inverse_is_d,negated_conjecture,
    inverse(c) != d ).

%--------------------------------------------------------------------------
