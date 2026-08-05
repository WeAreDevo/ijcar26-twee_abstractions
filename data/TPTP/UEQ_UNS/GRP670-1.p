%------------------------------------------------------------------------------
% File     : GRP670-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : RIF loops are ARIF - a
% Version  : Especial.
% English  :

% Refs     : [KKP02] Kinyon et al. (2002), A Generalization of Moufang and
%          : [PS08]  Phillips & Stanovsky (2008), Automated Theorem Proving
%          : [Sta08] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08]
% Names    : KKP02b [PS08]

% Status   : Unsatisfiable
% Rating   : 0.52 v9.1.0, 0.59 v9.0.0, 0.55 v8.2.0, 0.62 v8.1.0, 0.55 v7.5.0, 0.62 v7.4.0, 0.70 v7.3.0, 0.68 v7.1.0, 0.61 v7.0.0, 0.63 v6.4.0, 0.68 v6.3.0, 0.65 v6.2.0, 0.64 v6.1.0, 0.81 v5.5.0, 0.74 v5.4.0, 0.80 v5.3.0, 0.75 v5.2.0, 0.71 v5.1.0, 0.73 v5.0.0, 0.71 v4.1.0, 0.73 v4.0.1, 0.71 v4.0.0
% Syntax   : Number of clauses     :   10 (  10 unt;   0 nHn;   1 RR)
%            Number of literals    :   10 (  10 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   4 con; 0-2 aty)
%            Number of variables   :   17 (   0 sgn)
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
    mult(i(A),mult(A,B)) = B ).

cnf(c08,axiom,
    mult(mult(A,B),i(B)) = A ).

cnf(c09,axiom,
    mult(mult(A,B),mult(C,mult(A,B))) = mult(mult(mult(A,mult(B,C)),A),B) ).

cnf(goals,negated_conjecture,
    mult(mult(a,b),mult(mult(c,b),c)) != mult(mult(a,mult(mult(b,c),b)),c) ).

%------------------------------------------------------------------------------
