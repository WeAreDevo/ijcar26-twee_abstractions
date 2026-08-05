%------------------------------------------------------------------------------
% File     : LCL042-10 : TPTP v9.2.1. Released v7.5.0.
% Domain   : Puzzles
% Problem  : CN-35 depends on Hilbert's system
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.83 v9.1.0, 0.86 v8.2.0, 0.92 v8.1.0, 1.00 v7.5.0
% Syntax   : Number of clauses     :    8 (   8 unt;   0 nHn;   1 RR)
%            Number of literals    :    8 (   8 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   4 con; 0-4 aty)
%            Number of variables   :   17 (   3 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from LCL042-1 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(ifeq_axiom,axiom,
    ifeq(A,A,B,C) = B ).

cnf(condensed_detachment,axiom,
    ifeq(is_a_theorem(implies(X,Y)),true,ifeq(is_a_theorem(X),true,is_a_theorem(Y),true),true) = true ).

cnf(cn_3,axiom,
    is_a_theorem(implies(X,implies(not(X),Y))) = true ).

cnf(cn_18,axiom,
    is_a_theorem(implies(X,implies(Y,X))) = true ).

cnf(cn_21,axiom,
    is_a_theorem(implies(implies(X,implies(Y,Z)),implies(Y,implies(X,Z)))) = true ).

cnf(cn_22,axiom,
    is_a_theorem(implies(implies(Y,Z),implies(implies(X,Y),implies(X,Z)))) = true ).

cnf(cn_54,axiom,
    is_a_theorem(implies(implies(X,Y),implies(implies(not(X),Y),Y))) = true ).

cnf(prove_cn_35,negated_conjecture,
    is_a_theorem(implies(implies(a,implies(b,c)),implies(implies(a,b),implies(a,c)))) != true ).

%------------------------------------------------------------------------------
