%------------------------------------------------------------------------------
% File     : LAT065-10 : TPTP v9.2.1. Released v7.5.0.
% Domain   : Puzzles
% Problem  : Weak property 94-37 to make uniquely complemented lattice Boolean
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.96 v9.1.0, 0.95 v8.2.0, 0.96 v8.1.0, 0.95 v7.5.0
% Syntax   : Number of clauses     :   14 (  14 unt;   0 nHn;   1 RR)
%            Number of literals    :   14 (  14 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    9 (   9 usr;   5 con; 0-4 aty)
%            Number of variables   :   26 (   3 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from LAT065-1 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(ifeq_axiom,axiom,
    ifeq(A,A,B,C) = B ).

cnf(idempotence_of_meet,axiom,
    meet(X,X) = X ).

cnf(idempotence_of_join,axiom,
    join(X,X) = X ).

cnf(absorption1,axiom,
    meet(X,join(X,Y)) = X ).

cnf(absorption2,axiom,
    join(X,meet(X,Y)) = X ).

cnf(commutativity_of_meet,axiom,
    meet(X,Y) = meet(Y,X) ).

cnf(commutativity_of_join,axiom,
    join(X,Y) = join(Y,X) ).

cnf(associativity_of_meet,axiom,
    meet(meet(X,Y),Z) = meet(X,meet(Y,Z)) ).

cnf(associativity_of_join,axiom,
    join(join(X,Y),Z) = join(X,join(Y,Z)) ).

cnf(top,axiom,
    join(A,complement(A)) = n1 ).

cnf(bottom,axiom,
    meet(A,complement(A)) = n0 ).

cnf(complements_are_unique,axiom,
    ifeq(join(A,B),n1,ifeq(meet(A,B),n0,complement(A),B),B) = B ).

cnf(c94_37,axiom,
    meet(A,join(meet(B,join(C,meet(A,B))),meet(C,join(A,B)))) = join(meet(A,B),meet(A,C)) ).

cnf(prove_distributivity,negated_conjecture,
    meet(a,join(b,c)) != join(meet(a,b),meet(a,c)) ).

%------------------------------------------------------------------------------
