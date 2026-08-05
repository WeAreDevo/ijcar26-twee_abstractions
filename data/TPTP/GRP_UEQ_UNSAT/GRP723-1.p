%------------------------------------------------------------------------------
% File     : GRP723-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : In commutative A-loops of exp 2 square-subloop is associative
% Version  : Especial.
% English  :

% Refs     : [Sta08] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08]
% Names    : JKVxx_4 [Sta08]

% Status   : Unsatisfiable
% Rating   : 1.00 v4.0.0
% Syntax   : Number of clauses     :   10 (  10 unt;   0 nHn;   1 RR)
%            Number of literals    :   10 (  10 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   4 con; 0-2 aty)
%            Number of variables   :   18 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%------------------------------------------------------------------------------
cnf(c01,axiom,
    mult(A,unit) = A ).

cnf(c02,axiom,
    mult(unit,A) = A ).

cnf(c03,axiom,
    mult(A,ld(A,B)) = B ).

cnf(c04,axiom,
    ld(A,mult(A,B)) = B ).

cnf(c05,axiom,
    mult(A,B) = mult(B,A) ).

cnf(c06,axiom,
    ld(mult(A,B),mult(A,mult(B,mult(C,D)))) = mult(ld(mult(A,B),mult(A,mult(B,C))),ld(mult(A,B),mult(A,mult(B,D)))) ).

cnf(c07,axiom,
    ld(A,mult(mult(B,C),A)) = mult(ld(A,mult(B,A)),ld(A,mult(C,A))) ).

cnf(c08,axiom,
    mult(A,A) = unit ).

cnf(c09,axiom,
    f(A,B) = ld(B,ld(mult(A,B),B)) ).

cnf(goals,negated_conjecture,
    f(a,f(b,c)) != f(f(a,b),c) ).

%------------------------------------------------------------------------------
