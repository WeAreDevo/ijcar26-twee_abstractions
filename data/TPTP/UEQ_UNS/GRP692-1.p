%------------------------------------------------------------------------------
% File     : GRP692-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : In a power associative conjugacy closed loop, c^6 is extra
% Version  : Especial.
% English  :

% Refs     : [KK06]  Kinyon & Kunen (2006), Power-associative, Conjugacy Cl
%          : [PS08]  Phillips & Stanovsky (2008), Automated Theorem Proving
%          : [Sta08] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08]
% Names    : KK06 [PS08]

% Status   : Unsatisfiable
% Rating   : 0.91 v9.1.0, 0.86 v8.2.0, 0.79 v8.1.0, 0.90 v7.5.0, 0.88 v7.4.0, 0.87 v7.3.0, 0.89 v7.1.0, 0.83 v7.0.0, 0.84 v6.3.0, 0.76 v6.2.0, 0.79 v6.1.0, 1.00 v5.3.0, 0.92 v5.2.0, 0.93 v5.0.0, 1.00 v4.0.1, 0.93 v4.0.0
% Syntax   : Number of clauses     :   14 (  14 unt;   0 nHn;   4 RR)
%            Number of literals    :   14 (  14 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   11 (  11 usr;   7 con; 0-2 aty)
%            Number of variables   :   18 (   0 sgn)
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
    mult(i(A),A) = unit ).

cnf(c10,axiom,
    mult(A,i(A)) = unit ).

cnf(c11,axiom,
    mult(op_c,mult(op_c,op_c)) = op_d ).

cnf(c12,axiom,
    mult(op_d,op_d) = op_e ).

cnf(c13,axiom,
    mult(op_e,op_e) = op_f ).

cnf(goals,negated_conjecture,
    mult(op_e,mult(a,mult(b,op_e))) != mult(mult(mult(op_e,a),b),op_e) ).

%------------------------------------------------------------------------------
