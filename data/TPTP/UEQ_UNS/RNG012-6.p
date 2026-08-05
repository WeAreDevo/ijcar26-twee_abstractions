%--------------------------------------------------------------------------
% File     : RNG012-6 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Ring Theory (Alternative)
% Problem  : Product of inverses equal product
% Version  : [Ste87] (equality) axioms.
% English  :

% Refs     : [Ste87] Stevens (1987), Some Experiments in Nonassociative Rin
% Source   : [Ste87]
% Names    : c15 [Ste87]

% Status   : Unsatisfiable
% Rating   : 0.09 v9.1.0, 0.14 v8.2.0, 0.12 v8.1.0, 0.15 v7.5.0, 0.12 v7.4.0, 0.22 v7.3.0, 0.21 v7.1.0, 0.11 v7.0.0, 0.21 v6.3.0, 0.24 v6.2.0, 0.29 v6.1.0, 0.19 v6.0.0, 0.33 v5.5.0, 0.37 v5.4.0, 0.13 v5.3.0, 0.08 v5.2.0, 0.14 v5.1.0, 0.13 v5.0.0, 0.07 v4.1.0, 0.00 v2.2.1, 0.22 v2.2.0, 0.29 v2.1.0, 0.25 v2.0.0
% Syntax   : Number of clauses     :   16 (  16 unt;   0 nHn;   1 RR)
%            Number of literals    :   16 (  16 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   3 con; 0-3 aty)
%            Number of variables   :   27 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Include nonassociative ring axioms
include('Axioms/RNG003-0.ax').
%--------------------------------------------------------------------------
cnf(prove_equation,negated_conjecture,
    multiply(additive_inverse(a),additive_inverse(b)) != multiply(a,b) ).

%--------------------------------------------------------------------------
