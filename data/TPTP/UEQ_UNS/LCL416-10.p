%------------------------------------------------------------------------------
% File     : LCL416-10 : TPTP v9.2.1. Released v7.3.0.
% Domain   : Puzzles
% Problem  : Prove reflexivity from formula XCB by condensed detachment
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.43 v9.1.0, 0.41 v8.2.0, 0.46 v8.1.0, 0.50 v7.5.0, 0.54 v7.4.0, 0.57 v7.3.0
% Syntax   : Number of clauses     :    4 (   4 unt;   0 nHn;   1 RR)
%            Number of literals    :    4 (   4 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   2 con; 0-4 aty)
%            Number of variables   :    8 (   1 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from LCL416-1 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(ifeq_axiom,axiom,
    ifeq(A,A,B,C) = B ).

cnf(condensed_detachment,axiom,
    ifeq(is_a_theorem(equivalent(A,B)),true,ifeq(is_a_theorem(A),true,is_a_theorem(B),true),true) = true ).

cnf(xcb,axiom,
    is_a_theorem(equivalent(A,equivalent(equivalent(equivalent(A,B),equivalent(C,B)),C))) = true ).

cnf(prove_reflexivity,negated_conjecture,
    is_a_theorem(equivalent(a,a)) != true ).

%------------------------------------------------------------------------------
