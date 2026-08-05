%------------------------------------------------------------------------------
% File     : LAT143-1 : TPTP v9.2.1. Released v3.1.0.
% Domain   : Lattice Theory
% Problem  : Huntington equation H24 implies H15
% Version  : [McC05] (equality) axioms : Especial.
% English  :

% Refs     : [McC05] McCune (2005), Email to Geoff Sutcliffe
% Source   : [McC05]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.26 v9.1.0, 0.18 v9.0.0, 0.23 v8.2.0, 0.21 v8.1.0, 0.30 v7.5.0, 0.17 v7.4.0, 0.22 v7.3.0, 0.21 v7.2.0, 0.16 v7.1.0, 0.28 v7.0.0, 0.32 v6.4.0, 0.37 v6.3.0, 0.35 v6.2.0, 0.29 v6.1.0, 0.38 v6.0.0, 0.57 v5.5.0, 0.58 v5.4.0, 0.47 v5.3.0, 0.33 v5.2.0, 0.43 v5.1.0, 0.47 v5.0.0, 0.29 v4.1.0, 0.27 v4.0.1, 0.36 v4.0.0, 0.31 v3.7.0, 0.11 v3.4.0, 0.25 v3.3.0, 0.21 v3.2.0, 0.14 v3.1.0
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
cnf(equation_H24,axiom,
    join(meet(X,Y),meet(Y,Z)) = join(meet(X,Y),meet(Y,join(meet(X,Y),meet(Z,join(X,Y))))) ).

cnf(prove_H15,negated_conjecture,
    meet(a,join(meet(a,b),meet(a,c))) != meet(a,join(meet(a,b),join(meet(a,c),meet(c,join(a,b))))) ).

%------------------------------------------------------------------------------
