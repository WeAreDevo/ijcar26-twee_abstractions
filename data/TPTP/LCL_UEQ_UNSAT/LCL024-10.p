%------------------------------------------------------------------------------
% File     : LCL024-10 : TPTP v9.2.1. Released v7.5.0.
% Domain   : Puzzles
% Problem  : PYO depends on XGK
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.48 v9.1.0, 0.50 v9.0.0, 0.45 v8.2.0, 0.50 v8.1.0, 0.55 v7.5.0
% Syntax   : Number of clauses     :    4 (   4 unt;   0 nHn;   1 RR)
%            Number of literals    :    4 (   4 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   4 con; 0-4 aty)
%            Number of variables   :    8 (   1 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from LCL024-1 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(ifeq_axiom,axiom,
    ifeq(A,A,B,C) = B ).

cnf(condensed_detachment,axiom,
    ifeq(is_a_theorem(equivalent(X,Y)),true,ifeq(is_a_theorem(X),true,is_a_theorem(Y),true),true) = true ).

cnf(xgk,axiom,
    is_a_theorem(equivalent(X,equivalent(equivalent(Y,equivalent(Z,X)),equivalent(Z,Y)))) = true ).

cnf(prove_pyo,negated_conjecture,
    is_a_theorem(equivalent(equivalent(equivalent(a,equivalent(b,c)),c),equivalent(b,a))) != true ).

%------------------------------------------------------------------------------
