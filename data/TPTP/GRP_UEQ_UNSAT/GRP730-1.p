%------------------------------------------------------------------------------
% File     : GRP730-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : Bruck loops that are centrally nilpotent - 2nd easy part c
% Version  : Especial.
% English  : Bruck loops with abelian inner mapping group are centrally
%            nilpotent of class two - 2nd easy part.

% Refs     : [Sta08] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08]
% Names    : PSxx_4c [Sta08]

% Status   : Unsatisfiable
% Rating   : 0.35 v9.1.0, 0.36 v8.2.0, 0.42 v8.1.0, 0.35 v7.5.0, 0.46 v7.4.0, 0.48 v7.3.0, 0.42 v7.1.0, 0.33 v7.0.0, 0.37 v6.4.0, 0.42 v6.3.0, 0.41 v6.2.0, 0.50 v6.1.0, 0.56 v6.0.0, 0.62 v5.5.0, 0.63 v5.4.0, 0.60 v5.3.0, 0.67 v5.2.0, 0.64 v5.1.0, 0.67 v5.0.0, 0.64 v4.0.0
% Syntax   : Number of clauses     :   23 (  23 unt;   0 nHn;   1 RR)
%            Number of literals    :   23 (  23 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   13 (  13 usr;   5 con; 0-3 aty)
%            Number of variables   :   64 (  10 sgn)
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
    mult(A,B) = mult(mult(B,A),op_k(A,B)) ).

cnf(c12,axiom,
    op_l(A,B,C) = mult(i(mult(C,B)),mult(C,mult(B,A))) ).

cnf(c13,axiom,
    op_r(A,B,C) = rd(mult(mult(A,B),C),mult(B,C)) ).

cnf(c14,axiom,
    op_t(A,B) = mult(i(B),mult(A,B)) ).

cnf(c15,axiom,
    op_r(op_r(A,B,C),D,E) = op_r(op_r(A,D,E),B,C) ).

cnf(c16,axiom,
    op_l(op_r(A,B,C),D,E) = op_r(op_l(A,D,E),B,C) ).

cnf(c17,axiom,
    op_l(op_l(A,B,C),D,E) = op_l(op_l(A,D,E),B,C) ).

cnf(c18,axiom,
    op_t(op_r(A,B,C),D) = op_r(op_t(A,D),B,C) ).

cnf(c19,axiom,
    op_t(op_l(A,B,C),D) = op_l(op_t(A,D),B,C) ).

cnf(c20,axiom,
    op_t(op_t(A,B),C) = op_t(op_t(A,C),B) ).

cnf(c21,axiom,
    asoc(asoc(A,B,C),D,E) = unit ).

cnf(c22,axiom,
    asoc(A,B,asoc(C,D,E)) = unit ).

cnf(goals,negated_conjecture,
    asoc(op_k(a,b),c,d) != unit ).

%------------------------------------------------------------------------------
