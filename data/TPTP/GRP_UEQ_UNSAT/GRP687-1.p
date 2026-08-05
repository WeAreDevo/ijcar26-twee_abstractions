%------------------------------------------------------------------------------
% File     : GRP687-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : x(y.yz) = (x.yy)z is equivalent to xx.yz = (x.xy)z part 2
% Version  : Especial.
% English  :

% Refs     : [PV05]  Phillips & Vojtechovsky (2005), The Varieties of Loops
%          : [PS08]  Phillips & Stanovsky (2008), Automated Theorem Proving
%          : [Sta08] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08]
% Names    : PV05 [PS08]

% Status   : Unsatisfiable
% Rating   : 0.13 v9.1.0, 0.18 v8.2.0, 0.25 v7.5.0, 0.29 v7.4.0, 0.35 v7.3.0, 0.32 v7.1.0, 0.22 v7.0.0, 0.26 v6.4.0, 0.32 v6.3.0, 0.29 v6.1.0, 0.25 v6.0.0, 0.38 v5.5.0, 0.37 v5.4.0, 0.20 v5.3.0, 0.25 v5.2.0, 0.29 v5.1.0, 0.33 v5.0.0, 0.29 v4.1.0, 0.18 v4.0.1, 0.57 v4.0.0
% Syntax   : Number of clauses     :    8 (   8 unt;   0 nHn;   1 RR)
%            Number of literals    :    8 (   8 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   4 con; 0-2 aty)
%            Number of variables   :   13 (   0 sgn)
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
    mult(mult(A,A),mult(B,C)) = mult(mult(A,mult(A,B)),C) ).

cnf(goals,negated_conjecture,
    mult(a,mult(b,mult(b,c))) != mult(mult(a,mult(b,b)),c) ).

%------------------------------------------------------------------------------
