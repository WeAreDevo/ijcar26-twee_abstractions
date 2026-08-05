%--------------------------------------------------------------------------
% File     : COL064-5 : TPTP v9.2.1. Bugfixed v1.2.0.
% Domain   : Combinatory Logic
% Problem  : Find combinator equivalent to V from B and T
% Version  : [WM88] (equality) axioms.
%            Theorem formulation : The combinator is provided and checked.
% English  : Construct from B and T alone a combinator that behaves as the
%            combinator V does, where ((Bx)y)z = x(yz), (Tx)y = yx,
%            ((Vx)y)z = (zx)y.

% Refs     : [WM88]  Wos & McCune (1988), Challenge Problems Focusing on Eq
%          : [WW+90] Wos et al. (1990), Automated Reasoning Contributes to
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.04 v9.1.0, 0.14 v9.0.0, 0.09 v8.2.0, 0.17 v8.1.0, 0.20 v7.5.0, 0.17 v7.4.0, 0.22 v7.3.0, 0.16 v7.1.0, 0.06 v7.0.0, 0.16 v6.4.0, 0.26 v6.3.0, 0.29 v6.2.0, 0.36 v6.1.0, 0.12 v6.0.0, 0.24 v5.5.0, 0.26 v5.4.0, 0.07 v5.3.0, 0.08 v5.2.0, 0.14 v5.1.0, 0.13 v5.0.0, 0.14 v4.1.0, 0.18 v4.0.1, 0.14 v4.0.0, 0.15 v3.7.0, 0.11 v3.4.0, 0.12 v3.3.0, 0.07 v3.1.0, 0.11 v2.7.0, 0.00 v2.2.1, 0.22 v2.2.0, 0.29 v2.1.0, 0.57 v2.0.0
% Syntax   : Number of clauses     :    3 (   3 unt;   0 nHn;   1 RR)
%            Number of literals    :    3 (   3 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :   11 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   5 con; 0-2 aty)
%            Number of variables   :    5 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
% Bugfixes : v1.2.0 : Redundant [fgh]_substitution axioms removed.
%--------------------------------------------------------------------------
cnf(b_definition,axiom,
    apply(apply(apply(b,X),Y),Z) = apply(X,apply(Y,Z)) ).

cnf(t_definition,axiom,
    apply(apply(t,X),Y) = apply(Y,X) ).

%----This is the V equivalent
cnf(prove_v_combinator,negated_conjecture,
    apply(apply(apply(apply(apply(b,apply(apply(b,apply(t,apply(apply(b,b),t))),apply(apply(b,b),b))),t),x),y),z) != apply(apply(z,x),y) ).

%--------------------------------------------------------------------------
