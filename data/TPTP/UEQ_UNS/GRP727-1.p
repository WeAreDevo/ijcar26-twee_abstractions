%------------------------------------------------------------------------------
% File     : GRP727-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : Bruck loops that are centrally nilpotent - 1st easy part
% Version  : Especial.
% English  : Bruck loops with abelian inner mapping group are centrally
%            nilpotent of class two - 1st easy part.

% Refs     : [Sta08] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08]
% Names    : PSxx_3 [Sta08]

% Status   : Unsatisfiable
% Rating   : 0.61 v9.1.0, 0.68 v9.0.0, 0.64 v8.2.0, 0.62 v8.1.0, 0.60 v7.5.0, 0.75 v7.4.0, 0.78 v7.3.0, 0.74 v7.1.0, 0.72 v7.0.0, 0.74 v6.3.0, 0.71 v6.1.0, 0.75 v6.0.0, 0.81 v5.5.0, 0.84 v5.4.0, 0.87 v5.3.0, 0.92 v5.2.0, 0.86 v5.1.0, 0.87 v5.0.0, 0.86 v4.1.0, 0.91 v4.0.1, 0.93 v4.0.0
% Syntax   : Number of clauses     :   21 (  21 unt;   0 nHn;   1 RR)
%            Number of literals    :   21 (  21 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   13 (  13 usr;   6 con; 0-3 aty)
%            Number of variables   :   57 (   5 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%------------------------------------------------------------------------------
cnf(c01,axiom,
    mult(unit,A) = A ).

cnf(c02,axiom,
    mult(A,unit) = A ).

cnf(c03,axiom,
    mult(A,i(A)) = unit ).

cnf(c04,axiom,
    mult(i(A),A) = unit ).

cnf(c05,axiom,
    i(mult(A,B)) = mult(i(A),i(B)) ).

cnf(c06,axiom,
    mult(i(A),mult(A,B)) = B ).

cnf(c07,axiom,
    rd(mult(A,B),B) = A ).

cnf(c08,axiom,
    mult(rd(A,B),B) = A ).

cnf(c09,axiom,
    mult(mult(A,mult(B,A)),C) = mult(A,mult(B,mult(A,C))) ).

cnf(c10,axiom,
    mult(mult(A,B),C) = mult(mult(A,mult(B,C)),asoc(A,B,C)) ).

cnf(c11,axiom,
    op_l(A,B,C) = mult(i(mult(C,B)),mult(C,mult(B,A))) ).

cnf(c12,axiom,
    op_r(A,B,C) = rd(mult(mult(A,B),C),mult(B,C)) ).

cnf(c13,axiom,
    op_t(A,B) = mult(i(B),mult(A,B)) ).

cnf(c14,axiom,
    op_r(op_r(A,B,C),D,E) = op_r(op_r(A,D,E),B,C) ).

cnf(c15,axiom,
    op_l(op_r(A,B,C),D,E) = op_r(op_l(A,D,E),B,C) ).

cnf(c16,axiom,
    op_l(op_l(A,B,C),D,E) = op_l(op_l(A,D,E),B,C) ).

cnf(c17,axiom,
    op_t(op_r(A,B,C),D) = op_r(op_t(A,D),B,C) ).

cnf(c18,axiom,
    op_t(op_l(A,B,C),D) = op_l(op_t(A,D),B,C) ).

cnf(c19,axiom,
    op_t(op_t(A,B),C) = op_t(op_t(A,C),B) ).

cnf(c20,axiom,
    asoc(asoc(A,B,C),D,E) = unit ).

cnf(goals,negated_conjecture,
    asoc(a,b,asoc(c,d,e)) != unit ).

%------------------------------------------------------------------------------
