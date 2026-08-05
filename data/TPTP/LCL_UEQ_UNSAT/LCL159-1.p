%--------------------------------------------------------------------------
% File     : LCL159-1 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Logic Calculi (Wajsberg Algebra)
% Problem  : The 7th alternative Wajsberg algebra axiom
% Version  : [Bon91] (equality) axioms.
% English  :

% Refs     : [FRT84] Font et al. (1984), Wajsberg Algebras
%          : [AB90]  Anantharaman & Bonacina (1990), An Application of the
%          : [Bon91] Bonacina (1991), Problems in Lukasiewicz Logic
% Source   : [Bon91]
% Names    : W' axiom 7 [Bon91]

% Status   : Unsatisfiable
% Rating   : 0.04 v9.1.0, 0.14 v9.0.0, 0.09 v8.2.0, 0.12 v8.1.0, 0.15 v7.5.0, 0.12 v7.4.0, 0.22 v7.3.0, 0.16 v7.1.0, 0.06 v7.0.0, 0.05 v6.4.0, 0.11 v6.3.0, 0.18 v6.2.0, 0.21 v6.1.0, 0.06 v6.0.0, 0.29 v5.5.0, 0.26 v5.4.0, 0.13 v5.3.0, 0.08 v5.2.0, 0.14 v5.1.0, 0.13 v5.0.0, 0.14 v4.1.0, 0.18 v4.0.1, 0.14 v4.0.0, 0.15 v3.7.0, 0.22 v3.4.0, 0.12 v3.3.0, 0.00 v2.2.1, 0.22 v2.2.0, 0.29 v2.1.0, 0.38 v2.0.0
% Syntax   : Number of clauses     :   17 (  17 unt;   0 nHn;   2 RR)
%            Number of literals    :   17 (  17 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   10 (  10 usr;   4 con; 0-2 aty)
%            Number of variables   :   33 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Include Wajsberg algebra axioms
include('Axioms/LCL001-0.ax').
%----Include Wajsberg algebra and and or definitions
include('Axioms/LCL001-2.ax').
%----Include Alternative Wajsberg algebra definitions
include('Axioms/LCL002-1.ax').
%--------------------------------------------------------------------------
cnf(prove_alternative_wajsberg_axiom,negated_conjecture,
    xor(x,xor(truth,y)) != xor(xor(x,truth),y) ).

%--------------------------------------------------------------------------
