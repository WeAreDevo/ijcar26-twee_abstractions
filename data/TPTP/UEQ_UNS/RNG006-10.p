%------------------------------------------------------------------------------
% File     : RNG006-10 : TPTP v9.2.1. Released v7.3.0.
% Domain   : Puzzles
% Problem  : X*(Y+ -Z) = (X*Y) + -(X*Z)
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.74 v9.1.0, 0.73 v8.2.0, 0.67 v8.1.0, 0.75 v7.5.0, 0.83 v7.3.0
% Syntax   : Number of clauses     :   24 (  24 unt;   0 nHn;   5 RR)
%            Number of literals    :   24 (  24 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   1 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   16 (  16 usr;   9 con; 0-4 aty)
%            Number of variables   :   77 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from RNG006-3 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(ifeq_axiom,axiom,
    ifeq2(A,A,B,C) = B ).

cnf(ifeq_axiom_001,axiom,
    ifeq(A,A,B,C) = B ).

cnf(additive_identity1,axiom,
    sum(additive_identity,X,X) = true ).

cnf(additive_identity2,axiom,
    sum(X,additive_identity,X) = true ).

cnf(closure_of_multiplication,axiom,
    product(X,Y,multiply(X,Y)) = true ).

cnf(closure_of_addition,axiom,
    sum(X,Y,add(X,Y)) = true ).

cnf(left_inverse,axiom,
    sum(additive_inverse(X),X,additive_identity) = true ).

cnf(right_inverse,axiom,
    sum(X,additive_inverse(X),additive_identity) = true ).

cnf(associativity_of_addition1,axiom,
    ifeq(sum(U,Z,W),true,ifeq(sum(Y,Z,V),true,ifeq(sum(X,Y,U),true,sum(X,V,W),true),true),true) = true ).

cnf(associativity_of_addition2,axiom,
    ifeq(sum(Y,Z,V),true,ifeq(sum(X,V,W),true,ifeq(sum(X,Y,U),true,sum(U,Z,W),true),true),true) = true ).

cnf(commutativity_of_addition,axiom,
    ifeq(sum(X,Y,Z),true,sum(Y,X,Z),true) = true ).

cnf(associativity_of_multiplication1,axiom,
    ifeq(product(U,Z,W),true,ifeq(product(Y,Z,V),true,ifeq(product(X,Y,U),true,product(X,V,W),true),true),true) = true ).

cnf(associativity_of_multiplication2,axiom,
    ifeq(product(Y,Z,V),true,ifeq(product(X,V,W),true,ifeq(product(X,Y,U),true,product(U,Z,W),true),true),true) = true ).

cnf(distributivity1,axiom,
    ifeq(product(X,V3,V4),true,ifeq(product(X,Z,V2),true,ifeq(product(X,Y,V1),true,ifeq(sum(Y,Z,V3),true,sum(V1,V2,V4),true),true),true),true) = true ).

cnf(distributivity2,axiom,
    ifeq(product(X,Z,V2),true,ifeq(product(X,Y,V1),true,ifeq(sum(V1,V2,V4),true,ifeq(sum(Y,Z,V3),true,product(X,V3,V4),true),true),true),true) = true ).

cnf(distributivity3,axiom,
    ifeq(product(V3,X,V4),true,ifeq(product(Z,X,V2),true,ifeq(product(Y,X,V1),true,ifeq(sum(Y,Z,V3),true,sum(V1,V2,V4),true),true),true),true) = true ).

cnf(distributivity4,axiom,
    ifeq(product(Z,X,V2),true,ifeq(product(Y,X,V1),true,ifeq(sum(V1,V2,V4),true,ifeq(sum(Y,Z,V3),true,product(V3,X,V4),true),true),true),true) = true ).

cnf(addition_is_well_defined,axiom,
    ifeq2(sum(X,Y,V),true,ifeq2(sum(X,Y,U),true,U,V),V) = V ).

cnf(multiplication_is_well_defined,axiom,
    ifeq2(product(X,Y,V),true,ifeq2(product(X,Y,U),true,U,V),V) = V ).

cnf(b_plus_inverse_c,hypothesis,
    sum(b,additive_inverse(c),bS_Ic) = true ).

cnf(a_times_b,hypothesis,
    product(a,b,aPb) = true ).

cnf(a_times_c,hypothesis,
    product(a,c,aPc) = true ).

cnf(aPb_plus_IaPc,hypothesis,
    sum(aPb,additive_inverse(aPc),aPb_S_IaPc) = true ).

cnf(prove_a_times_bS_Ic_is_aPb_S__IaPc,negated_conjecture,
    product(a,bS_Ic,aPb_S_IaPc) != true ).

%------------------------------------------------------------------------------
