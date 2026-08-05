%------------------------------------------------------------------------------
% File     : GRP690-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : Bruck loop elements of order 2^4 commute with elems of order 3^2
% Version  : Especial.
% English  :

% Refs     : [AKP06] Aschbacher et al. (2006), Finite Bruck Loops
%          : [PS08]  Phillips & Stanovsky (2008), Automated Theorem Proving
%          : [Sta08] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08]
% Names    : AKP06 [PS08]

% Status   : Unsatisfiable
% Rating   : 0.83 v9.1.0, 0.82 v8.2.0, 0.83 v8.1.0, 0.90 v7.5.0, 0.88 v7.4.0, 0.87 v7.3.0, 0.95 v7.1.0, 0.89 v6.3.0, 0.88 v6.2.0, 0.93 v6.1.0, 0.94 v6.0.0, 1.00 v5.0.0, 0.93 v4.1.0, 0.91 v4.0.1, 0.93 v4.0.0
% Syntax   : Number of clauses     :   12 (  12 unt;   0 nHn;   3 RR)
%            Number of literals    :   12 (  12 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    9 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   3 con; 0-2 aty)
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
    mult(A,mult(B,mult(A,C))) = mult(mult(A,mult(B,A)),C) ).

cnf(c08,axiom,
    mult(i(A),mult(A,B)) = B ).

cnf(c09,axiom,
    i(mult(A,B)) = mult(i(A),i(B)) ).

cnf(c10,axiom,
    mult(op_c,mult(op_c,mult(op_c,mult(op_c,mult(op_c,mult(op_c,mult(op_c,op_c))))))) = unit ).

cnf(c11,axiom,
    mult(op_d,mult(op_d,mult(op_d,mult(op_d,mult(op_d,mult(op_d,mult(op_d,mult(op_d,op_d)))))))) = unit ).

cnf(goals,negated_conjecture,
    mult(op_c,op_d) != mult(op_d,op_c) ).

%------------------------------------------------------------------------------
