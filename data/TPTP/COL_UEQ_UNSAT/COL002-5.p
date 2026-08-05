%--------------------------------------------------------------------------
% File     : COL002-5 : TPTP v9.2.1. Bugfixed v3.1.0.
% Domain   : Combinatory Logic
% Problem  : Weak fixed point for S, B, C, and I
% Version  : [WM88] (equality) axioms.
%            Theorem formulation : The fixed point is provided and checked.
% English  : The weak fixed point property holds for the set P consisting
%            of the combinators S, B, C, and I, where ((Sx)y)z = (xz)(yz),
%            ((Bx)y)z = x(yz), ((Cx)y)z = (xz)y, and Ix = x.

% Refs     : [WM88]  Wos & McCune (1988), Challenge Problems Focusing on Eq
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.43 v9.1.0, 0.45 v9.0.0, 0.41 v8.2.0, 0.42 v8.1.0, 0.45 v7.5.0, 0.42 v7.4.0, 0.35 v7.3.0, 0.42 v7.1.0, 0.39 v7.0.0, 0.37 v6.4.0, 0.42 v6.3.0, 0.41 v6.2.0, 0.43 v6.1.0, 0.50 v6.0.0, 0.57 v5.5.0, 0.53 v5.4.0, 0.67 v5.2.0, 0.64 v5.1.0, 0.53 v5.0.0, 0.57 v4.1.0, 0.45 v4.0.1, 0.57 v4.0.0, 0.54 v3.7.0, 0.11 v3.4.0, 0.12 v3.3.0, 0.43 v3.1.0
% Syntax   : Number of clauses     :    6 (   6 unt;   0 nHn;   1 RR)
%            Number of literals    :    6 (   6 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   5 con; 0-2 aty)
%            Number of variables   :   11 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : This is the one found in proof 3 of C1.1 in [WM88].
% Bugfixes : Fixed clauses weak_fixed_point and prove_weak_fixed_point.
%--------------------------------------------------------------------------
cnf(s_definition,axiom,
    apply(apply(apply(s,X),Y),Z) = apply(apply(X,Z),apply(Y,Z)) ).

cnf(b_definition,axiom,
    apply(apply(apply(b,X),Y),Z) = apply(X,apply(Y,Z)) ).

cnf(c_definition,axiom,
    apply(apply(apply(c,X),Y),Z) = apply(apply(X,Z),Y) ).

cnf(i_definition,axiom,
    apply(i,X) = X ).

cnf(weak_fixed_point,axiom,
    weak_fixed_point(X) = apply(apply(apply(s,apply(c,apply(b,X))),apply(s,apply(c,apply(b,X)))),apply(s,apply(c,apply(b,X)))) ).

cnf(prove_weak_fixed_point,negated_conjecture,
    weak_fixed_point(fixed_pt) != apply(fixed_pt,weak_fixed_point(fixed_pt)) ).

%--------------------------------------------------------------------------
