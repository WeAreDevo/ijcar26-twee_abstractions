%------------------------------------------------------------------------------
% File     : RNG128-1 : TPTP v9.2.1. Released v5.4.0.
% Domain   : Ring Theory
% Problem  : In commutative semirings with 1+x+x^2=x, the operations coincide
% Version  : Especial
% English  :

% Refs     : [Sta11] Stanovsky (2011), Email to Geoff Sutcliffe
% Source   : [Sta11]
% Names    : rng1 [Sta11]

% Status   : Unsatisfiable
% Rating   : 0.00 v7.5.0, 0.04 v7.4.0, 0.13 v7.3.0, 0.05 v7.1.0, 0.00 v7.0.0, 0.05 v6.4.0, 0.11 v6.3.0, 0.12 v6.2.0, 0.14 v6.1.0, 0.12 v6.0.0, 0.24 v5.5.0, 0.26 v5.4.0
% Syntax   : Number of clauses     :    8 (   8 unt;   0 nHn;   1 RR)
%            Number of literals    :    8 (   8 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   1 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   4 con; 0-2 aty)
%            Number of variables   :   13 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : 
%------------------------------------------------------------------------------
cnf(sos,axiom,
    add(A,add(B,C)) = add(add(A,B),C) ).

cnf(sos_001,axiom,
    add(A,B) = add(B,A) ).

cnf(sos_002,axiom,
    mult(A,B) = mult(B,A) ).

cnf(sos_003,axiom,
    mult(A,add(B,C)) = add(mult(A,B),mult(A,C)) ).

cnf(sos_004,axiom,
    add(zero,A) = A ).

cnf(sos_005,axiom,
    mult(A,unit) = A ).

cnf(sos_006,axiom,
    add(unit,add(A,mult(A,A))) = A ).

cnf(goals,negated_conjecture,
    add(x0,x1) != mult(x0,x1) ).

%------------------------------------------------------------------------------
