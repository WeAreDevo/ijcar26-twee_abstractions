%--------------------------------------------------------------------------
% File     : COL042-9 : TPTP v9.2.1. Released v2.1.0.
% Domain   : Combinatory Logic
% Problem  : Strong fixed point for B and W1
% Version  : [WM88] (equality) axioms.
%            Theorem formulation : The fixed point is provided and checked.
% English  : The strong fixed point property holds for the set
%            P consisting of the combinators B and W1, where ((Bx)y)z
%            = x(yz), (W1x)y = (yx)x.

% Refs     : [WM88]  Wos & McCune (1988), Challenge Problems Focusing on Eq
%          : [Wos93] Wos (1993), The Kernel Strategy and Its Use for the St
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.22 v9.1.0, 0.23 v9.0.0, 0.18 v8.2.0, 0.25 v8.1.0, 0.20 v7.5.0, 0.21 v7.4.0, 0.30 v7.3.0, 0.21 v7.1.0, 0.11 v7.0.0, 0.16 v6.4.0, 0.21 v6.3.0, 0.18 v6.2.0, 0.21 v6.1.0, 0.25 v6.0.0, 0.38 v5.5.0, 0.37 v5.4.0, 0.33 v5.3.0, 0.25 v5.2.0, 0.29 v5.1.0, 0.20 v5.0.0, 0.36 v4.1.0, 0.27 v4.0.1, 0.29 v4.0.0, 0.23 v3.7.0, 0.11 v3.4.0, 0.12 v3.3.0, 0.14 v3.1.0, 0.11 v2.7.0, 0.18 v2.6.0, 0.00 v2.5.0, 0.25 v2.4.0, 0.00 v2.2.1, 0.38 v2.2.0, 0.60 v2.1.0
% Syntax   : Number of clauses     :    4 (   4 unt;   0 nHn;   2 RR)
%            Number of literals    :    4 (   4 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   4 con; 0-2 aty)
%            Number of variables   :    5 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
cnf(b_definition,axiom,
    apply(apply(apply(b,X),Y),Z) = apply(X,apply(Y,Z)) ).

cnf(w1_definition,axiom,
    apply(apply(w1,X),Y) = apply(apply(Y,X),X) ).

cnf(strong_fixed_point,axiom,
    strong_fixed_point = apply(apply(b,apply(w1,w1)),apply(apply(b,apply(b,w1)),apply(apply(b,b),b))) ).

cnf(prove_strong_fixed_point,negated_conjecture,
    apply(strong_fixed_point,fixed_pt) != apply(fixed_pt,apply(strong_fixed_point,fixed_pt)) ).

%--------------------------------------------------------------------------
