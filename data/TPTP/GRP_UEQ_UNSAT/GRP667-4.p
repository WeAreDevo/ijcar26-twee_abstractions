%------------------------------------------------------------------------------
% File     : GRP667-4 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : 2-divisible ARIF loops are Moufang
% Version  : Especial.
% English  :

% Refs     : [KKP02] Kinyon et al. (2002), A Generalization of Moufang and
%          : [PS08]  Phillips & Stanovsky (2008), Automated Theorem Proving
%          : [Sta08] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08]
% Names    : KKP02b [PS08]

% Status   : Unsatisfiable
% Rating   : 0.52 v9.1.0, 0.55 v8.2.0, 0.58 v8.1.0, 0.60 v7.5.0, 0.71 v7.4.0, 0.74 v7.1.0, 0.67 v7.0.0, 0.68 v6.4.0, 0.74 v6.3.0, 0.65 v6.2.0, 0.57 v6.1.0, 0.69 v6.0.0, 0.76 v5.5.0, 0.74 v5.4.0, 0.67 v5.2.0, 0.64 v5.1.0, 0.67 v5.0.0, 0.64 v4.1.0, 0.55 v4.0.1, 0.79 v4.0.0
% Syntax   : Number of clauses     :   10 (  10 unt;   0 nHn;   1 RR)
%            Number of literals    :   10 (  10 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   4 con; 0-2 aty)
%            Number of variables   :   16 (   0 sgn)
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
    mult(mult(A,B),mult(mult(C,B),C)) = mult(mult(A,mult(mult(B,C),B)),C) ).

cnf(c08,axiom,
    mult(mult(A,B),A) = mult(A,mult(B,A)) ).

cnf(c09,axiom,
    mult(f(A),f(A)) = A ).

cnf(goals,negated_conjecture,
    mult(mult(a,b),mult(c,a)) != mult(mult(a,mult(b,c)),a) ).

%------------------------------------------------------------------------------
