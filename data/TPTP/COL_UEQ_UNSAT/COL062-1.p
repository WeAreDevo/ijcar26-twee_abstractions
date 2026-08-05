%--------------------------------------------------------------------------
% File     : COL062-1 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Combinatory Logic
% Problem  : Find combinator equivalent to C from B and T
% Version  : [WM88] (equality) axioms.
% English  : Construct from B and T alone a combinator that behaves as the
%            combinator C does, where ((Bx)y)z = x(yz), (Tx)y = yx,
%            ((Cx)y)z = (xz)y

% Refs     : [WM88]  Wos & McCune (1988), Challenge Problems Focusing on Eq
%          : [WW+90] Wos et al. (1990), Automated Reasoning Contributes to
% Source   : [WW+90]
% Names    : CL-3 [WW+90]

% Status   : Unsatisfiable
% Rating   : 0.22 v9.1.0, 0.27 v8.2.0, 0.33 v8.1.0, 0.30 v7.5.0, 0.33 v7.4.0, 0.48 v7.3.0, 0.37 v7.1.0, 0.28 v7.0.0, 0.32 v6.4.0, 0.37 v6.3.0, 0.41 v6.2.0, 0.43 v6.1.0, 0.38 v6.0.0, 0.48 v5.5.0, 0.42 v5.4.0, 0.33 v5.3.0, 0.42 v5.2.0, 0.36 v5.1.0, 0.33 v5.0.0, 0.29 v4.1.0, 0.27 v4.0.1, 0.36 v4.0.0, 0.38 v3.7.0, 0.33 v3.4.0, 0.50 v3.1.0, 0.44 v2.7.0, 0.36 v2.6.0, 0.17 v2.5.0, 0.00 v2.2.1, 0.44 v2.2.0, 0.57 v2.1.0, 1.00 v2.0.0
% Syntax   : Number of clauses     :    3 (   3 unt;   0 nHn;   1 RR)
%            Number of literals    :    3 (   3 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   2 con; 0-2 aty)
%            Number of variables   :    6 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
cnf(b_definition,axiom,
    apply(apply(apply(b,X),Y),Z) = apply(X,apply(Y,Z)) ).

cnf(t_definition,axiom,
    apply(apply(t,X),Y) = apply(Y,X) ).

cnf(prove_c_combinator,negated_conjecture,
    apply(apply(apply(X,f(X)),g(X)),h(X)) != apply(apply(f(X),h(X)),g(X)) ).

%--------------------------------------------------------------------------
