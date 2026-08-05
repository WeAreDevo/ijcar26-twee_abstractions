%------------------------------------------------------------------------------
% File     : GRP661-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : Conjugacy closed with ab = 1 implies ba is in the nucleus - a
% Version  : Especial.
% English  :

% Refs     : [Kun00] Kunen (2000), The Structure of Conjugacy Closed Loops
%          : [PS08]  Phillips & Stanovsky (2008), Automated Theorem Proving
%          : [Sta08] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08]
% Names    : Kun00 [PS08]

% Status   : Unsatisfiable
% Rating   : 0.87 v9.1.0, 0.86 v8.2.0, 0.83 v8.1.0, 0.90 v7.5.0, 0.88 v7.4.0, 0.91 v7.3.0, 0.89 v7.1.0, 0.83 v7.0.0, 0.84 v6.3.0, 0.82 v6.2.0, 0.86 v6.1.0, 0.88 v6.0.0, 0.90 v5.5.0, 0.89 v5.4.0, 0.87 v5.3.0, 0.83 v5.2.0, 0.93 v5.0.0, 1.00 v4.0.1, 0.93 v4.0.0
% Syntax   : Number of clauses     :   10 (  10 unt;   0 nHn;   2 RR)
%            Number of literals    :   10 (  10 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   5 con; 0-2 aty)
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
    mult(A,mult(B,C)) = mult(rd(mult(A,B),A),mult(A,C)) ).

cnf(c08,axiom,
    mult(mult(A,B),C) = mult(mult(A,C),ld(C,mult(B,C))) ).

cnf(c09,axiom,
    mult(op_c,op_d) = unit ).

cnf(goals,negated_conjecture,
    mult(mult(op_d,op_c),mult(a,b)) != mult(mult(mult(op_d,op_c),a),b) ).

%------------------------------------------------------------------------------
