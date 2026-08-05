%------------------------------------------------------------------------------
% File     : LCL348-10 : TPTP v9.2.1. Released v7.3.0.
% Domain   : Puzzles
% Problem  : Principia Mathematica 5.62
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.96 v9.1.0, 1.00 v7.3.0
% Syntax   : Number of clauses     :   12 (  12 unt;   0 nHn;   1 RR)
%            Number of literals    :   12 (  12 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   11 (  11 usr;   3 con; 0-4 aty)
%            Number of variables   :   23 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from LCL348-3 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(ifeq_axiom,axiom,
    ifeq(A,A,B,C) = B ).

cnf(axiom_1_2,axiom,
    axiom(implies(or(A,A),A)) = true ).

cnf(axiom_1_3,axiom,
    axiom(implies(A,or(B,A))) = true ).

cnf(axiom_1_4,axiom,
    axiom(implies(or(A,B),or(B,A))) = true ).

cnf(axiom_1_5,axiom,
    axiom(implies(or(A,or(B,C)),or(B,or(A,C)))) = true ).

cnf(axiom_1_6,axiom,
    axiom(implies(implies(A,B),implies(or(C,A),or(C,B)))) = true ).

cnf(implies_definition,axiom,
    implies(X,Y) = or(not(X),Y) ).

cnf(rule_1,axiom,
    ifeq(axiom(X),true,theorem(X),true) = true ).

cnf(rule_2,axiom,
    ifeq(theorem(implies(Y,X)),true,ifeq(theorem(Y),true,theorem(X),true),true) = true ).

cnf(and_defn,axiom,
    and(P,Q) = not(or(not(P),not(Q))) ).

cnf(equivalent_defn,axiom,
    equivalent(P,Q) = and(implies(P,Q),implies(Q,P)) ).

cnf(prove_this,negated_conjecture,
    theorem(equivalent(or(and(p,q),not(q)),or(p,not(q)))) != true ).

%------------------------------------------------------------------------------
