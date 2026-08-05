%------------------------------------------------------------------------------
% File     : COL044-10 : TPTP v9.2.1. Released v7.5.0.
% Domain   : Puzzles
% Problem  : Strong fixed point for B and N
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.83 v9.1.0, 0.86 v8.2.0, 0.92 v8.1.0, 0.95 v7.5.0
% Syntax   : Number of clauses     :    5 (   5 unt;   0 nHn;   1 RR)
%            Number of literals    :    5 (   5 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :   13 (   3 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   4 con; 0-4 aty)
%            Number of variables   :   10 (   1 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from COL044-3 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(ifeq_axiom,axiom,
    ifeq(A,A,B,C) = B ).

cnf(b_definition,axiom,
    apply(apply(apply(b,X),Y),Z) = apply(X,apply(Y,Z)) ).

cnf(n_definition,axiom,
    apply(apply(apply(n,X),Y),Z) = apply(apply(apply(X,Z),Y),Z) ).

cnf(strong_fixed_point,axiom,
    ifeq(apply(Strong_fixed_point,fixed_pt),apply(fixed_pt,apply(Strong_fixed_point,fixed_pt)),fixed_point(Strong_fixed_point),true) = true ).

cnf(prove_strong_fixed_point,negated_conjecture,
    fixed_point(apply(apply(b,apply(apply(b,apply(apply(n,apply(apply(b,b),apply(apply(n,apply(n,apply(b,b))),n))),n)),b)),b)) != true ).

%------------------------------------------------------------------------------
