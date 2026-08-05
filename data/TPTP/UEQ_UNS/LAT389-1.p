%------------------------------------------------------------------------------
% File     : LAT389-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Lattice Theory
% Problem  : Short axiom for lattice theory, part 1
% Version  : Especial.
% English  :

% Refs     : [Sta08] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.39 v9.1.0, 0.41 v8.2.0, 0.50 v8.1.0, 0.55 v7.5.0, 0.46 v7.4.0, 0.48 v7.3.0, 0.47 v7.1.0, 0.44 v7.0.0, 0.47 v6.2.0, 0.50 v6.1.0, 0.62 v6.0.0, 0.71 v5.5.0, 0.68 v5.4.0, 0.67 v5.2.0, 0.64 v5.1.0, 0.67 v5.0.0, 0.64 v4.0.1, 0.79 v4.0.0
% Syntax   : Number of clauses     :    2 (   2 unt;   0 nHn;   1 RR)
%            Number of literals    :    2 (   2 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :   11 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   3 con; 0-2 aty)
%            Number of variables   :    8 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%------------------------------------------------------------------------------
cnf(sos,axiom,
    mult(plus(mult(plus(A,B),plus(B,mult(A,B))),C),plus(mult(plus(A,mult(mult(plus(D,B),plus(B,E)),B)),plus(mult(plus(B,plus(plus(mult(D,mult(B,E)),mult(F,B)),B)),plus(V6,mult(B,plus(plus(mult(B,V7),mult(F,B)),B)))),mult(A,mult(mult(plus(D,B),plus(B,E)),B)))),mult(mult(plus(A,B),plus(B,mult(A,B))),C))) = B ).

cnf(goals,negated_conjecture,
    mult(a,plus(b,plus(a,c))) != a ).

%------------------------------------------------------------------------------
