%--------------------------------------------------------------------------
% File     : BOO016-2 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Boolean Algebra
% Problem  : Relating product and sum (X * Y = Z -> X + Z = X)
% Version  : [ANL] (equality) axioms.
% English  :

% Refs     :
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.13 v9.1.0, 0.09 v8.2.0, 0.08 v8.1.0, 0.15 v7.5.0, 0.12 v7.4.0, 0.22 v7.3.0, 0.21 v7.1.0, 0.11 v6.3.0, 0.18 v6.2.0, 0.21 v6.1.0, 0.12 v6.0.0, 0.24 v5.5.0, 0.21 v5.4.0, 0.00 v5.1.0, 0.07 v5.0.0, 0.00 v2.2.1, 0.11 v2.2.0, 0.14 v2.1.0, 0.38 v2.0.0
% Syntax   : Number of clauses     :   16 (  16 unt;   0 nHn;   2 RR)
%            Number of literals    :   16 (  16 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   1 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   5 con; 0-2 aty)
%            Number of variables   :   24 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Include boolean algebra axioms for equality formulation
include('Axioms/BOO003-0.ax').
%--------------------------------------------------------------------------
cnf(x_times_y,hypothesis,
    multiply(x,y) = z ).

cnf(prove_sum,negated_conjecture,
    add(x,z) != x ).

%--------------------------------------------------------------------------
