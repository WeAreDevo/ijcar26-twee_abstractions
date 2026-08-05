%------------------------------------------------------------------------------
% File     : LAT394-1 : TPTP v9.2.1. Released v5.4.0.
% Domain   : Lattice Theory
% Problem  : Ortholattices in terms of Sheffer stroke + usual operations: unit
% Version  : Especial
% English  :

% Refs     : [Sta11] Stanovsky (2011), Email to Geoff Sutcliffe
% Source   : [Sta11]
% Names    : lat3 [Sta11]

% Status   : Unsatisfiable
% Rating   : 0.22 v9.1.0, 0.27 v9.0.0, 0.23 v8.2.0, 0.25 v7.5.0, 0.29 v7.4.0, 0.35 v7.3.0, 0.26 v7.1.0, 0.17 v7.0.0, 0.21 v6.4.0, 0.26 v6.3.0, 0.29 v6.1.0, 0.31 v6.0.0, 0.43 v5.5.0, 0.47 v5.4.0
% Syntax   : Number of clauses     :    5 (   5 unt;   0 nHn;   1 RR)
%            Number of literals    :    5 (   5 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    7 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   2 con; 0-2 aty)
%            Number of variables   :    9 (   1 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : 
%------------------------------------------------------------------------------
cnf(sos,axiom,
    f(f(f(f(A,B),f(B,C)),D),f(B,f(f(B,f(f(A,A),A)),C))) = B ).

cnf(sos_001,axiom,
    or(A,B) = f(f(A,A),f(B,B)) ).

cnf(sos_002,axiom,
    and(A,B) = f(f(A,B),f(A,B)) ).

cnf(sos_003,axiom,
    neg(A) = f(A,A) ).

cnf(goals,negated_conjecture,
    f(x0,f(x0,x0)) != f(x1,f(x1,x1)) ).

%------------------------------------------------------------------------------
