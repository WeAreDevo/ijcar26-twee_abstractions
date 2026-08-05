%------------------------------------------------------------------------------
% File     : GRP767-1 : TPTP v9.2.1. Released v4.1.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : Buchsteiner loop lemma 4
% Version  : Especial.
% English  :

% Refs     : [Sta09] Stanovsky (2009), Email to Geoff Sutcliffe
%          : [CDK10] Csoergoe et al. (2010), Buchsteiner Loops
% Source   : [Sta09]
% Names    : buch4 [Sta09]

% Status   : Unsatisfiable
% Rating   : 0.22 v9.1.0, 0.27 v8.2.0, 0.29 v8.1.0, 0.20 v7.5.0, 0.38 v7.4.0, 0.43 v7.3.0, 0.37 v7.1.0, 0.33 v7.0.0, 0.53 v6.4.0, 0.47 v6.2.0, 0.50 v6.1.0, 0.62 v6.0.0, 0.71 v5.5.0, 0.68 v5.4.0, 0.60 v5.3.0, 0.58 v5.2.0, 0.57 v5.1.0, 0.60 v5.0.0, 0.57 v4.1.0
% Syntax   : Number of clauses     :   21 (  21 unt;   0 nHn;   1 RR)
%            Number of literals    :   21 (  21 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   11 (  11 usr;   3 con; 0-3 aty)
%            Number of variables   :   40 (   0 sgn)
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
    product(i(i(A)),B) = product(eta(A),product(A,B)) ).

cnf(sos14,axiom,
    product(A,product(eta(A),B)) = product(j(j(A)),B) ).

cnf(sos15,axiom,
    product(A,product(B,eta(A))) = product(product(A,B),eta(A)) ).

cnf(sos16,axiom,
    product(eta(A),product(B,C)) = product(product(eta(A),B),C) ).

cnf(sos17,axiom,
    l(A,B,C) = difference(product(A,B),product(A,product(B,C))) ).

cnf(sos18,axiom,
    l(A,A,product(B,C)) = product(l(A,A,B),l(A,A,C)) ).

cnf(sos19,axiom,
    t(A,B) = quotient(product(A,B),A) ).

cnf(sos20,axiom,
    t(eta(A),product(B,C)) = product(t(eta(A),B),t(eta(A),C)) ).

cnf(goals,negated_conjecture,
    product(j(j(x0)),j(product(x1,x0))) != j(x1) ).

%------------------------------------------------------------------------------
