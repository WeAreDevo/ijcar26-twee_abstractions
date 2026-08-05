%------------------------------------------------------------------------------
% File     : BOO004-10 : TPTP v9.2.1. Released v7.5.0.
% Domain   : Puzzles
% Problem  : Addition is idempotent (X + X = X)
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.22 v9.1.0, 0.27 v8.2.0, 0.21 v8.1.0, 0.20 v7.5.0
% Syntax   : Number of clauses     :   25 (  25 unt;   0 nHn;   1 RR)
%            Number of literals    :   25 (  25 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   11 (  11 usr;   4 con; 0-4 aty)
%            Number of variables   :   88 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from BOO004-1 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(ifeq_axiom,axiom,
    ifeq2(A,A,B,C) = B ).

cnf(ifeq_axiom_001,axiom,
    ifeq(A,A,B,C) = B ).

cnf(closure_of_addition,axiom,
    sum(X,Y,add(X,Y)) = true ).

cnf(closure_of_multiplication,axiom,
    product(X,Y,multiply(X,Y)) = true ).

cnf(commutativity_of_addition,axiom,
    ifeq(sum(X,Y,Z),true,sum(Y,X,Z),true) = true ).

cnf(commutativity_of_multiplication,axiom,
    ifeq(product(X,Y,Z),true,product(Y,X,Z),true) = true ).

cnf(additive_identity1,axiom,
    sum(additive_identity,X,X) = true ).

cnf(additive_identity2,axiom,
    sum(X,additive_identity,X) = true ).

cnf(multiplicative_identity1,axiom,
    product(multiplicative_identity,X,X) = true ).

cnf(multiplicative_identity2,axiom,
    product(X,multiplicative_identity,X) = true ).

cnf(distributivity1,axiom,
    ifeq(product(X,V3,V4),true,ifeq(product(X,Z,V2),true,ifeq(product(X,Y,V1),true,ifeq(sum(Y,Z,V3),true,sum(V1,V2,V4),true),true),true),true) = true ).

cnf(distributivity2,axiom,
    ifeq(product(X,Z,V2),true,ifeq(product(X,Y,V1),true,ifeq(sum(V1,V2,V4),true,ifeq(sum(Y,Z,V3),true,product(X,V3,V4),true),true),true),true) = true ).

cnf(distributivity3,axiom,
    ifeq(product(V3,X,V4),true,ifeq(product(Z,X,V2),true,ifeq(product(Y,X,V1),true,ifeq(sum(Y,Z,V3),true,sum(V1,V2,V4),true),true),true),true) = true ).

cnf(distributivity4,axiom,
    ifeq(product(Z,X,V2),true,ifeq(product(Y,X,V1),true,ifeq(sum(V1,V2,V4),true,ifeq(sum(Y,Z,V3),true,product(V3,X,V4),true),true),true),true) = true ).

cnf(distributivity5,axiom,
    ifeq(product(Y,Z,V3),true,ifeq(sum(X,V3,V4),true,ifeq(sum(X,Z,V2),true,ifeq(sum(X,Y,V1),true,product(V1,V2,V4),true),true),true),true) = true ).

cnf(distributivity6,axiom,
    ifeq(product(V1,V2,V4),true,ifeq(product(Y,Z,V3),true,ifeq(sum(X,Z,V2),true,ifeq(sum(X,Y,V1),true,sum(X,V3,V4),true),true),true),true) = true ).

cnf(distributivity7,axiom,
    ifeq(product(Y,Z,V3),true,ifeq(sum(V3,X,V4),true,ifeq(sum(Z,X,V2),true,ifeq(sum(Y,X,V1),true,product(V1,V2,V4),true),true),true),true) = true ).

cnf(distributivity8,axiom,
    ifeq(product(V1,V2,V4),true,ifeq(product(Y,Z,V3),true,ifeq(sum(Z,X,V2),true,ifeq(sum(Y,X,V1),true,sum(V3,X,V4),true),true),true),true) = true ).

cnf(additive_inverse1,axiom,
    sum(inverse(X),X,multiplicative_identity) = true ).

cnf(additive_inverse2,axiom,
    sum(X,inverse(X),multiplicative_identity) = true ).

cnf(multiplicative_inverse1,axiom,
    product(inverse(X),X,additive_identity) = true ).

cnf(multiplicative_inverse2,axiom,
    product(X,inverse(X),additive_identity) = true ).

cnf(addition_is_well_defined,axiom,
    ifeq2(sum(X,Y,V),true,ifeq2(sum(X,Y,U),true,U,V),V) = V ).

cnf(multiplication_is_well_defined,axiom,
    ifeq2(product(X,Y,V),true,ifeq2(product(X,Y,U),true,U,V),V) = V ).

cnf(prove_both_equalities,negated_conjecture,
    sum(x,x,x) != true ).

%------------------------------------------------------------------------------
