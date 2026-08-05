%------------------------------------------------------------------------------
% File     : LAT161-1 : TPTP v9.2.1. Released v3.1.0.
% Domain   : Lattice Theory
% Problem  : Huntington equation H58 implies H59
% Version  : [McC05] (equality) axioms : Especial.
% English  :

% Refs     : [McC05] McCune (2005), Email to Geoff Sutcliffe
% Source   : [McC05]
% Names    :

% Status   : Unsatisfiable
% Rating   : 1.00 v9.1.0, 0.95 v9.0.0, 1.00 v8.2.0, 0.96 v8.1.0, 1.00 v3.1.0
% Syntax   : Number of clauses     :   10 (  10 unt;   0 nHn;   1 RR)
%            Number of literals    :   10 (  10 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   4 con; 0-2 aty)
%            Number of variables   :   19 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%------------------------------------------------------------------------------
%----Include Lattice theory (equality) axioms
include('Axioms/LAT001-0.ax').
%------------------------------------------------------------------------------
cnf(equation_H58,axiom,
    meet(X,join(Y,Z)) = meet(X,join(Y,meet(join(X,Y),join(Z,meet(X,Y))))) ).

cnf(prove_H59,negated_conjecture,
    meet(a,meet(join(b,c),join(b,d))) != meet(a,join(b,meet(join(b,d),join(c,meet(a,b))))) ).

%------------------------------------------------------------------------------
