%--------------------------------------------------------------------------
% File     : LCL138-1 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Logic Calculi (Wajsberg Algebra)
% Problem  : A lemma in Wajsberg algebras
% Version  : [Bon91] (equality) axioms.
% English  :

% Refs     : [FRT84] Font et al. (1984), Wajsberg Algebras
%          : [Bon91] Bonacina (1991), Problems in Lukasiewicz Logic
% Source   : [Bon91]
% Names    : Lemma 7 [Bon91]

% Status   : Unsatisfiable
% Rating   : 0.22 v9.1.0, 0.27 v8.2.0, 0.33 v8.1.0, 0.30 v7.5.0, 0.46 v7.4.0, 0.48 v7.3.0, 0.47 v7.1.0, 0.39 v7.0.0, 0.42 v6.4.0, 0.47 v6.3.0, 0.53 v6.2.0, 0.50 v6.1.0, 0.56 v6.0.0, 0.67 v5.5.0, 0.68 v5.4.0, 0.60 v5.3.0, 0.58 v5.2.0, 0.57 v5.1.0, 0.53 v5.0.0, 0.50 v4.1.0, 0.27 v4.0.1, 0.36 v4.0.0, 0.31 v3.7.0, 0.22 v3.4.0, 0.25 v3.3.0, 0.29 v3.2.0, 0.21 v3.1.0, 0.33 v2.7.0, 0.27 v2.6.0, 0.17 v2.5.0, 0.00 v2.4.0, 0.33 v2.3.0, 0.67 v2.2.1, 0.33 v2.2.0, 0.43 v2.1.0, 0.62 v2.0.0
% Syntax   : Number of clauses     :    5 (   5 unt;   0 nHn;   1 RR)
%            Number of literals    :    5 (   5 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   4 con; 0-2 aty)
%            Number of variables   :    8 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Include Wajsberg algebra axioms
include('Axioms/LCL001-0.ax').
%--------------------------------------------------------------------------
cnf(prove_wajsberg_lemma,negated_conjecture,
    implies(x,implies(y,z)) != implies(y,implies(x,z)) ).

%--------------------------------------------------------------------------
