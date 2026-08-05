%------------------------------------------------------------------------------
% File     : LCL148-10 : TPTP v9.2.1. Released v7.3.0.
% Domain   : Puzzles
% Problem  : A theorem in the lattice structure of Wajsberg algebras
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.96 v9.1.0, 0.95 v8.2.0, 0.96 v8.1.0, 1.00 v7.5.0, 0.92 v7.4.0, 0.91 v7.3.0
% Syntax   : Number of clauses     :   11 (  11 unt;   0 nHn;   1 RR)
%            Number of literals    :   11 (  11 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   12 (  12 usr;   5 con; 0-4 aty)
%            Number of variables   :   22 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from LCL148-1 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(ifeq_axiom,axiom,
    ifeq2(A,A,B,C) = B ).

cnf(ifeq_axiom_001,axiom,
    ifeq(A,A,B,C) = B ).

cnf(wajsberg_1,axiom,
    implies(truth,X) = X ).

cnf(wajsberg_2,axiom,
    implies(implies(X,Y),implies(implies(Y,Z),implies(X,Z))) = truth ).

cnf(wajsberg_3,axiom,
    implies(implies(X,Y),Y) = implies(implies(Y,X),X) ).

cnf(wajsberg_4,axiom,
    implies(implies(not(X),not(Y)),implies(Y,X)) = truth ).

cnf(big_V_definition,axiom,
    big_V(X,Y) = implies(implies(X,Y),Y) ).

cnf(big_hat_definition,axiom,
    big_hat(X,Y) = not(big_V(not(X),not(Y))) ).

cnf(partial_order_definition1,axiom,
    ifeq(ordered(X,Y),true,implies(X,Y),truth) = truth ).

cnf(partial_order_definition2,axiom,
    ifeq2(implies(X,Y),truth,ordered(X,Y),true) = true ).

cnf(prove_wajsberg_theorem,negated_conjecture,
    implies(x,big_hat(y,z)) != big_hat(implies(x,y),implies(x,z)) ).

%------------------------------------------------------------------------------
