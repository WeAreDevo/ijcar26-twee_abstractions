%------------------------------------------------------------------------------
% File     : RNG029-10 : TPTP v9.2.1. Released v7.3.0.
% Domain   : Puzzles
% Problem  : Middle Moufang identity
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 1.00 v7.3.0
% Syntax   : Number of clauses     :   19 (  19 unt;   0 nHn;   2 RR)
%            Number of literals    :   19 (  19 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   4 con; 0-4 aty)
%            Number of variables   :   35 (   3 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from RNG029-1 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(ifeq_axiom,axiom,
    ifeq(A,A,B,C) = B ).

cnf(left_additive_identity,axiom,
    add(additive_identity,X) = X ).

cnf(left_multiplicative_zero,axiom,
    multiply(additive_identity,X) = additive_identity ).

cnf(right_multiplicative_zero,axiom,
    multiply(X,additive_identity) = additive_identity ).

cnf(add_inverse,axiom,
    add(additive_inverse(X),X) = additive_identity ).

cnf(sum_of_inverses,axiom,
    additive_inverse(add(X,Y)) = add(additive_inverse(X),additive_inverse(Y)) ).

cnf(additive_inverse_additive_inverse,axiom,
    additive_inverse(additive_inverse(X)) = X ).

cnf(multiply_over_add1,axiom,
    multiply(X,add(Y,Z)) = add(multiply(X,Y),multiply(X,Z)) ).

cnf(multiply_over_add2,axiom,
    multiply(add(X,Y),Z) = add(multiply(X,Z),multiply(Y,Z)) ).

cnf(right_alternative,axiom,
    multiply(multiply(X,Y),Y) = multiply(X,multiply(Y,Y)) ).

cnf(left_alternative,axiom,
    multiply(multiply(X,X),Y) = multiply(X,multiply(X,Y)) ).

cnf(inverse_product1,axiom,
    multiply(additive_inverse(X),Y) = additive_inverse(multiply(X,Y)) ).

cnf(inverse_product2,axiom,
    multiply(X,additive_inverse(Y)) = additive_inverse(multiply(X,Y)) ).

cnf(inverse_additive_identity,axiom,
    additive_inverse(additive_identity) = additive_identity ).

cnf(commutativity_for_addition,axiom,
    add(X,Y) = add(Y,X) ).

cnf(associativity_for_addition,axiom,
    add(X,add(Y,Z)) = add(add(X,Y),Z) ).

cnf(left_cancellation_for_addition,axiom,
    ifeq(add(X,Z),add(Y,Z),X,Y) = Y ).

cnf(right_cancellation_for_addition,axiom,
    ifeq(add(Z,X),add(Z,Y),X,Y) = Y ).

cnf(prove_middle_law,negated_conjecture,
    multiply(multiply(cx,cy),multiply(cz,cx)) != multiply(cx,multiply(multiply(cy,cz),cx)) ).

%------------------------------------------------------------------------------
