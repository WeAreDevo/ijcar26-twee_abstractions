%------------------------------------------------------------------------------
% File     : COL042-10 : TPTP v9.2.1. Released v7.3.0.
% Domain   : Puzzles
% Problem  : Strong fixed point for B and W1
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.83 v9.1.0, 0.82 v8.2.0, 0.88 v8.1.0, 0.90 v7.5.0, 0.92 v7.4.0, 0.91 v7.3.0
% Syntax   : Number of clauses     :    5 (   5 unt;   0 nHn;   1 RR)
%            Number of literals    :    5 (   5 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    8 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   4 con; 0-4 aty)
%            Number of variables   :    9 (   1 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from COL042-4 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(ifeq_axiom,axiom,
    ifeq(A,A,B,C) = B ).

cnf(b_definition,axiom,
    apply(apply(apply(b,X),Y),Z) = apply(X,apply(Y,Z)) ).

cnf(w1_definition,axiom,
    apply(apply(w1,X),Y) = apply(apply(Y,X),X) ).

cnf(strong_fixed_point,axiom,
    ifeq(apply(Strong_fixed_point,fixed_pt),apply(fixed_pt,apply(Strong_fixed_point,fixed_pt)),fixed_point(Strong_fixed_point),true) = true ).

cnf(prove_strong_fixed_point,negated_conjecture,
    fixed_point(apply(apply(b,apply(apply(b,apply(w1,w1)),apply(apply(b,apply(b,w1)),b))),b)) != true ).

%------------------------------------------------------------------------------
