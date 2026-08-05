%------------------------------------------------------------------------------
% File     : GRP679-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : Commutants in Bol loops 1
% Version  : Especial.
% English  : If Q is a Bol loop, and if a,b in C(Q), then so are a^2, b^-1,
%            and a^2b.

% Refs     : [KP04]  Kinyon & Phillips (2004), Commutants of Bol Loops of O
%          : [PS08]  Phillips & Stanovsky (2008), Automated Theorem Proving
%          : [Sta08] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08]
% Names    : KP04 [PS08]

% Status   : Unsatisfiable
% Rating   : 0.00 v9.1.0, 0.09 v9.0.0, 0.05 v8.2.0, 0.12 v8.1.0, 0.15 v7.5.0, 0.08 v7.4.0, 0.22 v7.3.0, 0.11 v7.1.0, 0.00 v7.0.0, 0.05 v6.4.0, 0.11 v6.3.0, 0.12 v6.2.0, 0.14 v6.1.0, 0.12 v6.0.0, 0.29 v5.5.0, 0.26 v5.4.0, 0.07 v5.3.0, 0.08 v5.2.0, 0.14 v5.1.0, 0.20 v5.0.0, 0.14 v4.1.0, 0.18 v4.0.1, 0.50 v4.0.0
% Syntax   : Number of clauses     :    9 (   9 unt;   0 nHn;   1 RR)
%            Number of literals    :    9 (   9 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   3 con; 0-2 aty)
%            Number of variables   :   14 (   0 sgn)
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
    mult(A,mult(B,mult(A,C))) = mult(mult(A,mult(B,A)),C) ).

cnf(c08,axiom,
    mult(op_c,A) = mult(A,op_c) ).

cnf(goals,negated_conjecture,
    mult(mult(op_c,op_c),a) != mult(a,mult(op_c,op_c)) ).

%------------------------------------------------------------------------------
