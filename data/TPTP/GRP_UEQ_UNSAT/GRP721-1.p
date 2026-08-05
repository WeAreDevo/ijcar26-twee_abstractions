%------------------------------------------------------------------------------
% File     : GRP721-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : In commutative A-loops squares form a subloop - a witnessing term
% Version  : Especial.
% English  :

% Refs     : [Sta08] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08]
% Names    : JKVxx_2 [Sta08]

% Status   : Unsatisfiable
% Rating   : 0.91 v8.2.0, 0.88 v8.1.0, 0.90 v7.5.0, 0.92 v7.4.0, 0.96 v7.3.0, 0.89 v7.1.0, 0.94 v7.0.0, 0.95 v6.3.0, 0.94 v6.2.0, 0.93 v6.1.0, 1.00 v5.0.0, 0.93 v4.1.0, 0.91 v4.0.1, 1.00 v4.0.0
% Syntax   : Number of clauses     :    9 (   9 unt;   0 nHn;   1 RR)
%            Number of literals    :    9 (   9 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   3 con; 0-2 aty)
%            Number of variables   :   17 (   0 sgn)
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
    f(A,B) = ld(mult(ld(mult(A,B),A),ld(mult(A,B),B)),unit) ).

cnf(goals,negated_conjecture,
    mult(mult(a,a),mult(b,b)) != mult(f(a,b),f(a,b)) ).

%------------------------------------------------------------------------------
