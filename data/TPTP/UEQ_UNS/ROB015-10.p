%------------------------------------------------------------------------------
% File     : ROB015-10 : TPTP v9.2.1. Released v7.5.0.
% Domain   : Puzzles
% Problem  : If -(-e + -(d + -e)) = d then -(e + k(d + -(d + -e))) = -e
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.61 v9.1.0, 0.64 v9.0.0, 0.68 v8.2.0, 0.71 v8.1.0, 0.65 v7.5.0
% Syntax   : Number of clauses     :   18 (  18 unt;   0 nHn;   6 RR)
%            Number of literals    :   18 (  18 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    9 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   16 (  16 usr;   7 con; 0-4 aty)
%            Number of variables   :   30 (   4 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from ROB015-2 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(ifeq_axiom,axiom,
    ifeq4(A,A,B,C) = B ).

cnf(ifeq_axiom_001,axiom,
    ifeq3(A,A,B,C) = B ).

cnf(ifeq_axiom_002,axiom,
    ifeq2(A,A,B,C) = B ).

cnf(ifeq_axiom_003,axiom,
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

cnf(lemma_3_2,axiom,
    ifeq4(negate(add(X,negate(add(Y,Z)))),negate(add(Y,negate(add(X,Z)))),X,Y) = Y ).

cnf(lemma_3_4,axiom,
    ifeq2(positive_integer(Vk),true,ifeq4(negate(add(X,negate(Y))),Z,negate(add(X,negate(add(Y,multiply(Vk,add(X,Z)))))),Z),Z) = Z ).

cnf(condition,hypothesis,
    negate(add(negate(e),negate(add(d,negate(e))))) = d ).

cnf(k_positive,axiom,
    positive_integer(k) = true ).

cnf(base_step,axiom,
    ifeq3(negate(add(e,multiply(k,add(d,negate(add(d,negate(e))))))),negate(e),a,b) = b ).

cnf(prove_induction_step,negated_conjecture,
    ifeq3(negate(add(e,multiply(successor(k),add(d,negate(add(d,negate(e))))))),negate(e),a,b) = b ).

cnf(goal,negated_conjecture,
    a != b ).

%------------------------------------------------------------------------------
