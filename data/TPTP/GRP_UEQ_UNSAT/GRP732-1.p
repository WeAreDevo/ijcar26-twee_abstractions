%------------------------------------------------------------------------------
% File     : GRP732-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : Basarab's theorem on CC loops
% Version  : Especial.
% English  :

% Refs     : [Sta08] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08]
% Names    :

% Status   : Unsatisfiable
% Rating   : 1.00 v4.0.0
% Syntax   : Number of clauses     :    9 (   9 unt;   0 nHn;   1 RR)
%            Number of literals    :    9 (   9 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   5 con; 0-2 aty)
%            Number of variables   :   16 (   0 sgn)
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
    mult(rd(mult(A,B),A),mult(A,C)) = mult(A,mult(B,C)) ).

cnf(c08,axiom,
    mult(mult(A,B),ld(B,mult(C,B))) = mult(mult(A,C),B) ).

cnf(goals,negated_conjecture,
    mult(a,mult(b,ld(mult(c,d),mult(d,c)))) != mult(mult(a,b),ld(mult(c,d),mult(d,c))) ).

%------------------------------------------------------------------------------
