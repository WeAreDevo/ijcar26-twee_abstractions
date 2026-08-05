%------------------------------------------------------------------------------
% File     : GRP725-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : Loops with abelian inner mapping group - commutativity
% Version  : Especial.
% English  : Uniquely 2-divisible loops with abelian inner mapping group of
%            exponent 2 are commutative.

% Refs     : [Sta08] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08]
% Names    : PSxx_1b [Sta08]

% Status   : Unsatisfiable
% Rating   : 0.96 v9.1.0, 0.95 v8.2.0, 0.96 v8.1.0, 0.95 v7.5.0, 0.92 v7.4.0, 0.96 v7.3.0, 0.89 v7.1.0, 0.94 v7.0.0, 0.95 v6.4.0, 0.89 v6.3.0, 0.88 v6.2.0, 0.86 v6.1.0, 1.00 v4.0.1, 0.93 v4.0.0
% Syntax   : Number of clauses     :   21 (  21 unt;   0 nHn;   1 RR)
%            Number of literals    :   21 (  21 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   1 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   10 (  10 usr;   3 con; 0-3 aty)
%            Number of variables   :   54 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%------------------------------------------------------------------------------
cnf(c01,axiom,
    mult(unit,A) = A ).

cnf(c02,axiom,
    mult(A,unit) = A ).

cnf(c03,axiom,
    mult(A,ld(A,B)) = B ).

cnf(c04,axiom,
    ld(A,mult(A,B)) = B ).

cnf(c05,axiom,
    rd(mult(A,B),B) = A ).

cnf(c06,axiom,
    mult(rd(A,B),B) = A ).

cnf(c07,axiom,
    mult(s(A),s(A)) = A ).

cnf(c08,axiom,
    s(mult(A,A)) = A ).

cnf(c09,axiom,
    op_l(A,B,C) = ld(mult(C,B),mult(C,mult(B,A))) ).

cnf(c10,axiom,
    op_r(A,B,C) = rd(mult(mult(A,B),C),mult(B,C)) ).

cnf(c11,axiom,
    op_t(A,B) = ld(B,mult(A,B)) ).

cnf(c12,axiom,
    op_r(op_r(A,B,C),D,E) = op_r(op_r(A,D,E),B,C) ).

cnf(c13,axiom,
    op_l(op_r(A,B,C),D,E) = op_r(op_l(A,D,E),B,C) ).

cnf(c14,axiom,
    op_l(op_l(A,B,C),D,E) = op_l(op_l(A,D,E),B,C) ).

cnf(c15,axiom,
    op_t(op_r(A,B,C),D) = op_r(op_t(A,D),B,C) ).

cnf(c16,axiom,
    op_t(op_l(A,B,C),D) = op_l(op_t(A,D),B,C) ).

cnf(c17,axiom,
    op_t(op_t(A,B),C) = op_t(op_t(A,C),B) ).

cnf(c18,axiom,
    op_t(op_t(A,B),B) = A ).

cnf(c19,axiom,
    op_r(op_r(A,B,C),B,C) = A ).

cnf(c20,axiom,
    op_l(op_l(A,B,C),B,C) = A ).

cnf(goals,negated_conjecture,
    mult(a,b) != mult(b,a) ).

%------------------------------------------------------------------------------
