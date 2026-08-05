%------------------------------------------------------------------------------
% File     : GRP048-10 : TPTP v9.2.1. Released v7.5.0.
% Domain   : Puzzles
% Problem  : Inverse substitution is dependent
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.39 v9.1.0, 0.45 v8.2.0, 0.42 v8.1.0, 0.35 v7.5.0
% Syntax   : Number of clauses     :   10 (  10 unt;   0 nHn;   2 RR)
%            Number of literals    :   10 (  10 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   1 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    9 (   9 usr;   4 con; 0-4 aty)
%            Number of variables   :   27 (   1 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from GRP048-2 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(ifeq_axiom,axiom,
    ifeq(A,A,B,C) = B ).

cnf(left_identity,axiom,
    product(identity,X,X) = true ).

cnf(left_inverse,axiom,
    product(inverse(X),X,identity) = true ).

cnf(total_function1,axiom,
    product(X,Y,multiply(X,Y)) = true ).

cnf(total_function2,axiom,
    ifeq(product(X,Y,W),true,ifeq(product(X,Y,Z),true,equalish(Z,W),true),true) = true ).

cnf(associativity1,axiom,
    ifeq(product(U,Z,W),true,ifeq(product(Y,Z,V),true,ifeq(product(X,Y,U),true,product(X,V,W),true),true),true) = true ).

cnf(associativity2,axiom,
    ifeq(product(Y,Z,V),true,ifeq(product(X,V,W),true,ifeq(product(X,Y,U),true,product(U,Z,W),true),true),true) = true ).

cnf(product_substitution3,axiom,
    ifeq(equalish(X,Y),true,ifeq(product(W,Z,X),true,product(W,Z,Y),true),true) = true ).

cnf(a_equals_b,hypothesis,
    equalish(a,b) = true ).

cnf(prove_inverse_substitution,negated_conjecture,
    equalish(inverse(a),inverse(b)) != true ).

%------------------------------------------------------------------------------
