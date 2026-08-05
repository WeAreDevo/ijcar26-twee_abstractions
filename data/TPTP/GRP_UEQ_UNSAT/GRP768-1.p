%------------------------------------------------------------------------------
% File     : GRP768-1 : TPTP v9.2.1. Released v4.1.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : Buchsteiner loop lemma 5
% Version  : Especial.
% English  :

% Refs     : [Sta09] Stanovsky (2009), Email to Geoff Sutcliffe
%          : [CDK10] Csoergoe et al. (2010), Buchsteiner Loops
% Source   : [Sta09]
% Names    : buch5 [Sta09]

% Status   : Unsatisfiable
% Rating   : 0.48 v9.1.0, 0.59 v8.2.0, 0.58 v8.1.0, 0.55 v7.5.0, 0.62 v7.4.0, 0.70 v7.3.0, 0.58 v7.1.0, 0.61 v7.0.0, 0.63 v6.4.0, 0.74 v6.3.0, 0.76 v6.2.0, 0.71 v6.1.0, 0.69 v6.0.0, 0.81 v5.5.0, 0.84 v5.4.0, 0.73 v5.3.0, 0.83 v5.2.0, 0.79 v5.1.0, 0.80 v5.0.0, 0.79 v4.1.0
% Syntax   : Number of clauses     :   20 (  20 unt;   0 nHn;   1 RR)
%            Number of literals    :   20 (  20 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   11 (  11 usr;   4 con; 0-2 aty)
%            Number of variables   :   35 (   0 sgn)
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
    quotient(j(A),A) = product(j(A),i(A)) ).

cnf(sos18,axiom,
    product(product(product(quotient(j(A),A),product(A,A)),B),C) = product(product(quotient(j(A),A),product(A,A)),product(B,C)) ).

cnf(sos19,axiom,
    t(A,B) = quotient(product(A,B),A) ).

cnf(goals,negated_conjecture,
    t(eta(x0),product(x1,x2)) != product(t(eta(x0),x1),t(eta(x0),x2)) ).

%------------------------------------------------------------------------------
