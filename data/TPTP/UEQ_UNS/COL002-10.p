%------------------------------------------------------------------------------
% File     : COL002-10 : TPTP v9.2.1. Released v7.5.0.
% Domain   : Puzzles
% Problem  : Weak fixed point for S, B, C, and I
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.70 v9.1.0, 0.73 v8.2.0, 0.75 v8.1.0, 0.65 v7.5.0
% Syntax   : Number of clauses     :    7 (   7 unt;   0 nHn;   1 RR)
%            Number of literals    :    7 (   7 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    9 (   9 usr;   6 con; 0-4 aty)
%            Number of variables   :   15 (   1 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from COL002-2 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(ifeq_axiom,axiom,
    ifeq(A,A,B,C) = B ).

cnf(s_definition,axiom,
    apply(apply(apply(s,X),Y),Z) = apply(apply(X,Z),apply(Y,Z)) ).

cnf(b_definition,axiom,
    apply(apply(apply(b,X),Y),Z) = apply(X,apply(Y,Z)) ).

cnf(c_definition,axiom,
    apply(apply(apply(c,X),Y),Z) = apply(apply(X,Z),Y) ).

cnf(i_definition,axiom,
    apply(i,X) = X ).

cnf(weak_fixed_point,axiom,
    ifeq(Weak_sage,apply(fixed_pt,Weak_sage),fixed_point(Weak_sage),true) = true ).

cnf(prove_weak_fixed_point,negated_conjecture,
    fixed_point(apply(apply(apply(s,apply(b,X)),i),apply(apply(s,apply(b,X)),i))) != true ).

%------------------------------------------------------------------------------
