%------------------------------------------------------------------------------
% File     : LAT241-10 : TPTP v9.2.1. Released v7.5.0.
% Domain   : Puzzles
% Problem  : Equation H51 is Huntington by implication
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.52 v9.1.0, 0.55 v8.2.0, 0.58 v8.1.0, 0.50 v7.5.0
% Syntax   : Number of clauses     :   15 (  15 unt;   0 nHn;   2 RR)
%            Number of literals    :   15 (  15 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   4 con; 0-4 aty)
%            Number of variables   :   27 (   3 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from LAT241-1 to UEQ using [CS18].
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

cnf(complement_join,axiom,
    join(X,complement(X)) = one ).

cnf(complement_meet,axiom,
    meet(X,complement(X)) = zero ).

cnf(meet_join_complement,axiom,
    ifeq(join(X,Y),one,ifeq(meet(X,Y),zero,complement(X),Y),Y) = Y ).

cnf(equation_H51,axiom,
    meet(X,join(Y,meet(Z,join(X,U)))) = meet(X,join(Y,join(meet(X,Z),meet(Z,U)))) ).

cnf(prove_distributivity_hypothesis,hypothesis,
    meet(b,a) = a ).

cnf(prove_distributivity,negated_conjecture,
    join(complement(b),complement(a)) != complement(a) ).

%------------------------------------------------------------------------------
