%--------------------------------------------------------------------------
% File     : RNG025-6 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Ring Theory (Alternative)
% Problem  : Middle or Flexible Law
% Version  : [Ste87] (equality) axioms.
%            Theorem formulation : In terms of associators
% English  :

% Refs     : [Ste87] Stevens (1987), Some Experiments in Nonassociative Rin
%          : [Ste92] Stevens (1992), Unpublished Note
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.57 v9.1.0, 0.59 v8.2.0, 0.67 v8.1.0, 0.75 v7.5.0, 0.62 v7.4.0, 0.70 v7.3.0, 0.63 v7.1.0, 0.61 v7.0.0, 0.63 v6.3.0, 0.59 v6.2.0, 0.50 v6.1.0, 0.62 v6.0.0, 0.71 v5.5.0, 0.74 v5.4.0, 0.60 v5.3.0, 0.50 v5.2.0, 0.57 v5.1.0, 0.53 v5.0.0, 0.50 v4.1.0, 0.45 v4.0.1, 0.43 v4.0.0, 0.46 v3.7.0, 0.22 v3.4.0, 0.25 v3.3.0, 0.29 v3.1.0, 0.44 v2.7.0, 0.36 v2.6.0, 0.67 v2.5.0, 0.75 v2.4.0, 0.33 v2.2.1, 0.89 v2.2.0, 0.86 v2.1.0, 0.88 v2.0.0
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
cnf(prove_flexible_law,negated_conjecture,
    associator(x,y,x) != additive_identity ).

%--------------------------------------------------------------------------
