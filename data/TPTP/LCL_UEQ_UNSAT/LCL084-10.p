%------------------------------------------------------------------------------
% File     : LCL084-10 : TPTP v9.2.1. Released v7.5.0.
% Domain   : Puzzles
% Problem  : IC-4 depends on the 1st Lukasiewicz axiom
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.74 v9.1.0, 0.73 v8.2.0, 0.75 v7.5.0
% Syntax   : Number of clauses     :    5 (   5 unt;   0 nHn;   1 RR)
%            Number of literals    :    5 (   5 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   4 con; 0-4 aty)
%            Number of variables   :   10 (   3 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from LCL084-2 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(ifeq_axiom,axiom,
    ifeq(A,A,B,C) = B ).

cnf(condensed_detachment,axiom,
    ifeq(is_a_theorem(implies(X,Y)),true,ifeq(is_a_theorem(X),true,is_a_theorem(Y),true),true) = true ).

cnf(ic_JLukasiewicz,axiom,
    is_a_theorem(implies(implies(implies(X,Y),Z),implies(implies(Z,X),implies(U,X)))) = true ).

cnf(ic_1,axiom,
    is_a_theorem(implies(X,X)) = true ).

cnf(prove_ic_4,negated_conjecture,
    is_a_theorem(implies(implies(a,b),implies(implies(b,c),implies(a,c)))) != true ).

%------------------------------------------------------------------------------
