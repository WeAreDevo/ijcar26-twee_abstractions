%--------------------------------------------------------------------------
% File     : RNG019-6 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Ring Theory (Alternative)
% Problem  : First part of the linearised form of the associator
% Version  : [Ste87] (equality) axioms.
% English  : The associator can be expressed in another form called
%            a linearised form. There are three clauses to be proved
%            to establish the equivalence of the two forms.

% Refs     : [Ste87] Stevens (1987), Some Experiments in Nonassociative Rin
% Source   : [Ste87]
% Names    : c24 [Ste87]

% Status   : Unsatisfiable
% Rating   : 0.35 v9.1.0, 0.41 v9.0.0, 0.32 v8.2.0, 0.46 v8.1.0, 0.60 v7.5.0, 0.42 v7.4.0, 0.43 v7.3.0, 0.42 v7.1.0, 0.33 v7.0.0, 0.32 v6.4.0, 0.42 v6.3.0, 0.35 v6.2.0, 0.36 v6.1.0, 0.38 v6.0.0, 0.57 v5.5.0, 0.53 v5.4.0, 0.33 v5.3.0, 0.25 v5.2.0, 0.29 v5.1.0, 0.27 v5.0.0, 0.29 v4.1.0, 0.27 v4.0.1, 0.29 v4.0.0, 0.31 v3.7.0, 0.22 v3.4.0, 0.38 v3.3.0, 0.14 v3.2.0, 0.21 v3.1.0, 0.11 v2.7.0, 0.18 v2.6.0, 0.33 v2.5.0, 0.25 v2.4.0, 0.67 v2.2.1, 0.78 v2.2.0, 0.71 v2.1.0, 0.50 v2.0.0
% Syntax   : Number of clauses     :   16 (  16 unt;   0 nHn;   1 RR)
%            Number of literals    :   16 (  16 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   10 (  10 usr;   5 con; 0-3 aty)
%            Number of variables   :   27 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Include nonassociative ring axioms
include('Axioms/RNG003-0.ax').
%--------------------------------------------------------------------------
cnf(prove_linearised_form1,negated_conjecture,
    associator(x,y,add(u,v)) != add(associator(x,y,u),associator(x,y,v)) ).

%--------------------------------------------------------------------------
