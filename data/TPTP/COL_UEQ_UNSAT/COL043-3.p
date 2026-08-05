%--------------------------------------------------------------------------
% File     : COL043-3 : TPTP v9.2.1. Bugfixed v2.3.0.
% Domain   : Combinatory Logic
% Problem  : Strong fixed point for B and H
% Version  : [WM88] (equality) axioms.
%            Theorem formulation : The fixed point is provided and checked.
% English  : The strong fixed point property holds for the set
%            P consisting of the combinators B and H, where ((Bx)y)z
%            = x(yz), ((Hx)y)z = ((xy)z)y.

% Refs     : [WM88]  Wos & McCune (1988), Challenge Problems Focusing on Eq
%          : [Wos93] Wos (1993), The Kernel Strategy and Its Use for the St
% Source   : [TPTP]
% Names    : - [Wos93]

% Status   : Unsatisfiable
% Rating   : 0.48 v9.1.0, 0.50 v9.0.0, 0.55 v8.2.0, 0.62 v8.1.0, 0.75 v7.5.0, 0.83 v7.4.0, 0.87 v7.3.0, 0.89 v6.3.0, 0.88 v6.2.0, 0.86 v6.1.0, 0.88 v6.0.0, 0.90 v5.5.0, 0.89 v5.4.0, 0.87 v5.3.0, 0.83 v5.2.0, 0.86 v5.1.0, 0.87 v5.0.0, 0.86 v4.1.0, 0.82 v4.0.1, 0.79 v4.0.0, 0.77 v3.7.0, 0.67 v3.4.0, 0.75 v3.3.0, 0.79 v3.2.0, 0.71 v3.1.0, 0.78 v2.7.0, 1.00 v2.6.0, 0.83 v2.5.0, 0.75 v2.4.0, 0.67 v2.3.0
% Syntax   : Number of clauses     :    4 (   4 unt;   0 nHn;   2 RR)
%            Number of literals    :    4 (   4 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :   11 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   4 con; 0-2 aty)
%            Number of variables   :    6 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
% Bugfixes : v2.3.0 - Clause strong_fixed_point fixed.
%--------------------------------------------------------------------------
cnf(b_definition,axiom,
    apply(apply(apply(b,X),Y),Z) = apply(X,apply(Y,Z)) ).

cnf(h_definition,axiom,
    apply(apply(apply(h,X),Y),Z) = apply(apply(apply(X,Y),Z),Y) ).

cnf(strong_fixed_point,axiom,
    strong_fixed_point = apply(apply(b,apply(apply(b,apply(apply(h,apply(apply(b,apply(apply(b,h),apply(b,b))),apply(h,apply(apply(b,h),apply(b,b))))),h)),b)),b) ).

cnf(prove_strong_fixed_point,negated_conjecture,
    apply(strong_fixed_point,fixed_pt) != apply(fixed_pt,apply(strong_fixed_point,fixed_pt)) ).

%--------------------------------------------------------------------------
