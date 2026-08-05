%--------------------------------------------------------------------------
% File     : RNG026-6 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Ring Theory (Alternative)
% Problem  : Teichmuller Identity
% Version  : [Ste87] (equality) axioms.
% English  :

% Refs     : [Ste87] Stevens (1987), Some Experiments in Nonassociative Rin
% Source   : [Ste87]
% Names    : Teichmuller Identity [Ste87]

% Status   : Unsatisfiable
% Rating   : 0.39 v9.1.0, 0.50 v9.0.0, 0.41 v8.2.0, 0.58 v8.1.0, 0.65 v7.5.0, 0.54 v7.4.0, 0.57 v7.3.0, 0.58 v7.1.0, 0.50 v7.0.0, 0.53 v6.4.0, 0.58 v6.3.0, 0.59 v6.2.0, 0.57 v6.1.0, 0.62 v6.0.0, 0.76 v5.5.0, 0.74 v5.4.0, 0.60 v5.3.0, 0.58 v5.2.0, 0.57 v5.1.0, 0.60 v5.0.0, 0.57 v4.1.0, 0.55 v4.0.1, 0.57 v4.0.0, 0.54 v3.7.0, 0.56 v3.4.0, 0.62 v3.3.0, 0.50 v3.2.0, 0.57 v3.1.0, 0.33 v2.7.0, 0.64 v2.6.0, 0.50 v2.5.0, 0.25 v2.4.0, 0.67 v2.2.1, 0.89 v2.2.0, 0.86 v2.1.0, 0.88 v2.0.0
% Syntax   : Number of clauses     :   16 (  16 unt;   0 nHn;   1 RR)
%            Number of literals    :   16 (  16 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    7 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   10 (  10 usr;   5 con; 0-3 aty)
%            Number of variables   :   27 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Include nonassociative ring axioms
include('Axioms/RNG003-0.ax').
%--------------------------------------------------------------------------
cnf(prove_teichmuller_identity,negated_conjecture,
    add(add(associator(multiply(a,b),c,d),associator(a,b,multiply(c,d))),additive_inverse(add(add(associator(a,multiply(b,c),d),multiply(a,associator(b,c,d))),multiply(associator(a,b,c),d)))) != additive_identity ).

%--------------------------------------------------------------------------
