%------------------------------------------------------------------------------
% File     : GRP684-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : Axioms of rectangular loops - c
% Version  : Especial.
% English  :

% Refs     : [KP05]  Kinyon & Phillips (2005), Rectangular Quasigroups and
%          : [PS08]  Phillips & Stanovsky (2008), Automated Theorem Proving
%          : [Sta08] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08]
% Names    : KP05 [PS08]

% Status   : Unsatisfiable
% Rating   : 0.04 v9.1.0, 0.14 v9.0.0, 0.09 v8.2.0, 0.17 v8.1.0, 0.20 v7.5.0, 0.17 v7.4.0, 0.26 v7.3.0, 0.16 v7.1.0, 0.06 v7.0.0, 0.11 v6.4.0, 0.16 v6.3.0, 0.12 v6.2.0, 0.14 v6.1.0, 0.12 v6.0.0, 0.24 v5.5.0, 0.21 v5.4.0, 0.07 v5.3.0, 0.08 v5.2.0, 0.07 v5.1.0, 0.20 v5.0.0, 0.14 v4.1.0, 0.18 v4.0.1, 0.50 v4.0.0
% Syntax   : Number of clauses     :    8 (   8 unt;   0 nHn;   1 RR)
%            Number of literals    :    8 (   8 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   3 con; 0-2 aty)
%            Number of variables   :   16 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%------------------------------------------------------------------------------
cnf(c01,axiom,
    ld(A,mult(A,A)) = A ).

cnf(c02,axiom,
    rd(mult(A,A),A) = A ).

cnf(c03,axiom,
    mult(A,ld(A,B)) = ld(A,mult(A,B)) ).

cnf(c04,axiom,
    mult(rd(A,B),B) = rd(mult(A,B),B) ).

cnf(c05,axiom,
    ld(ld(A,B),mult(ld(A,B),mult(C,D))) = mult(ld(A,mult(A,C)),D) ).

cnf(c06,axiom,
    rd(mult(mult(A,B),rd(C,D)),rd(C,D)) = mult(A,rd(mult(B,D),D)) ).

cnf(c07,axiom,
    ld(A,mult(A,ld(B,B))) = rd(mult(rd(A,A),B),B) ).

cnf(goals,negated_conjecture,
    rd(mult(a,mult(b,c)),mult(b,c)) != rd(mult(a,c),c) ).

%------------------------------------------------------------------------------
