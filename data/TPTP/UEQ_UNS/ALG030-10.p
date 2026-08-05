%------------------------------------------------------------------------------
% File     : ALG030-10 : TPTP v9.2.1. Released v7.3.0.
% Domain   : Puzzles
% Problem  : Groups 6: CPROPS-SORTED-DISCRIMINANT-PROBLEM-2
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.09 v9.1.0, 0.14 v8.2.0, 0.12 v8.1.0, 0.05 v7.5.0, 0.12 v7.4.0, 0.13 v7.3.0
% Syntax   : Number of clauses     :   14 (  14 unt;   0 nHn;   3 RR)
%            Number of literals    :   14 (  14 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   11 (  11 usr;   3 con; 0-4 aty)
%            Number of variables   :   20 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from ALG030+1 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(ifeq_axiom,axiom,
    ifeq2(A,A,B,C) = B ).

cnf(ifeq_axiom_001,axiom,
    ifeq(A,A,B,C) = B ).

cnf(ax1,axiom,
    ifeq(sorti1(V),true,ifeq(sorti1(U),true,sorti1(op1(U,V)),true),true) = true ).

cnf(ax2,axiom,
    ifeq(sorti2(V),true,ifeq(sorti2(U),true,sorti2(op2(U,V)),true),true) = true ).

cnf(ax3_2,axiom,
    op1(sK2_ax3_U,sK1_ax3_V) != op1(sK1_ax3_V,sK2_ax3_U) ).

cnf(ax3_1,axiom,
    sorti1(sK1_ax3_V) = true ).

cnf(ax3,axiom,
    sorti1(sK2_ax3_U) = true ).

cnf(ax4,axiom,
    ifeq2(sorti2(V),true,ifeq2(sorti2(U),true,op2(U,V),op2(V,U)),op2(V,U)) = op2(V,U) ).

cnf(co1,negated_conjecture,
    ifeq(sorti1(U),true,sorti2(h(U)),true) = true ).

cnf(co1_1,negated_conjecture,
    ifeq2(sorti1(X),true,ifeq2(sorti1(W),true,op2(h(W),h(X)),h(op1(W,X))),h(op1(W,X))) = h(op1(W,X)) ).

cnf(co1_2,negated_conjecture,
    ifeq2(sorti1(X2),true,j(h(X2)),X2) = X2 ).

cnf(co1_3,negated_conjecture,
    ifeq(sorti2(V),true,sorti1(j(V)),true) = true ).

cnf(co1_4,negated_conjecture,
    ifeq2(sorti2(Z),true,ifeq2(sorti2(Y),true,op1(j(Y),j(Z)),j(op2(Y,Z))),j(op2(Y,Z))) = j(op2(Y,Z)) ).

cnf(co1_5,negated_conjecture,
    ifeq2(sorti2(X1),true,h(j(X1)),X1) = X1 ).

%------------------------------------------------------------------------------
