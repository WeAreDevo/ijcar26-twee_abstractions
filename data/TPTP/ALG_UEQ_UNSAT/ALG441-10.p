%------------------------------------------------------------------------------
% File     : ALG441-10 : TPTP v9.2.1. Released v7.3.0.
% Domain   : Puzzles
% Problem  : Malcev, wnu2, wnu4 implies majority
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.96 v9.1.0, 0.95 v9.0.0, 0.91 v8.2.0, 0.92 v8.1.0, 0.90 v7.5.0, 0.92 v7.4.0, 0.91 v7.3.0
% Syntax   : Number of clauses     :   17 (  17 unt;   0 nHn;   4 RR)
%            Number of literals    :   17 (  17 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    7 (   1 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   3 con; 0-4 aty)
%            Number of variables   :   46 (   1 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from ALG441-1 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(ifeq_axiom,axiom,
    ifeq(A,A,B,C) = B ).

cnf(sos,axiom,
    m(A,A,B) = B ).

cnf(sos_001,axiom,
    m(A,B,B) = A ).

cnf(sos_002,axiom,
    u(A,A) = A ).

cnf(sos_003,axiom,
    v(A,A,A,A) = A ).

cnf(sos_004,axiom,
    u(A,B) = u(B,A) ).

cnf(sos_005,axiom,
    v(A,A,A,B) = v(A,A,B,A) ).

cnf(sos_006,axiom,
    v(A,A,B,A) = v(A,B,A,A) ).

cnf(sos_007,axiom,
    v(A,B,A,A) = v(B,A,A,A) ).

cnf(sos_008,axiom,
    u(A,B) = v(A,A,A,B) ).

cnf(sos_009,axiom,
    ifeq(r(X6,X7,X8),true,ifeq(r(X3,X4,X5),true,ifeq(r(X0,X1,X2),true,r(m(X0,X3,X6),m(X1,X4,X7),m(X2,X5,X8)),true),true),true) = true ).

cnf(sos_010,axiom,
    ifeq(r(X3,X4,X5),true,ifeq(r(X0,X1,X2),true,r(u(X0,X3),u(X1,X4),u(X2,X5)),true),true) = true ).

cnf(sos_011,axiom,
    ifeq(r(X9,X10,X11),true,ifeq(r(X6,X7,X8),true,ifeq(r(X3,X4,X5),true,ifeq(r(X0,X1,X2),true,r(v(X0,X3,X6,X9),v(X1,X4,X7,X10),v(X2,X5,X8,X11)),true),true),true),true) = true ).

cnf(sos_012,axiom,
    r(a,a,b) = true ).

cnf(sos_013,axiom,
    r(a,b,a) = true ).

cnf(sos_014,axiom,
    r(b,a,a) = true ).

cnf(goals,negated_conjecture,
    r(a,a,a) != true ).

%------------------------------------------------------------------------------
