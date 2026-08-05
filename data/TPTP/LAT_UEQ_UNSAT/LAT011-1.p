%--------------------------------------------------------------------------
% File     : LAT011-1 : TPTP v9.2.1. Released v2.2.0.
% Domain   : Lattice Theory
% Problem  : Uniqueness of meet (dually join) in lattice theory
% Version  : [MP96] (equality) axioms : Especial.
% English  : Let's say we have a lattice with two meet operations, say
%            meet1 and meet2.  In other words, {join,meet1} is a lattice,
%            and {join,meet2} is a lattice.  Then, we can prove that the
%            two meet operations are really the same.

% Refs     : [McC98] McCune (1998), Email to G. Sutcliffe
%          : [MP96]  McCune & Padmanabhan (1996), Automated Deduction in Eq
% Source   : [McC98]
% Names    : LT-8 [MP96]

% Status   : Unsatisfiable
% Rating   : 0.09 v8.2.0, 0.12 v8.1.0, 0.05 v7.5.0, 0.08 v7.4.0, 0.13 v7.3.0, 0.05 v7.1.0, 0.06 v7.0.0, 0.05 v6.3.0, 0.06 v6.2.0, 0.14 v6.1.0, 0.25 v6.0.0, 0.38 v5.5.0, 0.42 v5.4.0, 0.27 v5.3.0, 0.17 v5.2.0, 0.21 v5.1.0, 0.20 v5.0.0, 0.14 v4.1.0, 0.18 v4.0.1, 0.14 v4.0.0, 0.08 v3.7.0, 0.00 v3.3.0, 0.07 v3.1.0, 0.00 v2.7.0, 0.09 v2.6.0, 0.00 v2.2.1
% Syntax   : Number of clauses     :   14 (  14 unt;   0 nHn;   1 RR)
%            Number of literals    :   14 (  14 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   1 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   2 con; 0-2 aty)
%            Number of variables   :   26 (   4 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : For quasilattice, meet (dually join) is not necessarily unique.
%--------------------------------------------------------------------------
%----Include lattice axioms
include('Axioms/LAT001-0.ax').
%--------------------------------------------------------------------------
%----{join,meet2} is a lattice:
cnf(idempotence_of_meet2,axiom,
    meet2(X,X) = X ).

cnf(commutativity_of_meet2,axiom,
    meet2(X,Y) = meet2(Y,X) ).

cnf(absorption1_2,axiom,
    meet2(X,join(X,Y)) = X ).

cnf(absorption2_2,axiom,
    join(X,meet2(X,Y)) = X ).

cnf(associativity_of_meet2,axiom,
    meet2(meet2(X,Y),Z) = meet2(X,meet2(Y,Z)) ).

%----Denial that meet1 and meet2 are the same:
cnf(prove_meets_are_same,negated_conjecture,
    meet(a,b) != meet2(a,b) ).

%--------------------------------------------------------------------------
