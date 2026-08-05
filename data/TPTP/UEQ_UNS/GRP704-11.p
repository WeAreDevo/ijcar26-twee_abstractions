%------------------------------------------------------------------------------
% File     : GRP704-11 : TPTP v9.2.1. Released v8.1.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : In C-loops the nucleus is normal - c
% Version  : Especial.
% English  :

% Refs     : [PV06]  Phillips & Vojtechovsky (2006), C-loops: an Introducti
%          : [PS08]  Phillips & Stanovsky (2008), Automated Theorem Proving
%          : [Sma21] Smallbone (2021), Email to Geoff Sutcliffe
% Source   : [Sma21]
% Names    : 

% Status   : Unsatisfiable
% Rating   : 0.00 v8.2.0, 0.04 v8.1.0
% Syntax   : Number of clauses     :   14 (  14 unt;   0 nHn;   1 RR)
%            Number of literals    :   14 (  14 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   10 (  10 usr;   7 con; 0-2 aty)
%            Number of variables   :   24 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : UEQ version, converted from GRP704+1.p
%------------------------------------------------------------------------------
cnf(f01,axiom,
    mult(A,ld(A,B)) = B ).

cnf(f02,axiom,
    ld(A,mult(A,B)) = B ).

cnf(f03,axiom,
    mult(rd(A,B),B) = A ).

cnf(f04,axiom,
    rd(mult(A,B),B) = A ).

cnf(f05,axiom,
    mult(A,unit) = A ).

cnf(f06,axiom,
    mult(unit,A) = A ).

cnf(f07,axiom,
    mult(A,mult(B,mult(B,C))) = mult(mult(mult(A,B),B),C) ).

cnf(f08,axiom,
    mult(op_c,mult(A,B)) = mult(mult(op_c,A),B) ).

cnf(f09,axiom,
    mult(A,mult(B,op_c)) = mult(mult(A,B),op_c) ).

cnf(f10,axiom,
    mult(A,mult(op_c,B)) = mult(mult(A,op_c),B) ).

cnf(f11,axiom,
    op_d = ld(A,mult(op_c,A)) ).

cnf(f12,axiom,
    op_e = mult(mult(rd(op_c,mult(A,B)),B),A) ).

cnf(f13,axiom,
    op_f = mult(A,mult(B,ld(mult(A,B),op_c))) ).

cnf(goal,negated_conjecture,
    mult(x4,mult(x5,op_f)) != mult(mult(x4,x5),op_f) ).

%------------------------------------------------------------------------------
