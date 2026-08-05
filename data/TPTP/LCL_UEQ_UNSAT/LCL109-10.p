%------------------------------------------------------------------------------
% File     : LCL109-10 : TPTP v9.2.1. Released v7.5.0.
% Domain   : Puzzles
% Problem  : MV-4 depends on the Meredith system
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.26 v9.1.0, 0.27 v9.0.0, 0.32 v8.2.0, 0.25 v8.1.0, 0.30 v7.5.0
% Syntax   : Number of clauses     :   16 (  16 unt;   0 nHn;   1 RR)
%            Number of literals    :   16 (  16 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   3 con; 0-4 aty)
%            Number of variables   :   30 (   3 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from LCL109-3 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(ifeq_axiom,axiom,
    ifeq(A,A,B,C) = B ).

cnf(wajsberg_1,axiom,
    implies(truth,X) = X ).

cnf(wajsberg_2,axiom,
    implies(implies(X,Y),implies(implies(Y,Z),implies(X,Z))) = truth ).

cnf(wajsberg_3,axiom,
    implies(implies(X,Y),Y) = implies(implies(Y,X),X) ).

cnf(wajsberg_4,axiom,
    implies(implies(not(X),not(Y)),implies(Y,X)) = truth ).

cnf(lemma_1,axiom,
    implies(X,X) = truth ).

cnf(lemma_2,axiom,
    ifeq(implies(X,Y),implies(Y,X),X,Y) = Y ).

cnf(lemma_3,axiom,
    implies(X,truth) = truth ).

cnf(lemma_4,axiom,
    implies(X,implies(Y,X)) = truth ).

cnf(lemma_5,axiom,
    ifeq(implies(X,Y),implies(Y,Z),implies(X,Z),truth) = truth ).

cnf(lemma_6,axiom,
    implies(implies(X,Y),implies(implies(Z,X),implies(Z,Y))) = truth ).

cnf(lemma_7,axiom,
    implies(X,implies(Y,Z)) = implies(Y,implies(X,Z)) ).

cnf(lemma_8,axiom,
    implies(X,not(truth)) = not(X) ).

cnf(lemma_9,axiom,
    not(not(X)) = X ).

cnf(lemma_10,axiom,
    implies(not(X),not(Y)) = implies(Y,X) ).

cnf(prove_wajsberg_mv_4,negated_conjecture,
    implies(implies(implies(a,b),implies(b,a)),implies(b,a)) != truth ).

%------------------------------------------------------------------------------
