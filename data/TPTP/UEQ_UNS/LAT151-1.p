%------------------------------------------------------------------------------
% File     : LAT151-1 : TPTP v9.2.1. Released v3.1.0.
% Domain   : Lattice Theory
% Problem  : Huntington equation H39 implies H42
% Version  : [McC05] (equality) axioms : Especial.
% English  :

% Refs     : [McC05] McCune (2005), Email to Geoff Sutcliffe
% Source   : [McC05]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.74 v9.1.0, 0.86 v9.0.0, 0.77 v8.2.0, 0.75 v8.1.0, 0.95 v7.5.0, 0.88 v7.4.0, 0.96 v7.3.0, 0.89 v6.4.0, 0.95 v6.3.0, 0.94 v6.2.0, 0.86 v6.1.0, 0.88 v6.0.0, 0.86 v5.5.0, 0.89 v5.4.0, 0.93 v5.3.0, 0.92 v5.2.0, 0.93 v4.1.0, 0.91 v4.0.1, 0.93 v4.0.0, 0.92 v3.7.0, 0.78 v3.4.0, 0.75 v3.3.0, 0.86 v3.1.0
% Syntax   : Number of clauses     :   10 (  10 unt;   0 nHn;   1 RR)
%            Number of literals    :   10 (  10 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    7 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   4 con; 0-2 aty)
%            Number of variables   :   20 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%------------------------------------------------------------------------------
%----Include Lattice theory (equality) axioms
include('Axioms/LAT001-0.ax').
%------------------------------------------------------------------------------
cnf(equation_H39,axiom,
    meet(X,join(Y,meet(Z,join(X,U)))) = meet(X,join(Y,meet(Z,join(U,meet(X,Z))))) ).

cnf(prove_H42,negated_conjecture,
    meet(a,join(b,meet(c,join(a,d)))) != meet(a,join(b,meet(c,join(b,join(d,meet(a,c)))))) ).

%------------------------------------------------------------------------------
