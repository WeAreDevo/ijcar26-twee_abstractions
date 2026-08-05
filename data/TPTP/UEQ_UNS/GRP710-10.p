%------------------------------------------------------------------------------
% File     : GRP710-10 : TPTP v9.2.1. Released v8.1.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : A magma with 2-sided inverses satisfying the C-law is a loop - 1a
% Version  : Especial.
% English  : In a Bol loop, if c is a commutant element, then c^2 is in the
%            left nucleus if and only if c is in the right nucleus.

% Refs     : [PV08]  Phillips & Vojtechovsky (2008), A Scoop from Groups: N
%          : [PS08]  Phillips & Stanovsky (2008), Automated Theorem Proving
%          : [Sma21] Smallbone (2021), Email to Geoff Sutcliffe
% Source   : [Sma21]
% Names    : 

% Status   : Unsatisfiable
% Rating   : 0.04 v9.1.0, 0.14 v9.0.0, 0.09 v8.2.0, 0.17 v8.1.0
% Syntax   : Number of clauses     :    6 (   6 unt;   0 nHn;   1 RR)
%            Number of literals    :    6 (   6 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   3 con; 0-2 aty)
%            Number of variables   :    8 (   1 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : UEQ version, converted from GRP710+1.p
%------------------------------------------------------------------------------
cnf(f01,axiom,
    mult(A,unit) = A ).

cnf(f02,axiom,
    mult(unit,A) = A ).

cnf(f03,axiom,
    mult(A,mult(B,mult(B,C))) = mult(mult(mult(A,B),B),C) ).

cnf(f04,axiom,
    mult(A,i(A)) = unit ).

cnf(f05,axiom,
    mult(i(A),A) = unit ).

cnf(goal,negated_conjecture,
    mult(x0,X2) != x1 ).

%------------------------------------------------------------------------------
