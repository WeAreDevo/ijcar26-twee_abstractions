%--------------------------------------------------------------------------
% File     : COL044-7 : TPTP v9.2.1. Released v2.1.0.
% Domain   : Combinatory Logic
% Problem  : Strong fixed point for B and N
% Version  : [WM88] (equality) axioms.
%            Theorem formulation : The fixed point is provided and checked.
% English  : The strong fixed point property holds for the set
%            P consisting of the combinators B and N, where ((Bx)y)z
%            = x(yz), ((Nx)y)z = ((xz)y)z.

% Refs     : [WM88]  Wos & McCune (1988), Challenge Problems Focusing on Eq
%          : [Wos93] Wos (1993), The Kernel Strategy and Its Use for the St
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.39 v9.1.0, 0.45 v8.2.0, 0.54 v8.1.0, 0.70 v7.5.0, 0.75 v7.4.0, 0.78 v7.3.0, 0.84 v7.1.0, 0.72 v7.0.0, 0.74 v6.4.0, 0.84 v6.3.0, 0.82 v6.2.0, 0.86 v6.1.0, 0.81 v6.0.0, 0.86 v5.5.0, 0.84 v5.4.0, 0.80 v5.3.0, 0.75 v5.2.0, 0.79 v5.1.0, 0.80 v5.0.0, 0.79 v4.1.0, 0.82 v4.0.1, 0.71 v4.0.0, 0.69 v3.7.0, 0.56 v3.4.0, 0.50 v3.3.0, 0.57 v3.2.0, 0.50 v3.1.0, 0.44 v2.7.0, 0.82 v2.6.0, 0.67 v2.5.0, 0.50 v2.4.0, 0.67 v2.2.1, 0.88 v2.2.0, 0.80 v2.1.0
% Syntax   : Number of clauses     :    4 (   4 unt;   0 nHn;   2 RR)
%            Number of literals    :    4 (   4 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :   12 (   3 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   4 con; 0-2 aty)
%            Number of variables   :    6 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
cnf(b_definition,axiom,
    apply(apply(apply(b,X),Y),Z) = apply(X,apply(Y,Z)) ).

cnf(n_definition,axiom,
    apply(apply(apply(n,X),Y),Z) = apply(apply(apply(X,Z),Y),Z) ).

cnf(strong_fixed_point,axiom,
    strong_fixed_point = apply(apply(b,apply(apply(b,apply(apply(n,apply(apply(b,b),apply(apply(n,apply(n,apply(b,b))),n))),n)),b)),b) ).

cnf(prove_strong_fixed_point,negated_conjecture,
    apply(strong_fixed_point,fixed_pt) != apply(fixed_pt,apply(strong_fixed_point,fixed_pt)) ).

%--------------------------------------------------------------------------
