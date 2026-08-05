%------------------------------------------------------------------------------
% File     : LAT168-1 : TPTP v9.2.1. Released v3.1.0.
% Domain   : Lattice Theory
% Problem  : Huntington equation H18_dual implies H58
% Version  : [McC05] (equality) axioms : Especial.
% English  :

% Refs     : [McC05] McCune (2005), Email to Geoff Sutcliffe
% Source   : [McC05]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.35 v9.1.0, 0.27 v9.0.0, 0.32 v8.2.0, 0.33 v8.1.0, 0.30 v7.5.0, 0.29 v7.4.0, 0.30 v7.3.0, 0.21 v7.1.0, 0.28 v7.0.0, 0.26 v6.3.0, 0.29 v6.1.0, 0.38 v6.0.0, 0.57 v5.5.0, 0.47 v5.4.0, 0.33 v5.2.0, 0.36 v5.1.0, 0.27 v5.0.0, 0.21 v4.1.0, 0.27 v4.0.1, 0.14 v4.0.0, 0.23 v3.7.0, 0.22 v3.4.0, 0.25 v3.3.0, 0.21 v3.2.0, 0.14 v3.1.0
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
cnf(equation_H18_dual,axiom,
    meet(join(X,Y),join(X,Z)) = join(X,meet(join(X,Y),meet(join(X,Z),join(Y,meet(X,Z))))) ).

cnf(prove_H58,negated_conjecture,
    meet(a,join(b,c)) != meet(a,join(b,meet(join(a,b),join(c,meet(a,b))))) ).

%------------------------------------------------------------------------------
