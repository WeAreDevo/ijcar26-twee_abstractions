%--------------------------------------------------------------------------
% File     : RNG025-4 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Ring Theory (Alternative)
% Problem  : Middle or Flexible Law
% Version  : [Ste87] (equality) axioms.
%            Theorem formulation : Linearized.
% English  :

% Refs     : [Ste87] Stevens (1987), Some Experiments in Nonassociative Rin
%          : [Ste92] Stevens (1992), Unpublished Note
% Source   : [Ste92]
% Names    : - [Ste87]

% Status   : Unsatisfiable
% Rating   : 0.83 v9.1.0, 0.82 v8.2.0, 0.79 v8.1.0, 0.85 v7.5.0, 0.71 v7.4.0, 0.78 v7.3.0, 0.74 v7.1.0, 0.72 v7.0.0, 0.74 v6.3.0, 0.71 v6.2.0, 0.64 v6.1.0, 0.69 v6.0.0, 0.76 v5.5.0, 0.74 v5.4.0, 0.60 v5.3.0, 0.50 v5.2.0, 0.57 v5.1.0, 0.53 v5.0.0, 0.50 v4.1.0, 0.45 v4.0.1, 0.50 v4.0.0, 0.54 v3.7.0, 0.33 v3.4.0, 0.25 v3.3.0, 0.36 v3.2.0, 0.29 v3.1.0, 0.44 v2.7.0, 0.45 v2.6.0, 0.67 v2.5.0, 0.75 v2.4.0, 0.67 v2.2.1, 0.89 v2.2.0, 0.86 v2.1.0, 0.88 v2.0.0
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
cnf(prove_equation,negated_conjecture,
    add(associator(x,y,z),associator(x,z,y)) != additive_identity ).

%--------------------------------------------------------------------------
