%--------------------------------------------------------------------------
% File     : LAT028-1 : TPTP v9.2.1. Released v2.2.0.
% Domain   : Lattice Theory (Weakly Associative Lattices)
% Problem  : Uniqueness of meet (dually join) in WAL
% Version  : [MP96] (equality) axioms.
% English  : Let's say we have a weakly-associative lattice (WAL) with 2 meet
%            operations, say meet1 and meet2.  In other words, {join,meet1}
%            is a WAL, and {join,meet2} is a WAL.  Then, we can prove that the
%            two meet operations are really the same.

% Refs     : [McC98] McCune (1998), Email to G. Sutcliffe
%          : [MP96]  McCune & Padmanabhan (1996), Automated Deduction in Eq
% Source   : [McC98]
% Names    : WAL-2 [MP96]

% Status   : Unsatisfiable
% Rating   : 0.04 v9.1.0, 0.05 v8.2.0, 0.04 v8.1.0, 0.10 v7.5.0, 0.08 v7.4.0, 0.17 v7.3.0, 0.11 v7.1.0, 0.06 v7.0.0, 0.11 v6.3.0, 0.18 v6.2.0, 0.21 v6.1.0, 0.12 v6.0.0, 0.24 v5.5.0, 0.32 v5.4.0, 0.13 v5.3.0, 0.00 v5.2.0, 0.07 v5.1.0, 0.00 v4.0.1, 0.07 v4.0.0, 0.00 v2.2.1
% Syntax   : Number of clauses     :   11 (  11 unt;   0 nHn;   1 RR)
%            Number of literals    :   11 (  11 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   2 con; 0-2 aty)
%            Number of variables   :   21 (   8 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Include Weakly Associative Lattices theory (equality) axioms
include('Axioms/LAT005-0.ax').
%--------------------------------------------------------------------------
%----{join,meet2} is a weakly-associative lattice:
cnf(idempotence_of_meet2,axiom,
    meet2(X,X) = X ).

cnf(commutativity_of_meet2,axiom,
    meet2(X,Y) = meet2(Y,X) ).

cnf(wal_1_2,axiom,
    meet2(meet2(join(X,Y),join(Z,Y)),Y) = Y ).

cnf(wal_2_2,axiom,
    join(join(meet2(X,Y),meet2(Z,Y)),Y) = Y ).

%----Denial of meet=meet2:
cnf(name,negated_conjecture,
    meet(a,b) != meet2(a,b) ).

%--------------------------------------------------------------------------
