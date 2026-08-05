%------------------------------------------------------------------------------
% File     : GRP736-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : Nonmedial left distributive left 3-symmetric quasigroup
% Version  : Especial.
% English  :

% Refs     : [Sta08] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08]
% Names    :

% Status   : Unknown
% Rating   : 1.00 v4.0.0
% Syntax   : Number of clauses     :    5 (   5 unt;   0 nHn;   1 RR)
%            Number of literals    :    5 (   5 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   4 con; 0-2 aty)
%            Number of variables   :    9 (   0 sgn)
% SPC      : CNF_UNK_RFO_PEQ_UEQ

% Comments : Size ?? (I am pretty much sure it exists, but never formally
%            proved so).
%------------------------------------------------------------------------------
cnf(c01,axiom,
    mult(A,mult(B,C)) = mult(mult(A,B),mult(A,C)) ).

cnf(c02,axiom,
    rd(mult(A,B),B) = A ).

cnf(c03,axiom,
    mult(rd(A,B),B) = A ).

cnf(c04,axiom,
    mult(A,mult(A,mult(A,B))) = B ).

cnf(goals,negated_conjecture,
    mult(mult(a,b),mult(c,d)) != mult(mult(a,c),mult(b,d)) ).

%------------------------------------------------------------------------------
