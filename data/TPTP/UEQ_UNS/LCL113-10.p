%------------------------------------------------------------------------------
% File     : LCL113-10 : TPTP v9.2.1. Released v7.3.0.
% Domain   : Puzzles
% Problem  : MV-33 depnds on the Meredith system
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.52 v9.1.0, 0.59 v9.0.0, 0.55 v8.2.0, 0.58 v8.1.0, 0.50 v7.5.0, 0.58 v7.4.0, 0.65 v7.3.0
% Syntax   : Number of clauses     :    7 (   7 unt;   0 nHn;   1 RR)
%            Number of literals    :    7 (   7 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   3 con; 0-4 aty)
%            Number of variables   :   14 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from LCL113-1 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(ifeq_axiom,axiom,
    ifeq(A,A,B,C) = B ).

cnf(condensed_detachment,axiom,
    ifeq(is_a_theorem(implies(X,Y)),true,ifeq(is_a_theorem(X),true,is_a_theorem(Y),true),true) = true ).

cnf(mv_1,axiom,
    is_a_theorem(implies(X,implies(Y,X))) = true ).

cnf(mv_2,axiom,
    is_a_theorem(implies(implies(X,Y),implies(implies(Y,Z),implies(X,Z)))) = true ).

cnf(mv_3,axiom,
    is_a_theorem(implies(implies(implies(X,Y),Y),implies(implies(Y,X),X))) = true ).

cnf(mv_5,axiom,
    is_a_theorem(implies(implies(not(X),not(Y)),implies(Y,X))) = true ).

cnf(prove_mv_33,negated_conjecture,
    is_a_theorem(implies(implies(not(a),b),implies(not(b),a))) != true ).

%------------------------------------------------------------------------------
