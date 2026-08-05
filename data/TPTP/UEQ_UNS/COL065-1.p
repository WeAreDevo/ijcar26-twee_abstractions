%--------------------------------------------------------------------------
% File     : COL065-1 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Combinatory Logic
% Problem  : Find combinator equivalent to G from B and T
% Version  : [WM88] (equality) axioms.
% English  : Construct from B and T alone a combinator that behaves as the
%            combinator G does, where ((Bx)y)z = x(yz), (Tx)y = yx,
%            (((Gx)y)z)w = (xw)(yz)

% Refs     : [WM88]  Wos & McCune (1988), Challenge Problems Focusing on Eq
%          : [WW+90] Wos et al. (1990), Automated Reasoning Contributes to
% Source   : [WW+90]
% Names    : CL-6 [WW+90]

% Status   : Unsatisfiable
% Rating   : 0.35 v9.1.0, 0.50 v9.0.0, 0.41 v8.2.0, 0.50 v8.1.0, 0.55 v7.5.0, 0.54 v7.4.0, 0.61 v7.3.0, 0.58 v7.1.0, 0.56 v7.0.0, 0.58 v6.4.0, 0.53 v6.2.0, 0.57 v6.1.0, 0.62 v6.0.0, 0.67 v5.5.0, 0.68 v5.4.0, 0.67 v5.2.0, 0.64 v5.1.0, 0.67 v5.0.0, 0.64 v4.0.1, 0.71 v4.0.0, 0.69 v3.7.0, 0.56 v3.4.0, 0.62 v3.3.0, 0.64 v3.2.0, 0.71 v3.1.0, 0.56 v2.7.0, 0.45 v2.6.0, 0.33 v2.5.0, 0.00 v2.4.0, 0.00 v2.2.1, 0.89 v2.2.0, 0.86 v2.1.0, 1.00 v2.0.0
% Syntax   : Number of clauses     :    3 (   3 unt;   0 nHn;   1 RR)
%            Number of literals    :    3 (   3 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   2 con; 0-2 aty)
%            Number of variables   :    6 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
cnf(b_definition,axiom,
    apply(apply(apply(b,X),Y),Z) = apply(X,apply(Y,Z)) ).

cnf(t_definition,axiom,
    apply(apply(t,X),Y) = apply(Y,X) ).

cnf(prove_g_combinator,negated_conjecture,
    apply(apply(apply(apply(X,f(X)),g(X)),h(X)),i(X)) != apply(apply(f(X),i(X)),apply(g(X),h(X))) ).

%--------------------------------------------------------------------------
