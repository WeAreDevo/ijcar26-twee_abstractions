%------------------------------------------------------------------------------
% File     : GRP766-1 : TPTP v9.2.1. Released v4.1.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : Buchsteiner loop lemma 3
% Version  : Especial.
% English  :

% Refs     : [Sta09] Stanovsky (2009), Email to Geoff Sutcliffe
%          : [CDK10] Csoergoe et al. (2010), Buchsteiner Loops
% Source   : [Sta09]
% Names    : buch3 [Sta09]

% Status   : Unsatisfiable
% Rating   : 0.65 v9.1.0, 0.64 v8.2.0, 0.58 v8.1.0, 0.65 v7.5.0, 0.79 v7.4.0, 0.87 v7.3.0, 0.79 v7.1.0, 0.83 v7.0.0, 0.79 v6.3.0, 0.82 v6.2.0, 0.79 v6.1.0, 0.81 v6.0.0, 0.86 v5.5.0, 0.84 v5.4.0, 0.87 v5.3.0, 0.92 v5.2.0, 0.86 v5.1.0, 0.87 v5.0.0, 0.93 v4.1.0
% Syntax   : Number of clauses     :   20 (  20 unt;   0 nHn;   1 RR)
%            Number of literals    :   20 (  20 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   12 (  12 usr;   4 con; 0-3 aty)
%            Number of variables   :   37 (   0 sgn)
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

cnf(sos13,axiom,
    l(A,B,C) = difference(product(A,B),product(A,product(B,C))) ).

cnf(sos14,axiom,
    l(A,A,product(B,C)) = product(l(A,A,B),l(A,A,C)) ).

cnf(sos15,axiom,
    product(i(i(A)),B) = product(eta(A),product(A,B)) ).

cnf(sos16,axiom,
    product(A,product(eta(A),B)) = product(j(j(A)),B) ).

cnf(sos17,axiom,
    product(A,product(B,eta(A))) = product(product(A,B),eta(A)) ).

cnf(sos18,axiom,
    t(A,B) = quotient(product(A,B),A) ).

cnf(sos19,axiom,
    t(eta(A),product(B,C)) = product(t(eta(A),B),t(eta(A),C)) ).

cnf(goals,negated_conjecture,
    product(eta(x0),product(x1,x2)) != product(product(eta(x0),x1),x2) ).

%------------------------------------------------------------------------------
