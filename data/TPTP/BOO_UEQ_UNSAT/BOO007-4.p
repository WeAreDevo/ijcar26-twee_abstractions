%--------------------------------------------------------------------------
% File     : BOO007-4 : TPTP v9.2.1. Released v1.1.0.
% Domain   : Boolean Algebra
% Problem  : Product is associative ( (X * Y) * Z = X * (Y * Z) )
% Version  : [Ver94] (equality) axioms.
% English  :

% Refs     : [Ver94] Veroff (1994), Problem Set
% Source   : [Ver94]
% Names    : TD [Ver94]

% Status   : Unsatisfiable
% Rating   : 0.04 v9.1.0, 0.14 v9.0.0, 0.09 v8.2.0, 0.17 v8.1.0, 0.25 v7.5.0, 0.17 v7.4.0, 0.30 v7.3.0, 0.16 v7.1.0, 0.06 v7.0.0, 0.05 v6.4.0, 0.11 v6.3.0, 0.12 v6.2.0, 0.14 v6.1.0, 0.31 v6.0.0, 0.48 v5.5.0, 0.42 v5.4.0, 0.27 v5.3.0, 0.17 v5.2.0, 0.21 v5.1.0, 0.27 v5.0.0, 0.21 v4.1.0, 0.18 v4.0.1, 0.14 v4.0.0, 0.15 v3.7.0, 0.22 v3.4.0, 0.25 v3.3.0, 0.14 v3.2.0, 0.07 v3.1.0, 0.11 v2.7.0, 0.09 v2.6.0, 0.00 v2.2.1, 0.33 v2.2.0, 0.43 v2.1.0, 0.62 v2.0.0
% Syntax   : Number of clauses     :    9 (   9 unt;   0 nHn;   1 RR)
%            Number of literals    :    9 (   9 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   5 con; 0-2 aty)
%            Number of variables   :   14 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Include boolean algebra axioms for equality formulation
include('Axioms/BOO004-0.ax').
%--------------------------------------------------------------------------
cnf(prove_associativity,negated_conjecture,
    multiply(a,multiply(b,c)) != multiply(multiply(a,b),c) ).

%--------------------------------------------------------------------------
