%--------------------------------------------------------------------------
% File     : COL001-2 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Combinatory Logic
% Problem  : Weak fixed point for S and K
% Version  : [WM88] (equality) axioms : Augmented.
% English  : The weak fixed point property holds for the set P consisting
%            of the combinators S and K alone, where ((Sx)y)z = (xz)(yz)
%            and (Kx)y = x.

% Refs     : [WM88]  Wos & McCune (1988), Challenge Problems Focusing on Eq
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.09 v9.1.0, 0.18 v9.0.0, 0.14 v8.2.0, 0.21 v8.1.0, 0.20 v7.5.0, 0.25 v7.4.0, 0.30 v7.3.0, 0.26 v7.1.0, 0.17 v7.0.0, 0.16 v6.4.0, 0.21 v6.3.0, 0.18 v6.2.0, 0.21 v6.1.0, 0.12 v6.0.0, 0.24 v5.5.0, 0.21 v5.4.0, 0.13 v5.3.0, 0.17 v5.2.0, 0.21 v5.1.0, 0.27 v5.0.0, 0.29 v4.1.0, 0.18 v4.0.1, 0.21 v4.0.0, 0.31 v3.7.0, 0.11 v3.4.0, 0.12 v3.3.0, 0.07 v3.1.0, 0.11 v2.7.0, 0.00 v2.1.0, 0.13 v2.0.0
% Syntax   : Number of clauses     :    6 (   6 unt;   0 nHn;   1 RR)
%            Number of literals    :    6 (   6 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   6 con; 0-2 aty)
%            Number of variables   :   11 (   1 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : This allows the use of B and I in the proof, as done in the
%            "Proof of Theorem C1" in [WM88].
%--------------------------------------------------------------------------
cnf(s_definition,axiom,
    apply(apply(apply(s,X),Y),Z) = apply(apply(X,Z),apply(Y,Z)) ).

cnf(k_definition,axiom,
    apply(apply(k,X),Y) = X ).

cnf(b_definition,axiom,
    apply(apply(apply(b,X),Y),Z) = apply(X,apply(Y,Z)) ).

cnf(i_definition,axiom,
    apply(i,X) = X ).

cnf(sb_property,axiom,
    apply(apply(apply(s,apply(b,X)),i),apply(apply(s,apply(b,X)),i)) = apply(x,apply(apply(apply(s,apply(b,X)),i),apply(apply(s,apply(b,X)),i))) ).

cnf(prove_fixed_point,negated_conjecture,
    Y != apply(combinator,Y) ).

%--------------------------------------------------------------------------
