%--------------------------------------------------------------------------
% File     : COL004-1 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Combinatory Logic
% Problem  : Find combinator equivalent to U from S and K
% Version  : [WM88] (equality) axioms.
% English  : Construct from S and K alone a combinator that behaves as the
%            combinator U does, where ((Sx)y)z = (xz)(yz), (Kx)y
%            = x, (Ux)y = y((xx)y).

% Refs     : [WM88]  Wos & McCune (1988), Challenge Problems Focusing on Eq
% Source   : [WM88]
% Names    : Problem 4 [WM88]

% Status   : Unsatisfiable
% Rating   : 0.43 v9.1.0, 0.45 v8.2.0, 0.46 v8.1.0, 0.50 v7.5.0, 0.58 v7.4.0, 0.61 v7.3.0, 0.63 v7.2.0, 0.58 v7.1.0, 0.56 v7.0.0, 0.53 v6.4.0, 0.58 v6.3.0, 0.59 v6.2.0, 0.57 v6.1.0, 0.69 v6.0.0, 0.71 v5.5.0, 0.68 v5.4.0, 0.67 v5.2.0, 0.57 v5.1.0, 0.67 v5.0.0, 0.64 v4.1.0, 0.55 v4.0.1, 0.64 v4.0.0, 0.62 v3.7.0, 0.44 v3.4.0, 0.38 v3.3.0, 0.50 v3.2.0, 0.57 v3.1.0, 0.67 v2.7.0, 0.55 v2.6.0, 0.17 v2.5.0, 0.25 v2.4.0, 0.00 v2.2.1, 0.56 v2.2.0, 0.57 v2.1.0, 1.00 v2.0.0
% Syntax   : Number of clauses     :    3 (   3 unt;   0 nHn;   1 RR)
%            Number of literals    :    3 (   3 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   2 con; 0-2 aty)
%            Number of variables   :    6 (   1 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
cnf(s_definition,axiom,
    apply(apply(apply(s,X),Y),Z) = apply(apply(X,Z),apply(Y,Z)) ).

cnf(k_definition,axiom,
    apply(apply(k,X),Y) = X ).

cnf(prove_u_combinator,negated_conjecture,
    apply(apply(Z,f(Z)),g(Z)) != apply(g(Z),apply(apply(f(Z),f(Z)),g(Z))) ).

%--------------------------------------------------------------------------
