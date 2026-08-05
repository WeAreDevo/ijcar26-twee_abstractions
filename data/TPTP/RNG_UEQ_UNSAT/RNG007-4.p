%--------------------------------------------------------------------------
% File     : RNG007-4 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Ring Theory
% Problem  : In Boolean rings, X is its own inverse
% Version  : [Peterson & Stickel, 1981] (equality) axioms.
%            Theorem formulation : Equality.
% English  : Given a ring in which for all x, x * x = x, prove that for
%            all x, x + x = additive_identity

% Refs     : [PS81]  Peterson & Stickel (1981), Complete Sets of Reductions
% Source   : [ANL]
% Names    : lemma.ver2.in [ANL]

% Status   : Unsatisfiable
% Rating   : 0.00 v7.4.0, 0.04 v7.3.0, 0.00 v7.0.0, 0.05 v6.3.0, 0.06 v6.2.0, 0.07 v6.1.0, 0.06 v6.0.0, 0.14 v5.5.0, 0.11 v5.4.0, 0.00 v5.1.0, 0.07 v4.1.0, 0.09 v4.0.1, 0.07 v4.0.0, 0.08 v3.7.0, 0.00 v2.2.1, 0.11 v2.2.0, 0.14 v2.1.0, 0.13 v2.0.0
% Syntax   : Number of clauses     :   16 (  16 unt;   0 nHn;   2 RR)
%            Number of literals    :   16 (  16 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   2 con; 0-2 aty)
%            Number of variables   :   26 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Include ring theory axioms
include('Axioms/RNG002-0.ax').
%--------------------------------------------------------------------------
cnf(boolean_ring,hypothesis,
    multiply(X,X) = X ).

cnf(prove_inverse,negated_conjecture,
    add(a,a) != additive_identity ).

%--------------------------------------------------------------------------
