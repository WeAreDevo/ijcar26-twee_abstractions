%------------------------------------------------------------------------------
% File     : LCL419-10 : TPTP v9.2.1. Released v7.5.0.
% Domain   : Puzzles
% Problem  : Prove AK1 from MV1--MV4
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 1.00 v7.5.0
% Syntax   : Number of clauses     :    7 (   7 unt;   0 nHn;   1 RR)
%            Number of literals    :    7 (   7 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    9 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   4 con; 0-4 aty)
%            Number of variables   :   14 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from LCL419-1 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(ifeq_axiom,axiom,
    ifeq(A,A,B,C) = B ).

cnf(condensed_detachment,axiom,
    ifeq(is_a_theorem(implies(A,B)),true,ifeq(is_a_theorem(A),true,is_a_theorem(B),true),true) = true ).

cnf(mv1,axiom,
    is_a_theorem(implies(A,implies(B,A))) = true ).

cnf(mv2,axiom,
    is_a_theorem(implies(implies(A,B),implies(implies(B,C),implies(A,C)))) = true ).

cnf(mv3,axiom,
    is_a_theorem(implies(implies(implies(A,B),B),implies(implies(B,A),A))) = true ).

cnf(mv4,axiom,
    is_a_theorem(implies(implies(not(A),not(B)),implies(B,A))) = true ).

cnf(prove_ak1,negated_conjecture,
    is_a_theorem(implies(implies(implies(a,not(implies(implies(not(b),not(c)),not(c)))),not(implies(implies(not(b),not(c)),not(c)))),not(implies(implies(not(implies(implies(a,b),b)),not(implies(implies(a,c),c))),not(implies(implies(a,c),c)))))) != true ).

%------------------------------------------------------------------------------
