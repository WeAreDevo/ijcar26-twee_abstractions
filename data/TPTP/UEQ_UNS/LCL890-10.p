%------------------------------------------------------------------------------
% File     : LCL890-10 : TPTP v9.2.1. Released v7.3.0.
% Domain   : Puzzles
% Problem  : Halving is unique in a hoop, rule for a/2 >= x
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.87 v9.1.0, 0.86 v8.2.0, 0.88 v8.1.0, 0.90 v7.5.0, 0.88 v7.4.0, 0.96 v7.3.0
% Syntax   : Number of clauses     :   19 (  19 unt;   0 nHn;   3 RR)
%            Number of literals    :   19 (  19 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   1 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   11 (  11 usr;   6 con; 0-4 aty)
%            Number of variables   :   37 (   4 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from LCL890+1 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(ifeq_axiom,axiom,
    ifeq2(A,A,B,C) = B ).

cnf(ifeq_axiom_001,axiom,
    ifeq(A,A,B,C) = B ).

cnf(sos_01,axiom,
    '+'('+'(A,B),C) = '+'(A,'+'(B,C)) ).

cnf(sos_02,axiom,
    '+'(A,B) = '+'(B,A) ).

cnf(sos_03,axiom,
    '+'(A,'0') = A ).

cnf(sos_04,axiom,
    '+'(A,'1') = '1' ).

cnf(sos_05,axiom,
    '>='(A,A) = true ).

cnf(sos_06,axiom,
    ifeq('>='(X1,X2),true,ifeq('>='(X0,X1),true,'>='(X0,X2),true),true) = true ).

cnf(sos_07,axiom,
    ifeq2('>='(X4,X3),true,ifeq2('>='(X3,X4),true,X3,X4),X4) = X4 ).

cnf(sos_08_1,axiom,
    ifeq('>='('+'(X5,X6),X7),true,'>='(X6,'==>'(X5,X7)),true) = true ).

cnf(sos_08,axiom,
    ifeq('>='(X6,'==>'(X5,X7)),true,'>='('+'(X5,X6),X7),true) = true ).

cnf(sos_09,axiom,
    '>='(A,'0') = true ).

cnf(sos_10,axiom,
    ifeq('>='(X8,X9),true,'>='('+'(X8,X10),'+'(X9,X10)),true) = true ).

cnf(sos_11,axiom,
    ifeq('>='(X11,X12),true,'>='('==>'(X12,X13),'==>'(X11,X13)),true) = true ).

cnf(sos_12,axiom,
    ifeq('>='(X14,X15),true,'>='('==>'(X16,X14),'==>'(X16,X15)),true) = true ).

cnf(sos_13,axiom,
    '+'(A,'==>'(A,B)) = '+'(B,'==>'(B,A)) ).

cnf(goals_14,negated_conjecture,
    sK2_goals_14_X19 = '==>'(sK2_goals_14_X19,sK3_goals_14_X18) ).

cnf(goals_14_1,negated_conjecture,
    '>='('==>'(sK1_goals_14_X17,sK3_goals_14_X18),sK1_goals_14_X17) = true ).

cnf(goals_14_2,negated_conjecture,
    '>='(sK2_goals_14_X19,sK1_goals_14_X17) != true ).

%------------------------------------------------------------------------------
