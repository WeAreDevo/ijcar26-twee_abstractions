%------------------------------------------------------------------------------
% File     : GRP705-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : Property of commutative C-loop
% Version  : Especial.
% English  : In a commutative C-loop, if a has order 4 and b has order 9, then
%            a.bx = ab.x

% Refs     : [PV06]  Phillips & Vojtechovsky (2006), C-loops: an Introducti
%          : [PS08]  Phillips & Stanovsky (2008), Automated Theorem Proving
%          : [Sta08] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08]
% Names    : PV06 [PS08]

% Status   : Unsatisfiable
% Rating   : 0.30 v9.1.0, 0.36 v8.2.0, 0.33 v8.1.0, 0.40 v7.5.0, 0.42 v7.4.0, 0.48 v7.3.0, 0.42 v7.1.0, 0.33 v7.0.0, 0.37 v6.4.0, 0.47 v6.2.0, 0.50 v6.1.0, 0.62 v6.0.0, 0.71 v5.5.0, 0.68 v5.4.0, 0.53 v5.3.0, 0.58 v5.2.0, 0.64 v5.1.0, 0.67 v5.0.0, 0.57 v4.1.0, 0.45 v4.0.1, 0.71 v4.0.0
% Syntax   : Number of clauses     :   10 (  10 unt;   0 nHn;   3 RR)
%            Number of literals    :   10 (  10 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    9 (   2 avg)
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
    mult(A,mult(B,mult(B,C))) = mult(mult(mult(A,B),B),C) ).

cnf(c08,axiom,
    mult(op_a,mult(op_a,mult(op_a,op_a))) = unit ).

cnf(c09,axiom,
    mult(op_b,mult(op_b,mult(op_b,mult(op_b,mult(op_b,mult(op_b,mult(op_b,mult(op_b,op_b)))))))) = unit ).

cnf(goals,negated_conjecture,
    mult(op_a,mult(op_b,a)) != mult(mult(op_a,op_b),a) ).

%------------------------------------------------------------------------------
