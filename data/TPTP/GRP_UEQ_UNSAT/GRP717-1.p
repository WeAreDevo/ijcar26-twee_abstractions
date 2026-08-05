%------------------------------------------------------------------------------
% File     : GRP717-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : Strongly right alternative rings 2b
% Version  : Especial.
% English  : If a has a 2-sided inverse, then R(a^-1) = R(a)^-1 and
%            L(a)^-1 = R(a)L(a^-1)R(a^-1).

% Refs     : [PS08]  Phillips & Stanovsky (2008), Automated Theorem Proving
%          : [Sta08] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08]
% Names    : KKPxx [PS08]

% Status   : Unsatisfiable
% Rating   : 1.00 v4.0.0
% Syntax   : Number of clauses     :   12 (  12 unt;   0 nHn;   3 RR)
%            Number of literals    :   12 (  12 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   5 con; 0-2 aty)
%            Number of variables   :   17 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%------------------------------------------------------------------------------
cnf(c01,axiom,
    plus(plus(A,B),C) = plus(A,plus(B,C)) ).

cnf(c02,axiom,
    plus(A,B) = plus(B,A) ).

cnf(c03,axiom,
    plus(A,op_0) = A ).

cnf(c04,axiom,
    plus(A,minus(A)) = op_0 ).

cnf(c05,axiom,
    mult(A,plus(B,C)) = plus(mult(A,B),mult(A,C)) ).

cnf(c06,axiom,
    mult(mult(mult(A,B),C),B) = mult(A,mult(mult(B,C),B)) ).

cnf(c07,axiom,
    mult(A,mult(B,B)) = mult(mult(A,B),B) ).

cnf(c08,axiom,
    mult(A,unit) = A ).

cnf(c09,axiom,
    mult(unit,A) = A ).

cnf(c10,axiom,
    mult(op_a,op_b) = unit ).

cnf(c11,axiom,
    mult(op_b,op_a) = unit ).

cnf(goals,negated_conjecture,
    mult(mult(op_b,mult(mult(op_a,a),op_b)),op_a) != a ).

%------------------------------------------------------------------------------
