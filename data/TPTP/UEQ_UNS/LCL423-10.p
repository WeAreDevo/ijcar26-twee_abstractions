%------------------------------------------------------------------------------
% File     : LCL423-10 : TPTP v9.2.1. Released v7.3.0.
% Domain   : Puzzles
% Problem  : Luka-23 is a single axiom
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 1.00 v7.3.0
% Syntax   : Number of clauses     :    4 (   4 unt;   0 nHn;   1 RR)
%            Number of literals    :    4 (   4 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    8 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    9 (   9 usr;   4 con; 0-4 aty)
%            Number of variables   :   11 (   4 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from LCL423-1 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(ifeq_axiom,axiom,
    ifeq(A,A,B,C) = B ).

cnf(condensed_detachment,axiom,
    ifeq(is_a_theorem(implies(A,B)),true,ifeq(is_a_theorem(A),true,is_a_theorem(B),true),true) = true ).

cnf(luka23,axiom,
    is_a_theorem(implies(implies(implies(A,B),implies(implies(implies(not(C),not(D)),E),C)),implies(F,implies(implies(C,A),implies(D,A))))) = true ).

cnf(prove_luka_3_basis,negated_conjecture,
    tuple(is_a_theorem(implies(implies(not(a),a),a)),is_a_theorem(implies(implies(a,b),implies(implies(b,c),implies(a,c)))),is_a_theorem(implies(a,implies(not(a),b)))) != tuple(true,true,true) ).

%------------------------------------------------------------------------------
