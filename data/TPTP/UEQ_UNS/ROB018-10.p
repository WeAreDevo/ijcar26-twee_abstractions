%------------------------------------------------------------------------------
% File     : ROB018-10 : TPTP v9.2.1. Released v7.5.0.
% Domain   : Puzzles
% Problem  : If -(d + e) = -e then e + 2(d + -(d + -e)) absorbs d + -(d + -e)
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.87 v9.1.0, 0.91 v8.2.0, 0.92 v8.1.0, 0.95 v7.5.0
% Syntax   : Number of clauses     :   11 (  11 unt;   0 nHn;   3 RR)
%            Number of literals    :   11 (  11 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    7 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   11 (  11 usr;   4 con; 0-4 aty)
%            Number of variables   :   17 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from ROB018-1 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(ifeq_axiom,axiom,
    ifeq2(A,A,B,C) = B ).

cnf(ifeq_axiom_001,axiom,
    ifeq(A,A,B,C) = B ).

cnf(commutativity_of_add,axiom,
    add(X,Y) = add(Y,X) ).

cnf(associativity_of_add,axiom,
    add(add(X,Y),Z) = add(X,add(Y,Z)) ).

cnf(robbins_axiom,axiom,
    negate(add(negate(add(X,Y)),negate(add(X,negate(Y))))) = X ).

cnf(one_times_x,axiom,
    multiply(one,X) = X ).

cnf(times_by_adding,axiom,
    ifeq2(positive_integer(X),true,add(X,multiply(V,X)),multiply(successor(V),X)) = multiply(successor(V),X) ).

cnf(one,axiom,
    positive_integer(one) = true ).

cnf(next_integer,axiom,
    ifeq(positive_integer(X),true,positive_integer(successor(X)),true) = true ).

cnf(condition,hypothesis,
    negate(add(d,negate(e))) = negate(e) ).

cnf(prove_result,negated_conjecture,
    add(e,multiply(successor(successor(one)),add(d,negate(add(d,negate(e)))))) != add(e,multiply(successor(one),add(d,negate(add(d,negate(e)))))) ).

%------------------------------------------------------------------------------
