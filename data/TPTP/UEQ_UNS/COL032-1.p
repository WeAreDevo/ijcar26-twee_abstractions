%--------------------------------------------------------------------------
% File     : COL032-1 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Combinatory Logic
% Problem  : Strong fixed point for Q and M
% Version  : [WM88] (equality) axioms.
% English  : The strong fixed point property holds for the set
%            P consisting of the combinators Q and M, where Mx = xx,
%            ((Qx)y)z = y(xz).

% Refs     : [Smu85] Smullyan (1978), To Mock a Mocking Bird and Other Logi
%          : [MW87]  McCune & Wos (1987), A Case Study in Automated Theorem
%          : [WM88]  Wos & McCune (1988), Challenge Problems Focusing on Eq
%          : [MW88]  McCune & Wos (1988), Some Fixed Point Problems in Comb
% Source   : [MW88]
% Names    : - [MW88]

% Status   : Unsatisfiable
% Rating   : 0.13 v9.1.0, 0.18 v8.2.0, 0.25 v8.1.0, 0.30 v7.5.0, 0.29 v7.4.0, 0.35 v7.3.0, 0.32 v7.1.0, 0.28 v7.0.0, 0.26 v6.3.0, 0.29 v6.1.0, 0.19 v6.0.0, 0.29 v5.5.0, 0.21 v5.4.0, 0.20 v5.3.0, 0.17 v5.2.0, 0.14 v5.1.0, 0.20 v5.0.0, 0.21 v4.1.0, 0.18 v4.0.1, 0.21 v4.0.0, 0.23 v3.7.0, 0.11 v3.4.0, 0.12 v3.3.0, 0.14 v3.1.0, 0.22 v2.7.0, 0.00 v2.2.1, 0.11 v2.2.0, 0.00 v2.1.0, 0.13 v2.0.0
% Syntax   : Number of clauses     :    3 (   3 unt;   0 nHn;   1 RR)
%            Number of literals    :    3 (   3 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    4 (   4 usr;   2 con; 0-2 aty)
%            Number of variables   :    5 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
cnf(m_definition,axiom,
    apply(m,X) = apply(X,X) ).

cnf(q_definition,axiom,
    apply(apply(apply(q,X),Y),Z) = apply(Y,apply(X,Z)) ).

cnf(prove_fixed_point,negated_conjecture,
    apply(Y,f(Y)) != apply(f(Y),apply(Y,f(Y))) ).

%--------------------------------------------------------------------------
