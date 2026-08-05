%------------------------------------------------------------------------------
% File     : LAT393-2 : TPTP v9.2.1. Released v5.4.0.
% Domain   : Lattice Theory
% Problem  : Ortholattices in terms of Sheffer stroke: associativity
% Version  : Especial
% English  :

% Refs     : [Sta11] Stanovsky (2011), Email to Geoff Sutcliffe
% Source   : [Sta11]
% Names    : lat2 [Sta11]

% Status   : Unsatisfiable
% Rating   : 0.74 v9.1.0, 0.73 v9.0.0, 0.77 v8.2.0, 0.71 v8.1.0, 0.70 v7.5.0, 0.83 v7.4.0, 0.91 v7.3.0, 0.79 v7.1.0, 0.78 v7.0.0, 0.84 v6.4.0, 0.89 v6.3.0, 0.88 v6.2.0, 0.86 v6.1.0, 0.88 v6.0.0, 0.90 v5.5.0, 0.89 v5.4.0
% Syntax   : Number of clauses     :    2 (   2 unt;   0 nHn;   1 RR)
%            Number of literals    :    2 (   2 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    7 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    4 (   4 usr;   3 con; 0-2 aty)
%            Number of variables   :    4 (   1 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : 
%------------------------------------------------------------------------------
cnf(sos,axiom,
    f(f(f(f(A,B),f(B,C)),D),f(B,f(f(B,f(f(A,A),A)),C))) = B ).

cnf(goals,negated_conjecture,
    f(x0,f(f(x1,x2),f(x1,x2))) != f(x1,f(f(x0,x2),f(x0,x2))) ).

%------------------------------------------------------------------------------
