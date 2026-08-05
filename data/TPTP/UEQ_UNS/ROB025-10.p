%------------------------------------------------------------------------------
% File     : ROB025-10 : TPTP v9.2.1. Released v7.3.0.
% Domain   : Robbins Algebra
% Problem  : -(X + Y) = intersection(-X,-Y) => Boolean
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 1.00 v7.3.0
% Syntax   : Number of clauses     :   12 (  12 unt;   0 nHn;   1 RR)
%            Number of literals    :   12 (  12 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    7 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   3 con; 0-4 aty)
%            Number of variables   :   26 (   1 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from ROB025-1 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(ifeq_axiom,axiom,
    ifeq(A,A,B,C) = B ).

cnf(reflexivity,axiom,
    equalish(X,X) = true ).

cnf(symmetry,axiom,
    ifeq(equalish(X,Y),true,equalish(Y,X),true) = true ).

cnf(transitivity,axiom,
    ifeq(equalish(Y,Z),true,ifeq(equalish(X,Y),true,equalish(X,Z),true),true) = true ).

cnf(add_substitution1,axiom,
    ifeq(equalish(A,B),true,equalish(add(A,C),add(B,C)),true) = true ).

cnf(add_substitution2,axiom,
    ifeq(equalish(D,E),true,equalish(add(F,D),add(F,E)),true) = true ).

cnf(inverse_substitution1,axiom,
    ifeq(equalish(G,H),true,equalish(negate(G),negate(H)),true) = true ).

cnf(commutativity_of_add,axiom,
    equalish(add(X,Y),add(Y,X)) = true ).

cnf(associativity_of_add,axiom,
    equalish(add(add(X,Y),Z),add(X,add(Y,Z))) = true ).

cnf(robbins_axiom,axiom,
    equalish(negate(add(negate(add(X,Y)),negate(add(X,negate(Y))))),X) = true ).

cnf(the_condition,hypothesis,
    equalish(negate(add(X,Y)),intersect(negate(X),negate(Y))) = true ).

cnf(prove_huntingtons_axiom,negated_conjecture,
    equalish(add(negate(add(a,negate(b))),negate(add(negate(a),negate(b)))),b) != true ).

%------------------------------------------------------------------------------
