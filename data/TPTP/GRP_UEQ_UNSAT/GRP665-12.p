%------------------------------------------------------------------------------
% File     : GRP665-12 : TPTP v9.2.1. Released v8.1.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : Conjugacy closed implies commutant in the nucleus
% Version  : Especial.
% English  :

% Refs     : [Kun00] Kunen (2000), The Structure of Conjugacy Closed Loops
%          : [PS08]  Phillips & Stanovsky (2008), Automated Theorem Proving
%          : [Sma21] Smallbone (2021), Email to Geoff Sutcliffe
% Source   : [Sma21]
% Names    : 

% Status   : Unsatisfiable
% Rating   : 0.00 v9.1.0, 0.05 v8.2.0, 0.08 v8.1.0
% Syntax   : Number of clauses     :   10 (  10 unt;   0 nHn;   1 RR)
%            Number of literals    :   10 (  10 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   4 con; 0-2 aty)
%            Number of variables   :   17 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : UEQ version, converted from GRP665+2.p
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
    mult(A,mult(B,C)) = mult(rd(mult(A,B),A),mult(A,C)) ).

cnf(f08,axiom,
    mult(mult(A,B),C) = mult(mult(A,C),ld(C,mult(B,C))) ).

cnf(f09,axiom,
    mult(op_c,A) = mult(A,op_c) ).

cnf(goal,negated_conjecture,
    mult(mult(x0,x1),op_c) != mult(x0,mult(x1,op_c)) ).

%------------------------------------------------------------------------------
