%--------------------------------------------------------------------------
% File     : BOO009-2 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Boolean Algebra
% Problem  : Multiplication absorption (X * (X + Y) = X)
% Version  : [ANL] (equality) axioms.
% English  :

% Refs     :
% Source   : [ANL]
% Names    : prob4_part1.ver2.in [ANL]

% Status   : Unsatisfiable
% Rating   : 0.09 v8.2.0, 0.08 v8.1.0, 0.10 v7.5.0, 0.08 v7.4.0, 0.17 v7.3.0, 0.11 v6.3.0, 0.12 v6.2.0, 0.14 v6.1.0, 0.12 v6.0.0, 0.24 v5.5.0, 0.21 v5.4.0, 0.00 v5.1.0, 0.07 v5.0.0, 0.00 v2.2.1, 0.11 v2.2.0, 0.14 v2.1.0, 0.50 v2.0.0
% Syntax   : Number of clauses     :   15 (  15 unt;   0 nHn;   1 RR)
%            Number of literals    :   15 (  15 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   4 con; 0-2 aty)
%            Number of variables   :   24 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Include boolean algebra axioms for equality formulation
include('Axioms/BOO003-0.ax').
%--------------------------------------------------------------------------
cnf(prove_operation,negated_conjecture,
    multiply(a,add(a,b)) != a ).

%--------------------------------------------------------------------------
