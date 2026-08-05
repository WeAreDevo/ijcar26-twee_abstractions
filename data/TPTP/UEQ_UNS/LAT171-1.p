%------------------------------------------------------------------------------
% File     : LAT171-1 : TPTP v9.2.1. Released v3.1.0.
% Domain   : Lattice Theory
% Problem  : Huntington equation H61_dual implies H6
% Version  : [McC05] (equality) axioms : Especial.
% English  :

% Refs     : [McC05] McCune (2005), Email to Geoff Sutcliffe
% Source   : [McC05]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.57 v9.1.0, 0.45 v9.0.0, 0.50 v8.1.0, 0.55 v7.5.0, 0.42 v7.4.0, 0.43 v7.3.0, 0.32 v7.2.0, 0.37 v7.1.0, 0.44 v7.0.0, 0.47 v6.4.0, 0.53 v6.2.0, 0.50 v6.1.0, 0.62 v6.0.0, 0.76 v5.5.0, 0.79 v5.4.0, 0.80 v5.3.0, 0.75 v5.2.0, 0.79 v5.1.0, 0.73 v5.0.0, 0.64 v4.1.0, 0.55 v4.0.1, 0.57 v4.0.0, 0.54 v3.7.0, 0.33 v3.4.0, 0.25 v3.3.0, 0.57 v3.2.0, 0.50 v3.1.0
% Syntax   : Number of clauses     :   10 (  10 unt;   0 nHn;   1 RR)
%            Number of literals    :   10 (  10 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   3 con; 0-2 aty)
%            Number of variables   :   19 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%------------------------------------------------------------------------------
%----Include Lattice theory (equality) axioms
include('Axioms/LAT001-0.ax').
%------------------------------------------------------------------------------
cnf(equation_H61_dual,axiom,
    join(meet(X,Y),meet(X,Z)) = meet(X,join(meet(X,Y),meet(join(X,Y),Z))) ).

cnf(prove_H6,negated_conjecture,
    meet(a,join(b,meet(a,c))) != meet(a,join(meet(a,join(b,meet(a,c))),meet(c,join(a,b)))) ).

%------------------------------------------------------------------------------
