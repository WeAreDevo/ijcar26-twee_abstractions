%------------------------------------------------------------------------------
% File     : GRP740-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : Proper commutative Moufang loop
% Version  : Especial.
% English  :

% Refs     : [Sta08] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08]
% Names    :

% Status   : Unsatisfiable
% Rating   : 1.00 v6.1.0, 0.80 v6.0.0, 1.00 v4.0.0
% Syntax   : Number of clauses     :   12 (  12 unt;   0 nHn;   1 RR)
%            Number of literals    :   12 (  12 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   4 con; 0-2 aty)
%            Number of variables   :   24 (   0 sgn)
% SPC      : CNF_SAT_RFO_PEQ_UEQ

% Comments : Size 81
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
    mult(A,mult(B,mult(A,C))) = mult(mult(mult(A,B),A),C) ).

cnf(c08,axiom,
    mult(A,mult(B,mult(C,B))) = mult(mult(mult(A,B),C),B) ).

cnf(c09,axiom,
    mult(mult(A,B),mult(C,A)) = mult(mult(A,mult(B,C)),A) ).

cnf(c10,axiom,
    mult(mult(A,B),mult(C,A)) = mult(A,mult(mult(B,C),A)) ).

cnf(c11,axiom,
    mult(A,B) = mult(B,A) ).

cnf(goals,negated_conjecture,
    mult(mult(a,b),c) != mult(a,mult(b,c)) ).

%------------------------------------------------------------------------------
