%------------------------------------------------------------------------------
% File     : GRP718-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : In a commutative RIF loop, all squares are Moufang elements
% Version  : Especial.
% English  :

% Refs     : [PS08]  Phillips & Stanovsky (2008), Automated Theorem Proving
%          : [Sta08] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08]
% Names    : KVxx [PS08]

% Status   : Unsatisfiable
% Rating   : 0.78 v9.1.0, 0.77 v8.2.0, 0.83 v8.1.0, 0.90 v7.5.0, 0.83 v7.3.0, 0.79 v7.2.0, 0.84 v7.1.0, 0.78 v7.0.0, 0.79 v6.3.0, 0.76 v6.2.0, 0.71 v6.1.0, 0.81 v6.0.0, 0.90 v5.5.0, 0.89 v5.4.0, 0.87 v5.3.0, 0.83 v5.2.0, 0.86 v5.1.0, 0.87 v5.0.0, 0.86 v4.1.0, 0.82 v4.0.1, 0.93 v4.0.0
% Syntax   : Number of clauses     :   11 (  11 unt;   0 nHn;   1 RR)
%            Number of literals    :   11 (  11 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   4 con; 0-2 aty)
%            Number of variables   :   19 (   0 sgn)
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
    mult(i(A),mult(A,B)) = B ).

cnf(c08,axiom,
    mult(mult(A,B),i(B)) = A ).

cnf(c09,axiom,
    mult(mult(A,B),mult(C,mult(A,B))) = mult(mult(mult(A,mult(B,C)),A),B) ).

cnf(c10,axiom,
    mult(A,B) = mult(B,A) ).

cnf(goals,negated_conjecture,
    mult(mult(a,a),mult(mult(b,c),mult(a,a))) != mult(mult(mult(a,a),b),mult(c,mult(a,a))) ).

%------------------------------------------------------------------------------
