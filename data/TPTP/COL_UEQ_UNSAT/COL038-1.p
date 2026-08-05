%--------------------------------------------------------------------------
% File     : COL038-1 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Combinatory Logic
% Problem  : Strong fixed point for B, M, and V
% Version  : [WM88] (equality) axioms.
% English  : The strong fixed point property holds for the set
%            P consisting of the combinators B, M, and V, where ((Bx)y)z
%            = x(yz), Mx = xx, ((Vx)y)z = (zx)y.

% Refs     : [Smu85] Smullyan (1978), To Mock a Mocking Bird and Other Logi
%          : [MW87]  McCune & Wos (1987), A Case Study in Automated Theorem
%          : [WM88]  Wos & McCune (1988), Challenge Problems Focusing on Eq
%          : [MW88]  McCune & Wos (1988), Some Fixed Point Problems in Comb
% Source   : [MW88]
% Names    : - [MW88]

% Status   : Unsatisfiable
% Rating   : 0.70 v9.1.0, 0.77 v8.2.0, 0.79 v8.1.0, 0.80 v7.5.0, 0.83 v7.3.0, 0.84 v7.1.0, 0.83 v7.0.0, 0.74 v6.3.0, 0.76 v6.2.0, 0.79 v6.1.0, 0.81 v6.0.0, 0.76 v5.5.0, 0.74 v5.4.0, 0.73 v5.3.0, 0.75 v5.2.0, 0.71 v5.1.0, 0.67 v5.0.0, 0.64 v4.1.0, 0.55 v4.0.1, 0.64 v4.0.0, 0.62 v3.7.0, 0.33 v3.4.0, 0.50 v3.3.0, 0.57 v3.2.0, 0.64 v3.1.0, 0.78 v2.7.0, 0.64 v2.6.0, 0.17 v2.5.0, 0.50 v2.4.0, 0.00 v2.2.1, 0.56 v2.2.0, 0.43 v2.1.0, 0.88 v2.0.0
% Syntax   : Number of clauses     :    4 (   4 unt;   0 nHn;   1 RR)
%            Number of literals    :    4 (   4 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   3 con; 0-2 aty)
%            Number of variables   :    8 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
cnf(b_definition,axiom,
    apply(apply(apply(b,X),Y),Z) = apply(X,apply(Y,Z)) ).

cnf(m_definition,axiom,
    apply(m,X) = apply(X,X) ).

cnf(v_definition,axiom,
    apply(apply(apply(v,X),Y),Z) = apply(apply(Z,X),Y) ).

cnf(prove_fixed_point,negated_conjecture,
    apply(Y,f(Y)) != apply(f(Y),apply(Y,f(Y))) ).

%--------------------------------------------------------------------------
