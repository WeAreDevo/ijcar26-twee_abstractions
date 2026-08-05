%--------------------------------------------------------------------------
% File     : COL019-1 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Combinatory Logic
% Problem  : Weak fixed point for B, S, and T
% Version  : [WM88] (equality) axioms.
% English  : The weak fixed point property holds for the set P consisting
%            of the combinators B, S, and T, where ((Sx)y)z = (xz)(yz),
%            ((Bx)y)z = x(yz), (Tx)y = yx.

% Refs     : [Smu85] Smullyan (1978), To Mock a Mocking Bird and Other Logi
%          : [MW87]  McCune & Wos (1987), A Case Study in Automated Theorem
%          : [WM88]  Wos & McCune (1988), Challenge Problems Focusing on Eq
%          : [MW88]  McCune & Wos (1988), Some Fixed Point Problems in Comb
% Source   : [MW88]
% Names    : - [MW88]

% Status   : Unsatisfiable
% Rating   : 0.09 v9.1.0, 0.14 v8.2.0, 0.21 v8.1.0, 0.25 v7.5.0, 0.21 v7.4.0, 0.30 v7.3.0, 0.21 v7.1.0, 0.11 v6.4.0, 0.16 v6.3.0, 0.18 v6.2.0, 0.14 v6.1.0, 0.00 v6.0.0, 0.10 v5.5.0, 0.05 v5.4.0, 0.00 v5.1.0, 0.07 v4.1.0, 0.09 v4.0.1, 0.07 v4.0.0, 0.15 v3.7.0, 0.11 v3.4.0, 0.12 v3.3.0, 0.00 v2.1.0, 0.13 v2.0.0
% Syntax   : Number of clauses     :    4 (   4 unt;   0 nHn;   1 RR)
%            Number of literals    :    4 (   4 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   4 con; 0-2 aty)
%            Number of variables   :    9 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
cnf(s_definition,axiom,
    apply(apply(apply(s,X),Y),Z) = apply(apply(X,Z),apply(Y,Z)) ).

cnf(b_definition,axiom,
    apply(apply(apply(b,X),Y),Z) = apply(X,apply(Y,Z)) ).

cnf(t_definition,axiom,
    apply(apply(t,X),Y) = apply(Y,X) ).

cnf(prove_fixed_point,negated_conjecture,
    Y != apply(combinator,Y) ).

%--------------------------------------------------------------------------
