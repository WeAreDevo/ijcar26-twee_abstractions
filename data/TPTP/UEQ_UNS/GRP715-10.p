%------------------------------------------------------------------------------
% File     : GRP715-10 : TPTP v9.2.1. Released v8.1.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : Strongly right alternative rings 1
% Version  : Especial.
% English  : If a has a 2-sided inverse, then R(a^-1) = R(a)^-1 and
%            L(a)^-1 = R(a)L(a^-1)R(a^-1).

% Refs     : [PS08]  Phillips & Stanovsky (2008), Automated Theorem Proving
%          : [Sma21] Smallbone (2021), Email to Geoff Sutcliffe
% Source   : [Sma21]
% Names    : 

% Status   : Unsatisfiable
% Rating   : 0.09 v9.1.0, 0.14 v8.2.0, 0.17 v8.1.0
% Syntax   : Number of clauses     :   12 (  12 unt;   0 nHn;   3 RR)
%            Number of literals    :   12 (  12 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   5 con; 0-2 aty)
%            Number of variables   :   17 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : UEQ version, converted from GRP715+1.p
%------------------------------------------------------------------------------
cnf(f01,axiom,
    plus(plus(A,B),C) = plus(A,plus(B,C)) ).

cnf(f02,axiom,
    plus(A,B) = plus(B,A) ).

cnf(f03,axiom,
    plus(A,op_0) = A ).

cnf(f04,axiom,
    plus(A,minus(A)) = op_0 ).

cnf(f05,axiom,
    mult(A,plus(B,C)) = plus(mult(A,B),mult(A,C)) ).

cnf(f06,axiom,
    mult(mult(mult(A,B),C),B) = mult(A,mult(mult(B,C),B)) ).

cnf(f07,axiom,
    mult(A,mult(B,B)) = mult(mult(A,B),B) ).

cnf(f08,axiom,
    mult(A,unit) = A ).

cnf(f09,axiom,
    mult(unit,A) = A ).

cnf(f10,axiom,
    mult(op_a,op_b) = unit ).

cnf(f11,axiom,
    mult(op_b,op_a) = unit ).

cnf(goal,negated_conjecture,
    mult(mult(x0,op_a),op_b) != x0 ).

%------------------------------------------------------------------------------
