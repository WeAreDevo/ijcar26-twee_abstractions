%------------------------------------------------------------------------------
% File     : LAT160-1 : TPTP v9.2.1. Released v3.1.0.
% Domain   : Lattice Theory
% Problem  : Huntington equation H52 implies H51
% Version  : [McC05] (equality) axioms : Especial.
% English  :

% Refs     : [McC05] McCune (2005), Email to Geoff Sutcliffe
% Source   : [McC05]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.70 v9.1.0, 0.68 v9.0.0, 0.73 v8.2.0, 0.75 v8.1.0, 0.80 v7.5.0, 0.83 v7.4.0, 0.87 v7.3.0, 0.79 v7.1.0, 0.78 v7.0.0, 0.79 v6.4.0, 0.89 v6.3.0, 0.88 v6.2.0, 0.79 v6.1.0, 0.88 v6.0.0, 0.90 v5.5.0, 0.89 v5.4.0, 0.80 v5.3.0, 0.75 v5.2.0, 0.71 v5.1.0, 0.67 v5.0.0, 0.71 v4.1.0, 0.64 v4.0.1, 0.71 v4.0.0, 0.69 v3.7.0, 0.56 v3.4.0, 0.50 v3.3.0, 0.64 v3.1.0
% Syntax   : Number of clauses     :   10 (  10 unt;   0 nHn;   1 RR)
%            Number of literals    :   10 (  10 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   4 con; 0-2 aty)
%            Number of variables   :   20 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%------------------------------------------------------------------------------
%----Include Lattice theory (equality) axioms
include('Axioms/LAT001-0.ax').
%------------------------------------------------------------------------------
cnf(equation_H52,axiom,
    meet(X,join(Y,meet(Z,join(X,U)))) = meet(X,join(Y,join(meet(Z,U),meet(Z,join(X,Y))))) ).

cnf(prove_H51,negated_conjecture,
    meet(a,join(b,meet(c,join(a,d)))) != meet(a,join(b,join(meet(a,c),meet(c,d)))) ).

%------------------------------------------------------------------------------
