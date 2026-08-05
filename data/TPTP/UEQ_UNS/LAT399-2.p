%------------------------------------------------------------------------------
% File     : LAT399-2 : TPTP v9.2.1. Released v8.1.0.
% Domain   : Lattice Theory (Relational lattices)
% Problem  : Appendix A, Theorem 3.4, clause 7
% Version  : [LMH16] axioms : Augmented.
% English  :

% Refs     : [LMH16] Litak et al. (2016), Relational Lattices: From Databas
%          : [Sma21] Smallbone (2021), Email to Geoff Sutcliffe
% Source   : [Sma21]
% Names    : rellat_appendixa_extradefs.p [Sma21]

% Status   : Unsatisfiable
% Rating   : 0.61 v9.1.0, 0.68 v9.0.0, 0.64 v8.2.0, 0.58 v8.1.0
% Syntax   : Number of clauses     :   12 (  12 unt;   0 nHn;   1 RR)
%            Number of literals    :   12 (  12 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   10 (  10 usr;   4 con; 0-3 aty)
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

cnf(definition_of_lome,axiom,
    lome(X,Y,Z) = join(meet(X,Y),meet(X,Z)) ).

cnf(definition_of_upjo,axiom,
    upjo(X,Y,Z) = meet(join(X,Y),join(X,Z)) ).

cnf(definition_of_lojo,axiom,
    lojo(X,Y,X1) = join(X,meet(Y,X1)) ).

cnf(conjecture,negated_conjecture,
    join(upme(meet(a,X1),Y1,W),meet(Y1,W)) = meet(join(meet(meet(a,X1),Y1),W),join(meet(meet(a,X1),W),Y1)) ).

cnf(conjecture_1,negated_conjecture,
    upme(meet(a,z1),z2,z3) != lome(meet(a,z1),z2,z3) ).

%------------------------------------------------------------------------------
