%--------------------------------------------------------------------------
% File     : COL066-2 : TPTP v9.2.1. Bugfixed v1.2.0.
% Domain   : Combinatory Logic
% Problem  : Find combinator equivalent to P from B, Q and W
% Version  : [WM88] (equality) axioms.
%            Theorem formulation : The combinator is provided and checked.
% English  : Construct from B, Q and W alone a combinator that behaves as
%            the combinator P does, where ((Bx)y)z = x(yz), ((Qx)y)z =
%            y(xz), (Wx)y = (xy)y, (((Px)y)y)z = (xy)((xy)z)

% Refs     : [WM88]  Wos & McCune (1988), Challenge Problems Focusing on Eq
%          : [WW+90] Wos et al. (1990), Automated Reasoning Contributes to
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.00 v9.1.0, 0.09 v9.0.0, 0.05 v8.2.0, 0.12 v8.1.0, 0.15 v7.5.0, 0.12 v7.4.0, 0.17 v7.3.0, 0.11 v7.1.0, 0.00 v7.0.0, 0.05 v6.4.0, 0.11 v6.3.0, 0.06 v6.2.0, 0.07 v6.1.0, 0.06 v6.0.0, 0.24 v5.5.0, 0.16 v5.4.0, 0.07 v5.3.0, 0.00 v5.2.0, 0.07 v5.1.0, 0.00 v5.0.0, 0.07 v4.1.0, 0.09 v4.0.1, 0.07 v4.0.0, 0.08 v3.7.0, 0.11 v3.4.0, 0.12 v3.3.0, 0.00 v2.7.0, 0.09 v2.6.0, 0.00 v2.1.0, 0.29 v2.0.0
% Syntax   : Number of clauses     :    4 (   4 unt;   0 nHn;   1 RR)
%            Number of literals    :    4 (   4 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    9 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   6 con; 0-2 aty)
%            Number of variables   :    8 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
% Bugfixes : v1.2.0 : Redundant [fgh]_substitution axioms removed.
%--------------------------------------------------------------------------
cnf(b_definition,axiom,
    apply(apply(apply(b,X),Y),Z) = apply(X,apply(Y,Z)) ).

cnf(q_definition,axiom,
    apply(apply(apply(q,X),Y),Z) = apply(Y,apply(X,Z)) ).

cnf(w_definition,axiom,
    apply(apply(w,X),Y) = apply(apply(X,Y),Y) ).

%----This is the P equivalent
cnf(prove_p_combinator,negated_conjecture,
    apply(apply(apply(apply(apply(apply(q,q),apply(w,apply(q,apply(q,q)))),x),y),y),z) != apply(apply(x,y),apply(apply(x,y),z)) ).

%--------------------------------------------------------------------------
