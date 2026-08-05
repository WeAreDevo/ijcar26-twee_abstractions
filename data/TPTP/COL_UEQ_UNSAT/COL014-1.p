%--------------------------------------------------------------------------
% File     : COL014-1 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Combinatory Logic
% Problem  : Weak fixed point for L and O
% Version  : [WM88] (equality) axioms.
% English  : The weak fixed point property holds for the set P consisting
%            of the combinators L and O, where (Lx)y = x(yy), (Ox)y
%            = y(xy).

% Refs     : [Smu85] Smullyan (1978), To Mock a Mocking Bird and Other Logi
%          : [MW87]  McCune & Wos (1987), A Case Study in Automated Theorem
%          : [WM88]  Wos & McCune (1988), Challenge Problems Focusing on Eq
%          : [MW88]  McCune & Wos (1988), Some Fixed Point Problems in Comb
% Source   : [MW88]
% Names    : - [MW88]

% Status   : Unsatisfiable
% Rating   : 0.04 v9.1.0, 0.09 v9.0.0, 0.05 v8.2.0, 0.04 v8.1.0, 0.10 v7.5.0, 0.08 v7.4.0, 0.17 v7.3.0, 0.11 v7.1.0, 0.06 v7.0.0, 0.00 v6.4.0, 0.11 v6.3.0, 0.12 v6.2.0, 0.07 v6.1.0, 0.00 v6.0.0, 0.05 v5.5.0, 0.00 v2.0.0
% Syntax   : Number of clauses     :    3 (   3 unt;   0 nHn;   1 RR)
%            Number of literals    :    3 (   3 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    4 (   4 usr;   3 con; 0-2 aty)
%            Number of variables   :    5 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
cnf(l_definition,axiom,
    apply(apply(l,X),Y) = apply(X,apply(Y,Y)) ).

cnf(o_definition,axiom,
    apply(apply(o,X),Y) = apply(Y,apply(X,Y)) ).

cnf(prove_fixed_point,negated_conjecture,
    Y != apply(combinator,Y) ).

%--------------------------------------------------------------------------
