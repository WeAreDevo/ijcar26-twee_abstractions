%--------------------------------------------------------------------------
% File     : COL057-1 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Combinatory Logic
% Problem  : Strong fixed point for S, B, C, and I
% Version  : [WM88] (equality) axioms.
% English  : The strong fixed point property holds for the set
%            P consisting of the combinators S, B, C, and I, where
%            ((Sx)y)z = (xz)(yz), ((Bx)y)z = x(yz), ((Cx)y)z = (xz)y, and
%            Ix = x.

% Refs     : [LW92]  Lusk & Wos (1992), Benchmark Problems in Which Equalit
% Source   : [LW92]
% Names    : CL5 [LW92]

% Status   : Unsatisfiable
% Rating   : 0.26 v9.1.0, 0.32 v8.2.0, 0.38 v8.1.0, 0.35 v7.5.0, 0.42 v7.4.0, 0.48 v7.3.0, 0.47 v7.1.0, 0.39 v7.0.0, 0.37 v6.4.0, 0.42 v6.3.0, 0.41 v6.2.0, 0.43 v6.1.0, 0.44 v6.0.0, 0.48 v5.5.0, 0.47 v5.4.0, 0.53 v5.3.0, 0.58 v5.2.0, 0.50 v5.1.0, 0.47 v5.0.0, 0.43 v4.1.0, 0.36 v4.0.1, 0.50 v4.0.0, 0.54 v3.7.0, 0.22 v3.4.0, 0.25 v3.3.0, 0.36 v3.1.0, 0.56 v2.7.0, 0.27 v2.6.0, 0.17 v2.5.0, 0.00 v2.1.0, 0.25 v2.0.0
% Syntax   : Number of clauses     :    5 (   5 unt;   0 nHn;   1 RR)
%            Number of literals    :    5 (   5 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   4 con; 0-2 aty)
%            Number of variables   :   11 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
cnf(s_definition,axiom,
    apply(apply(apply(s,X),Y),Z) = apply(apply(X,Z),apply(Y,Z)) ).

cnf(b_definition,axiom,
    apply(apply(apply(b,X),Y),Z) = apply(X,apply(Y,Z)) ).

cnf(c_definition,axiom,
    apply(apply(apply(c,X),Y),Z) = apply(apply(X,Z),Y) ).

cnf(i_definition,axiom,
    apply(i,X) = X ).

cnf(prove_strong_fixed_point,negated_conjecture,
    apply(Y,f(Y)) != apply(f(Y),apply(Y,f(Y))) ).

%--------------------------------------------------------------------------
