%------------------------------------------------------------------------------
% File     : LCL096-10 : TPTP v9.2.1. Released v7.3.0.
% Domain   : Puzzles
% Problem  : LG-1 depends on LG-2, LG-3, LG-4
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.17 v9.1.0, 0.23 v8.2.0, 0.33 v8.1.0, 0.25 v7.5.0, 0.29 v7.4.0, 0.35 v7.3.0
% Syntax   : Number of clauses     :    6 (   6 unt;   0 nHn;   1 RR)
%            Number of literals    :    6 (   6 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    8 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   4 con; 0-4 aty)
%            Number of variables   :   19 (   1 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from LCL096-1 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(ifeq_axiom,axiom,
    ifeq(A,A,B,C) = B ).

cnf(condensed_detachment,axiom,
    ifeq(is_a_theorem(equivalent(X,Y)),true,ifeq(is_a_theorem(X),true,is_a_theorem(Y),true),true) = true ).

cnf(lg_2,axiom,
    is_a_theorem(equivalent(equivalent(equivalent(equivalent(equivalent(X,Y),equivalent(X,Z)),equivalent(Y,Z)),U),U)) = true ).

cnf(lg_3,axiom,
    is_a_theorem(equivalent(equivalent(equivalent(equivalent(equivalent(equivalent(X,Y),equivalent(X,Z)),U),equivalent(equivalent(Y,Z),U)),V),V)) = true ).

cnf(lg_4,axiom,
    is_a_theorem(equivalent(equivalent(equivalent(equivalent(X,Y),Z),U),equivalent(equivalent(equivalent(X,V),Z),equivalent(equivalent(Y,V),U)))) = true ).

cnf(prove_lg_1,negated_conjecture,
    is_a_theorem(equivalent(equivalent(equivalent(a,equivalent(equivalent(b,b),a)),c),c)) != true ).

%------------------------------------------------------------------------------
