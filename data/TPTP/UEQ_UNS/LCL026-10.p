%------------------------------------------------------------------------------
% File     : LCL026-10 : TPTP v9.2.1. Released v7.3.0.
% Domain   : Puzzles
% Problem  : C0-3 depends on the Church system
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.26 v9.1.0, 0.27 v9.0.0, 0.32 v8.2.0, 0.42 v8.1.0, 0.35 v7.5.0, 0.46 v7.4.0, 0.48 v7.3.0
% Syntax   : Number of clauses     :    6 (   6 unt;   0 nHn;   1 RR)
%            Number of literals    :    6 (   6 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   4 con; 0-4 aty)
%            Number of variables   :   11 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from LCL026-1 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(ifeq_axiom,axiom,
    ifeq(A,A,B,C) = B ).

cnf(condensed_detachment,axiom,
    ifeq(is_a_theorem(implies(X,Y)),true,ifeq(is_a_theorem(X),true,is_a_theorem(Y),true),true) = true ).

cnf(c0_2,axiom,
    is_a_theorem(implies(X,implies(Y,X))) = true ).

cnf(c0_5,axiom,
    is_a_theorem(implies(implies(implies(X,falsehood),falsehood),X)) = true ).

cnf(c0_6,axiom,
    is_a_theorem(implies(implies(X,implies(Y,Z)),implies(implies(X,Y),implies(X,Z)))) = true ).

cnf(prove_c0_3,negated_conjecture,
    is_a_theorem(implies(implies(implies(a,b),a),a)) != true ).

%------------------------------------------------------------------------------
