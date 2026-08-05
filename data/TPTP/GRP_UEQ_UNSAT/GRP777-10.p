%------------------------------------------------------------------------------
% File     : GRP777-10 : TPTP v9.2.1. Released v8.1.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : Napoleon's quasigroups: the centroid relation
% Version  : Especial.
% English  :

% Refs     : [Sta09] Stanovsky (2009), Email to Geoff Sutcliffe
%          : [Sma21] Smallbone (2021), Email to Geoff Sutcliffe
% Source   : [Sma21]
% Names    : 

% Status   : Unsatisfiable
% Rating   : 0.17 v9.1.0, 0.23 v9.0.0, 0.27 v8.2.0, 0.33 v8.1.0
% Syntax   : Number of clauses     :   10 (  10 unt;   0 nHn;   2 RR)
%            Number of literals    :   10 (  10 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   4 con; 0-3 aty)
%            Number of variables   :   18 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : UEQ version, converted from GRP777+1.p
%------------------------------------------------------------------------------
cnf(sos01,axiom,
    difference(A,product(A,B)) = B ).

cnf(sos02,axiom,
    product(A,difference(A,B)) = B ).

cnf(sos03,axiom,
    quotient(product(A,B),B) = A ).

cnf(sos04,axiom,
    product(quotient(A,B),B) = A ).

cnf(sos05,axiom,
    product(product(A,B),product(C,D)) = product(product(A,C),product(B,D)) ).

cnf(sos06,axiom,
    product(A,A) = A ).

%----Napoleon
cnf(sos07,axiom,
    product(product(product(A,B),B),product(B,product(B,A))) = B ).

cnf(sos08,axiom,
    bigC(A,B,C) = product(product(A,B),product(C,A)) ).

cnf(sos09,axiom,
    product(product(a,c),product(c,b)) = product(a,b) ).

cnf(goal,negated_conjecture,
    bigC(a,b,x0) != bigC(c,c,x0) ).

%------------------------------------------------------------------------------
