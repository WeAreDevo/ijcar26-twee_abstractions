%--------------------------------------------------------------------------
% File     : COL006-5 : TPTP v9.2.1. Released v2.1.0.
% Domain   : Combinatory Logic
% Problem  : Strong fixed point for S and K
% Version  : [WM88] (equality) axioms.
%            Theorem formulation : The fixed point is provided and checked.
% English  : The strong fixed point property holds for the set
%            P consisting of the combinators S and K alone, where
%            ((Sx)y)z = (xz)(yz), (Kx)y = x.

% Refs     : [WM88]  Wos & McCune (1988), Challenge Problems Focusing on Eq
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.57 v9.1.0, 0.59 v9.0.0, 0.55 v8.2.0, 0.67 v8.1.0, 0.70 v7.5.0, 0.58 v7.4.0, 0.57 v7.3.0, 0.58 v7.1.0, 0.50 v7.0.0, 0.58 v6.4.0, 0.63 v6.3.0, 0.65 v6.2.0, 0.71 v6.1.0, 0.75 v6.0.0, 0.86 v5.5.0, 0.79 v5.4.0, 0.80 v5.3.0, 0.75 v5.2.0, 0.79 v5.1.0, 0.80 v5.0.0, 0.79 v4.1.0, 0.73 v4.0.1, 0.71 v4.0.0, 0.69 v3.7.0, 0.56 v3.4.0, 0.62 v3.3.0, 0.64 v3.1.0, 0.56 v2.7.0, 0.91 v2.6.0, 0.33 v2.5.0, 0.00 v2.4.0, 0.67 v2.2.1, 0.88 v2.2.0, 0.80 v2.1.0
% Syntax   : Number of clauses     :    4 (   4 unt;   0 nHn;   2 RR)
%            Number of literals    :    4 (   4 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    8 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   4 con; 0-2 aty)
%            Number of variables   :    5 (   1 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
cnf(s_definition,axiom,
    apply(apply(apply(s,X),Y),Z) = apply(apply(X,Z),apply(Y,Z)) ).

cnf(k_definition,axiom,
    apply(apply(k,X),Y) = X ).

cnf(strong_fixed_point,axiom,
    strong_fixed_point = apply(apply(s,apply(k,apply(apply(s,apply(apply(s,k),k)),apply(apply(s,k),k)))),apply(apply(s,apply(k,apply(apply(s,s),apply(s,k)))),apply(apply(s,apply(k,s)),k))) ).

cnf(prove_strong_fixed_point,negated_conjecture,
    apply(strong_fixed_point,fixed_pt) != apply(fixed_pt,apply(strong_fixed_point,fixed_pt)) ).

%--------------------------------------------------------------------------
