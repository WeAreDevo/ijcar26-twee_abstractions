%--------------------------------------------------------------------------
% File     : COL066-1 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Combinatory Logic
% Problem  : Find combinator equivalent to P from B, Q and W
% Version  : [WM88] (equality) axioms.
% English  : Construct from B, Q and W alone a combinator that behaves as
%            the combinator P does, where ((Bx)y)z = x(yz), ((Qx)y)z =
%            y(xz), (Wx)y = (xy)y, (((Px)y)y)z = (xy)((xy)z)

% Refs     : [WM88]  Wos & McCune (1988), Challenge Problems Focusing on Eq
%          : [WW+90] Wos et al. (1990), Automated Reasoning Contributes to
% Source   : [WW+90]
% Names    : CL-7 [WW+90]

% Status   : Unsatisfiable
% Rating   : 0.78 v9.1.0, 0.77 v8.2.0, 0.79 v8.1.0, 0.80 v7.5.0, 0.83 v7.4.0, 0.87 v7.3.0, 0.84 v7.1.0, 0.78 v7.0.0, 0.84 v6.4.0, 0.89 v6.3.0, 0.88 v6.2.0, 0.86 v6.1.0, 0.88 v6.0.0, 0.95 v5.5.0, 0.89 v5.4.0, 0.93 v5.3.0, 0.92 v5.2.0, 0.93 v4.1.0, 0.91 v4.0.1, 0.86 v4.0.0, 0.85 v3.7.0, 0.78 v3.4.0, 0.88 v3.3.0, 0.93 v3.1.0, 0.89 v2.7.0, 0.82 v2.6.0, 0.67 v2.5.0, 0.25 v2.4.0, 0.00 v2.3.0, 0.33 v2.2.1, 0.89 v2.2.0, 0.86 v2.1.0, 1.00 v2.0.0
% Syntax   : Number of clauses     :    4 (   4 unt;   0 nHn;   1 RR)
%            Number of literals    :    4 (   4 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   3 con; 0-2 aty)
%            Number of variables   :    9 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
cnf(b_definition,axiom,
    apply(apply(apply(b,X),Y),Z) = apply(X,apply(Y,Z)) ).

cnf(q_definition,axiom,
    apply(apply(apply(q,X),Y),Z) = apply(Y,apply(X,Z)) ).

cnf(w_definition,axiom,
    apply(apply(w,X),Y) = apply(apply(X,Y),Y) ).

cnf(prove_p_combinator,negated_conjecture,
    apply(apply(apply(apply(X,f(X)),g(X)),g(X)),h(X)) != apply(apply(f(X),g(X)),apply(apply(f(X),g(X)),h(X))) ).

%--------------------------------------------------------------------------
