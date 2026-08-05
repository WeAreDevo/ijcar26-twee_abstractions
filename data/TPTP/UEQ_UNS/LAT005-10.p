%------------------------------------------------------------------------------
% File     : LAT005-10 : TPTP v9.2.1. Released v7.5.0.
% Domain   : Puzzles
% Problem  : SAM's lemma
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.30 v9.1.0, 0.36 v9.0.0, 0.41 v8.2.0, 0.50 v8.1.0, 0.60 v7.5.0
% Syntax   : Number of clauses     :   22 (  22 unt;   0 nHn;   3 RR)
%            Number of literals    :   22 (  22 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   1 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   13 (  13 usr;   7 con; 0-4 aty)
%            Number of variables   :   38 (   7 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from LAT005-3 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(ifeq_axiom,axiom,
    ifeq3(A,A,B,C) = B ).

cnf(ifeq_axiom_001,axiom,
    ifeq2(A,A,B,C) = B ).

cnf(ifeq_axiom_002,axiom,
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

cnf(x_meet_0,axiom,
    meet(X,n0) = n0 ).

cnf(x_join_0,axiom,
    join(X,n0) = X ).

cnf(x_meet_1,axiom,
    meet(X,n1) = X ).

cnf(x_join_1,axiom,
    join(X,n1) = n1 ).

cnf(modular,axiom,
    ifeq3(meet(X,Z),X,meet(Z,join(X,Y)),join(X,meet(Y,Z))) = join(X,meet(Y,Z)) ).

cnf(complement_meet,axiom,
    ifeq(complement(X,Y),true,meet(X,Y),n0) = n0 ).

cnf(complement_join,axiom,
    ifeq(complement(X,Y),true,join(X,Y),n1) = n1 ).

cnf(meet_join_complement,axiom,
    ifeq2(join(X,Y),n1,ifeq2(meet(X,Y),n0,complement(X,Y),true),true) = true ).

cnf(complement_of_a_join_b,hypothesis,
    complement(r1,join(a,b)) = true ).

cnf(complement_of_a_meet_b,hypothesis,
    complement(r2,meet(a,b)) = true ).

cnf(prove_lemma,negated_conjecture,
    r1 != meet(join(r1,meet(r2,b)),join(r1,meet(r2,a))) ).

%------------------------------------------------------------------------------
