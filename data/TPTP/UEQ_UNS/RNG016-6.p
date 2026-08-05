%--------------------------------------------------------------------------
% File     : RNG016-6 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Ring Theory (Alternative)
% Problem  : (X+ -Y)*Z = (X*Z) + -(Y*Z)
% Version  : [Ste87] (equality) axioms.
% English  :

% Refs     : [Ste87] Stevens (1987), Some Experiments in Nonassociative Rin
% Source   : [Ste87]
% Names    : c19 [Ste87]

% Status   : Unsatisfiable
% Rating   : 0.13 v9.1.0, 0.18 v8.2.0, 0.17 v8.1.0, 0.20 v7.5.0, 0.21 v7.4.0, 0.26 v7.3.0, 0.21 v7.1.0, 0.11 v7.0.0, 0.21 v6.4.0, 0.26 v6.3.0, 0.24 v6.2.0, 0.29 v6.1.0, 0.19 v6.0.0, 0.33 v5.5.0, 0.37 v5.4.0, 0.13 v5.3.0, 0.08 v5.2.0, 0.14 v5.1.0, 0.20 v5.0.0, 0.14 v4.1.0, 0.18 v4.0.1, 0.14 v4.0.0, 0.15 v3.7.0, 0.00 v2.2.1, 0.11 v2.2.0, 0.14 v2.1.0, 0.38 v2.0.0
% Syntax   : Number of clauses     :   16 (  16 unt;   0 nHn;   1 RR)
%            Number of literals    :   16 (  16 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    9 (   9 usr;   4 con; 0-3 aty)
%            Number of variables   :   27 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Include nonassociative ring axioms
include('Axioms/RNG003-0.ax').
%--------------------------------------------------------------------------
cnf(prove_distributivity,negated_conjecture,
    multiply(add(x,additive_inverse(y)),z) != add(multiply(x,z),additive_inverse(multiply(y,z))) ).

%--------------------------------------------------------------------------
