%------------------------------------------------------------------------------
% File     : LAT394-2 : TPTP v9.2.1. Released v5.4.0.
% Domain   : Lattice Theory
% Problem  : Ortholattices in terms of Sheffer stroke: unit
% Version  : Especial
% English  :

% Refs     : [Sta11] Stanovsky (2011), Email to Geoff Sutcliffe
% Source   : [Sta11]
% Names    : lat4 [Sta11]

% Status   : Unsatisfiable
% Rating   : 0.13 v9.1.0, 0.18 v8.2.0, 0.21 v8.1.0, 0.25 v7.4.0, 0.30 v7.3.0, 0.21 v7.1.0, 0.11 v7.0.0, 0.16 v6.4.0, 0.21 v6.3.0, 0.24 v6.2.0, 0.21 v6.1.0, 0.25 v6.0.0, 0.38 v5.5.0, 0.42 v5.4.0
% Syntax   : Number of clauses     :    2 (   2 unt;   0 nHn;   1 RR)
%            Number of literals    :    2 (   2 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    7 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    3 (   3 usr;   2 con; 0-2 aty)
%            Number of variables   :    4 (   1 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : 
%------------------------------------------------------------------------------
cnf(sos,axiom,
    f(f(f(f(A,B),f(B,C)),D),f(B,f(f(B,f(f(A,A),A)),C))) = B ).

cnf(goals,negated_conjecture,
    f(x0,f(x0,x0)) != f(x1,f(x1,x1)) ).

%------------------------------------------------------------------------------
