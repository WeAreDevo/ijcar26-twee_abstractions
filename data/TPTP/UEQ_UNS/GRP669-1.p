%------------------------------------------------------------------------------
% File     : GRP669-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : Moufang loops are RIF
% Version  : Especial.
% English  :

% Refs     : [KKP02] Kinyon et al. (2002), A Generalization of Moufang and
%          : [PS08]  Phillips & Stanovsky (2008), Automated Theorem Proving
%          : [Sta08] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08]
% Names    : KKP02b [PS08]

% Status   : Unsatisfiable
% Rating   : 0.13 v9.1.0, 0.23 v9.0.0, 0.18 v8.2.0, 0.21 v8.1.0, 0.30 v7.5.0, 0.25 v7.4.0, 0.35 v7.3.0, 0.26 v7.1.0, 0.17 v7.0.0, 0.21 v6.4.0, 0.37 v6.3.0, 0.35 v6.2.0, 0.36 v6.1.0, 0.31 v6.0.0, 0.48 v5.5.0, 0.42 v5.4.0, 0.27 v5.3.0, 0.25 v5.2.0, 0.29 v5.1.0, 0.33 v5.0.0, 0.29 v4.1.0, 0.18 v4.0.1, 0.50 v4.0.0
% Syntax   : Number of clauses     :   11 (  11 unt;   0 nHn;   1 RR)
%            Number of literals    :   11 (  11 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   4 con; 0-2 aty)
%            Number of variables   :   22 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%------------------------------------------------------------------------------
cnf(c01,axiom,
    mult(A,ld(A,B)) = B ).

cnf(c02,axiom,
    ld(A,mult(A,B)) = B ).

cnf(c03,axiom,
    mult(rd(A,B),B) = A ).

cnf(c04,axiom,
    rd(mult(A,B),B) = A ).

cnf(c05,axiom,
    mult(A,unit) = A ).

cnf(c06,axiom,
    mult(unit,A) = A ).

cnf(c07,axiom,
    mult(A,mult(B,mult(A,C))) = mult(mult(mult(A,B),A),C) ).

cnf(c08,axiom,
    mult(A,mult(B,mult(C,B))) = mult(mult(mult(A,B),C),B) ).

cnf(c09,axiom,
    mult(mult(A,B),mult(C,A)) = mult(mult(A,mult(B,C)),A) ).

cnf(c10,axiom,
    mult(mult(A,B),mult(C,A)) = mult(A,mult(mult(B,C),A)) ).

cnf(goals,negated_conjecture,
    mult(mult(a,b),mult(c,mult(a,b))) != mult(mult(mult(a,mult(b,c)),a),b) ).

%------------------------------------------------------------------------------
