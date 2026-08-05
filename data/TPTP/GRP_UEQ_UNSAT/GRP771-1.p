%------------------------------------------------------------------------------
% File     : GRP771-1 : TPTP v9.2.1. Released v4.1.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : Buchsteiner loop lemma 8
% Version  : Especial.
% English  :

% Refs     : [Sta09] Stanovsky (2009), Email to Geoff Sutcliffe
%          : [CDK10] Csoergoe et al. (2010), Buchsteiner Loops
% Source   : [Sta09]
% Names    : buch8 [Sta09]

% Status   : Unsatisfiable
% Rating   : 1.00 v4.1.0
% Syntax   : Number of clauses     :   25 (  25 unt;   0 nHn;   1 RR)
%            Number of literals    :   25 (  25 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   14 (  14 usr;   5 con; 0-3 aty)
%            Number of variables   :   47 (   0 sgn)
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

cnf(sos20,axiom,
    t(eta(A),product(B,C)) = product(t(eta(A),B),t(eta(A),C)) ).

%----WWIP
cnf(sos21,axiom,
    product(i(product(A,B)),i(i(A))) = i(B) ).

cnf(sos22,axiom,
    product(j(j(A)),j(product(B,A))) = j(B) ).

%----Commutativity and associativity
cnf(sos23,axiom,
    product(product(A,product(B,C)),a(A,B,C)) = product(product(A,B),C) ).

cnf(sos24,axiom,
    product(product(A,B),c(B,A)) = product(B,A) ).

cnf(goals,negated_conjecture,
    product(product(x0,x1),c(x2,x3)) != product(x0,product(x1,c(x2,x3))) ).

%------------------------------------------------------------------------------
