%------------------------------------------------------------------------------
% File     : LAT401-1 : TPTP v9.2.1. Released v8.1.0.
% Domain   : Lattice Theory (Relational lattices)
% Problem  : Appendix C, Theorem 3.4, clause 9.
% Version  : [LMH16] axioms.
% English  :

% Refs     : [LMH16] Litak et al. (2016), Relational Lattices: From Databas
%          : [Sma21] Smallbone (2021), Email to Geoff Sutcliffe
% Source   : [Sma21]
% Names    : rellat_appendixc.p [Sma21]

% Status   : Unsatisfiable
% Rating   : 0.87 v9.1.0, 0.82 v9.0.0, 0.86 v8.2.0, 0.83 v8.1.0
% Syntax   : Number of clauses     :   14 (  14 unt;   0 nHn;   3 RR)
%            Number of literals    :   14 (  14 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    9 (   9 usr;   4 con; 0-3 aty)
%            Number of variables   :   29 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%------------------------------------------------------------------------------
cnf(commutativity,axiom,
    meet(X,Y) = meet(Y,X) ).

cnf(associativity,axiom,
    meet(X,meet(Y,Z)) = meet(meet(X,Y),Z) ).

cnf(commutativity_001,axiom,
    join(X,Y) = join(Y,X) ).

cnf(associativity_002,axiom,
    join(X,join(Y,Z)) = join(join(X,Y),Z) ).

cnf(absorption,axiom,
    join(X,meet(X,Y)) = X ).

cnf(absorption_003,axiom,
    meet(X,join(X,Y)) = X ).

cnf(definition_of_upme,axiom,
    upme(X,Y,Z) = meet(X,join(Y,Z)) ).

cnf(definition_of_upjo,axiom,
    upjo(X,Y,Z) = meet(join(X,Y),join(X,Z)) ).

cnf(definition_of_lojo,axiom,
    lojo(X,Y,Z) = join(X,meet(Y,Z)) ).

cnf(upme_property_1,axiom,
    join(upme(meet(a,X1),Y1,Z1),meet(Y1,Z1)) = meet(join(meet(meet(a,X1),Y1),Z1),join(meet(meet(a,X1),Z1),Y1)) ).

cnf(upme_property_2,axiom,
    upme(X,Y,Z) = join(upme(X,Y,meet(a,Z)),upme(X,Z,meet(a,Y))) ).

cnf(conjecture,negated_conjecture,
    upme(a,x2,y2) = upme(a,x2,z2) ).

cnf(conjecture_1,negated_conjecture,
    upme(a,x2,y2) = upme(a,y2,z2) ).

cnf(conjecture_2,negated_conjecture,
    upjo(x2,y2,z2) != lojo(x2,y2,z2) ).

%------------------------------------------------------------------------------
