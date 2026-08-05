%--------------------------------------------------------------------------
% File     : BOO004-4 : TPTP v9.2.1. Released v1.1.0.
% Domain   : Boolean Algebra
% Problem  : Addition is idempotent (X + X = X)
% Version  : [Ver94] (equality) axioms.
% English  :

% Refs     : [Ver94] Veroff (1994), Problem Set
% Source   : [Ver94]
% Names    : TA [Ver94]

% Status   : Unsatisfiable
% Rating   : 0.00 v7.4.0, 0.04 v7.3.0, 0.00 v6.4.0, 0.05 v6.3.0, 0.06 v6.2.0, 0.07 v6.1.0, 0.00 v6.0.0, 0.05 v5.4.0, 0.00 v2.0.0
% Syntax   : Number of clauses     :    9 (   9 unt;   0 nHn;   1 RR)
%            Number of literals    :    9 (   9 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   1 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   3 con; 0-2 aty)
%            Number of variables   :   14 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Include boolean algebra axioms for equality formulation
include('Axioms/BOO004-0.ax').
%--------------------------------------------------------------------------
cnf(prove_a_plus_a_is_a,negated_conjecture,
    add(a,a) != a ).

%--------------------------------------------------------------------------
