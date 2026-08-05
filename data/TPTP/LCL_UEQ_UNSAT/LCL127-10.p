%------------------------------------------------------------------------------
% File     : LCL127-10 : TPTP v9.2.1. Released v7.5.0.
% Domain   : Puzzles
% Problem  : LG-2 depends on S-2
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.78 v9.1.0, 0.73 v8.2.0, 0.71 v8.1.0, 0.75 v7.5.0
% Syntax   : Number of clauses     :    4 (   4 unt;   0 nHn;   1 RR)
%            Number of literals    :    4 (   4 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    7 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   5 con; 0-4 aty)
%            Number of variables   :    9 (   1 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from LCL127-1 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(ifeq_axiom,axiom,
    ifeq(A,A,B,C) = B ).

cnf(condensed_detachment,axiom,
    ifeq(is_a_theorem(equivalent(X,Y)),true,ifeq(is_a_theorem(X),true,is_a_theorem(Y),true),true) = true ).

cnf(s_2,axiom,
    is_a_theorem(equivalent(equivalent(X,equivalent(Y,Z)),equivalent(X,equivalent(equivalent(Y,U),equivalent(Z,U))))) = true ).

cnf(prove_lg_2,negated_conjecture,
    is_a_theorem(equivalent(a,equivalent(a,equivalent(equivalent(b,c),equivalent(equivalent(b,e),equivalent(c,e)))))) != true ).

%------------------------------------------------------------------------------
