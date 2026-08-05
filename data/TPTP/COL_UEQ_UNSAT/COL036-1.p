%--------------------------------------------------------------------------
% File     : COL036-1 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Combinatory Logic
% Problem  : Strong fixed point for B, S, and T
% Version  : [WM88] (equality) axioms.
% English  : The strong fixed point property holds for the set
%            P consisting of the combinators B, S, and T, where ((Sx)y)z
%            = (xz)(yz), ((Bx)y)z = x(yz), (Tx)y = yx.

% Refs     : [Smu85] Smullyan (1978), To Mock a Mocking Bird and Other Logi
%          : [MW87]  McCune & Wos (1987), A Case Study in Automated Theorem
%          : [WM88]  Wos & McCune (1988), Challenge Problems Focusing on Eq
%          : [MW88]  McCune & Wos (1988), Some Fixed Point Problems in Comb
% Source   : [MW88]
% Names    : - [MW88]

% Status   : Unsatisfiable
% Rating   : 0.39 v9.1.0, 0.45 v8.2.0, 0.50 v7.5.0, 0.54 v7.4.0, 0.61 v7.3.0, 0.58 v7.1.0, 0.50 v7.0.0, 0.47 v6.4.0, 0.58 v6.3.0, 0.53 v6.2.0, 0.50 v6.1.0, 0.56 v6.0.0, 0.67 v5.5.0, 0.63 v5.4.0, 0.67 v5.2.0, 0.57 v5.1.0, 0.60 v5.0.0, 0.57 v4.1.0, 0.45 v4.0.1, 0.57 v4.0.0, 0.62 v3.7.0, 0.44 v3.4.0, 0.50 v3.2.0, 0.57 v3.1.0, 0.67 v2.7.0, 0.64 v2.6.0, 0.33 v2.5.0, 0.00 v2.4.0, 0.00 v2.2.1, 0.22 v2.2.0, 0.14 v2.1.0, 0.75 v2.0.0
% Syntax   : Number of clauses     :    4 (   4 unt;   0 nHn;   1 RR)
%            Number of literals    :    4 (   4 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   3 con; 0-2 aty)
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
    apply(Y,f(Y)) != apply(f(Y),apply(Y,f(Y))) ).

%--------------------------------------------------------------------------
