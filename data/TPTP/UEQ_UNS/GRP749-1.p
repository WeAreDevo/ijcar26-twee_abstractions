%------------------------------------------------------------------------------
% File     : GRP749-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : Simplifying a basis for trimedial quasigroups: part 1
% Version  : Especial.
% English  :

% Refs     : [KP02]  Kinyon & Phillips (2002), A Note on Trimedial Quasigro
%          : [Sta08] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08]
% Names    : KP02_1 [Sta08]

% Status   : Unsatisfiable
% Rating   : 1.00 v4.0.0
% Syntax   : Number of clauses     :    7 (   7 unt;   0 nHn;   1 RR)
%            Number of literals    :    7 (   7 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   3 con; 0-2 aty)
%            Number of variables   :   14 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%------------------------------------------------------------------------------
cnf(f01,axiom,
    mult(A,ld(A,B)) = B ).

cnf(f02,axiom,
    ld(A,mult(A,B)) = B ).

cnf(f03,axiom,
    mult(rd(A,B),B) = A ).

cnf(f04,axiom,
    rd(mult(A,B),B) = A ).

cnf(f05,axiom,
    mult(mult(A,mult(A,A)),mult(B,C)) = mult(mult(A,B),mult(mult(A,A),C)) ).

cnf(f06,axiom,
    mult(mult(A,A),mult(B,C)) = mult(mult(A,B),mult(A,C)) ).

cnf(goals,negated_conjecture,
    mult(mult(a,b),mult(c,c)) != mult(mult(a,c),mult(b,c)) ).

%------------------------------------------------------------------------------
