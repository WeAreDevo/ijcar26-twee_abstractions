%--------------------------------------------------------------------------
% File     : COL004-3 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Combinatory Logic
% Problem  : Find combinator equivalent to U from S and K.
% Version  : [WM88] (equality) axioms.
%            Theorem formulation : The combination is provided and checked.
% English  : Construct from S and K alone a combinator that behaves as the
%            combinator U does, where ((Sx)y)z = (xz)(yz), (Kx)y = x,
%            (Ux)y = y((xx)y).

% Refs     : [WM88]  Wos & McCune (1988), Challenge Problems Focusing on Eq
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.04 v9.1.0, 0.09 v8.2.0, 0.12 v8.1.0, 0.20 v7.5.0, 0.21 v7.4.0, 0.22 v7.3.0, 0.21 v7.1.0, 0.11 v7.0.0, 0.21 v6.4.0, 0.32 v6.3.0, 0.29 v6.2.0, 0.36 v6.1.0, 0.25 v6.0.0, 0.33 v5.5.0, 0.32 v5.4.0, 0.20 v5.3.0, 0.17 v5.2.0, 0.21 v5.1.0, 0.13 v5.0.0, 0.21 v4.1.0, 0.18 v4.0.1, 0.21 v4.0.0, 0.23 v3.7.0, 0.33 v3.4.0, 0.38 v3.3.0, 0.21 v3.1.0, 0.22 v2.7.0, 0.27 v2.6.0, 0.17 v2.5.0, 0.00 v2.2.1, 0.22 v2.2.0, 0.29 v2.1.0, 0.38 v2.0.0
% Syntax   : Number of clauses     :    3 (   3 unt;   0 nHn;   1 RR)
%            Number of literals    :    3 (   3 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    9 (   2 avg)
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

%----This is the U equivalent
cnf(prove_u_combinator,negated_conjecture,
    apply(apply(apply(apply(s,apply(k,apply(s,apply(apply(s,k),k)))),apply(apply(s,apply(apply(s,k),k)),apply(apply(s,k),k))),x),y) != apply(y,apply(apply(x,x),y)) ).

%--------------------------------------------------------------------------
