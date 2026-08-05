%--------------------------------------------------------------------------
% File     : RNG024-6 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Ring Theory (Alternative)
% Problem  : Right alternative
% Version  : [Ste87] (equality) axioms.
%            Theorem formulation : In terms of associators
% English  :

% Refs     : [Ste87] Stevens (1987), Some Experiments in Nonassociative Rin
%          : [Ste92] Stevens (1992), Unpublished Note
% Source   : [Ste92]
% Names    : - [Ste87]

% Status   : Unsatisfiable
% Rating   : 0.00 v7.4.0, 0.04 v7.3.0, 0.00 v6.1.0, 0.06 v6.0.0, 0.10 v5.5.0, 0.05 v5.4.0, 0.07 v5.3.0, 0.00 v2.1.0, 0.13 v2.0.0
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
cnf(prove_right_alternative,negated_conjecture,
    associator(x,y,y) != additive_identity ).

%--------------------------------------------------------------------------
