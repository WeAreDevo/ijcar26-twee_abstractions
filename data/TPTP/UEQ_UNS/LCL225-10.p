%------------------------------------------------------------------------------
% File     : LCL225-10 : TPTP v9.2.1. Released v7.3.0.
% Domain   : Puzzles
% Problem  : Principia Mathematica 2.77
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.96 v9.1.0, 0.95 v8.2.0, 0.96 v8.1.0, 1.00 v7.3.0
% Syntax   : Number of clauses     :   10 (  10 unt;   0 nHn;   1 RR)
%            Number of literals    :   10 (  10 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    7 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    9 (   9 usr;   4 con; 0-4 aty)
%            Number of variables   :   20 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from LCL225-1 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(ifeq_axiom,axiom,
    ifeq(A,A,B,C) = B ).

cnf(axiom_1_2,axiom,
    axiom(or(not(or(A,A)),A)) = true ).

cnf(axiom_1_3,axiom,
    axiom(or(not(A),or(B,A))) = true ).

cnf(axiom_1_4,axiom,
    axiom(or(not(or(A,B)),or(B,A))) = true ).

cnf(axiom_1_5,axiom,
    axiom(or(not(or(A,or(B,C))),or(B,or(A,C)))) = true ).

cnf(axiom_1_6,axiom,
    axiom(or(not(or(not(A),B)),or(not(or(C,A)),or(C,B)))) = true ).

cnf(rule_1,axiom,
    ifeq(axiom(X),true,theorem(X),true) = true ).

cnf(rule_2,axiom,
    ifeq(theorem(Y),true,ifeq(axiom(or(not(Y),X)),true,theorem(X),true),true) = true ).

cnf(rule_3,axiom,
    ifeq(theorem(or(not(Y),Z)),true,ifeq(axiom(or(not(X),Y)),true,theorem(or(not(X),Z)),true),true) = true ).

cnf(prove_this,negated_conjecture,
    theorem(or(not(or(not(p),or(not(q),r))),or(not(or(not(p),q)),or(not(p),r)))) != true ).

%------------------------------------------------------------------------------
