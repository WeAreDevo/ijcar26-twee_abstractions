%--------------------------------------------------------------------------
% File     : LAT034-1 : TPTP v9.2.1. Bugfixed v2.5.0.
% Domain   : Lattice Theory
% Problem  : Idempotency of meet
% Version  : [McC88] (equality) axioms.
% English  :

% Refs     : [DeN00] DeNivelle (2000), Email to G. Sutcliffe
%            [McC88] McCune (1988), Challenge Equality Problems in Lattice
% Source   : [DeN00]
% Names    : idemp_of_meet [DeN00]

% Status   : Unsatisfiable
% Rating   : 0.00 v7.4.0, 0.04 v7.3.0, 0.00 v6.4.0, 0.05 v6.3.0, 0.12 v6.2.0, 0.14 v6.1.0, 0.00 v2.5.0
% Syntax   : Number of clauses     :    7 (   7 unt;   0 nHn;   1 RR)
%            Number of literals    :    7 (   7 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   1 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    3 (   3 usr;   1 con; 0-2 aty)
%            Number of variables   :   14 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
% Bugfixes : v2.5.0 - Used axioms without the conjecture
%--------------------------------------------------------------------------
%----Include lattice theory axioms
%include('Axioms/LAT001-0.ax').
%--------------------------------------------------------------------------
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

cnf(idempotence_of_meet,negated_conjecture,
    meet(xx,xx) != xx ).

%--------------------------------------------------------------------------
