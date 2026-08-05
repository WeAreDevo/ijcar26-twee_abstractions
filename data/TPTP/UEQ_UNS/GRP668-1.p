%------------------------------------------------------------------------------
% File     : GRP668-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : Flexible C-loops are ARIF
% Version  : Especial.
% English  :

% Refs     : [KKP02] Kinyon et al. (2002), A Generalization of Moufang and
%          : [PS08]  Phillips & Stanovsky (2008), Automated Theorem Proving
%          : [Sta08] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08]
% Names    : KKP02b [PS08]

% Status   : Unsatisfiable
% Rating   : 0.35 v9.1.0, 0.41 v8.2.0, 0.50 v8.1.0, 0.45 v7.5.0, 0.62 v7.4.0, 0.65 v7.3.0, 0.58 v7.1.0, 0.50 v7.0.0, 0.37 v6.4.0, 0.47 v6.2.0, 0.43 v6.1.0, 0.62 v6.0.0, 0.71 v5.5.0, 0.63 v5.4.0, 0.53 v5.3.0, 0.58 v5.2.0, 0.57 v5.1.0, 0.67 v5.0.0, 0.64 v4.1.0, 0.45 v4.0.1, 0.71 v4.0.0
% Syntax   : Number of clauses     :    9 (   9 unt;   0 nHn;   1 RR)
%            Number of literals    :    9 (   9 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   4 con; 0-2 aty)
%            Number of variables   :   15 (   0 sgn)
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
    mult(A,mult(B,mult(B,C))) = mult(mult(mult(A,B),B),C) ).

cnf(c08,axiom,
    mult(mult(A,B),A) = mult(A,mult(B,A)) ).

cnf(goals,negated_conjecture,
    mult(mult(a,b),mult(mult(c,b),c)) != mult(mult(a,mult(mult(b,c),b)),c) ).

%------------------------------------------------------------------------------
