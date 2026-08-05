%------------------------------------------------------------------------------
% File     : GRP765-1 : TPTP v9.2.1. Released v4.1.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : Buchsteiner loop lemma 2
% Version  : Especial.
% English  :

% Refs     : [Sta09] Stanovsky (2009), Email to Geoff Sutcliffe
%          : [CDK10] Csoergoe et al. (2010), Buchsteiner Loops
% Source   : [Sta09]
% Names    : buch2 [Sta09]

% Status   : Unsatisfiable
% Rating   : 0.65 v9.1.0, 0.64 v9.0.0, 0.59 v8.2.0, 0.58 v8.1.0, 0.70 v7.5.0, 0.71 v7.4.0, 0.70 v7.3.0, 0.68 v7.1.0, 0.67 v7.0.0, 0.74 v6.3.0, 0.71 v6.1.0, 0.75 v6.0.0, 0.81 v5.5.0, 0.84 v5.4.0, 0.80 v5.3.0, 0.83 v5.2.0, 0.86 v5.1.0, 0.87 v5.0.0, 0.79 v4.1.0
% Syntax   : Number of clauses     :   13 (  13 unt;   0 nHn;   1 RR)
%            Number of literals    :   13 (  13 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    9 (   9 usr;   3 con; 0-2 aty)
%            Number of variables   :   20 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%------------------------------------------------------------------------------
cnf(sos01,axiom,
    product(A,one) = A ).

cnf(sos02,axiom,
    product(one,A) = A ).

cnf(sos03,axiom,
    product(A,difference(A,B)) = B ).

cnf(sos04,axiom,
    difference(A,product(A,B)) = B ).

cnf(sos05,axiom,
    quotient(product(A,B),B) = A ).

cnf(sos06,axiom,
    product(quotient(A,B),B) = A ).

%----Thm 1.4
cnf(sos07,axiom,
    difference(A,product(product(A,B),C)) = quotient(product(B,product(C,A)),A) ).

cnf(sos08,axiom,
    difference(product(A,B),product(A,product(B,C))) = quotient(quotient(product(C,product(A,B)),B),A) ).

%----Sec.4
cnf(sos09,axiom,
    i(A) = difference(A,one) ).

cnf(sos10,axiom,
    j(A) = quotient(one,A) ).

cnf(sos11,axiom,
    product(i(A),A) = product(A,j(A)) ).

cnf(sos12,axiom,
    eta(A) = product(i(A),A) ).

cnf(goals,negated_conjecture,
    product(i(i(x0)),x1) != product(eta(x0),product(x0,x1)) ).

%------------------------------------------------------------------------------
