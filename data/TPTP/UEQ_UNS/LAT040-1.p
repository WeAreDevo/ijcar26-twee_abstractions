%--------------------------------------------------------------------------
% File     : LAT040-1 : TPTP v9.2.1. Released v2.4.0.
% Domain   : Lattice Theory
% Problem  : Another simplification rule for distributive lattices
% Version  : [McC88] (equality) axioms.
% English  : In every distributive lattice the simplification rule holds:
%            forall x, y, z: (x v y = x v z, x & y = x & z -> y = z ).

% Refs     : [DeN00] DeNivelle (2000), Email to G. Sutcliffe
%            [McC88] McCune (1988), Challenge Equality Problems in Lattice
% Source   : [DeN00]
% Names    : lattice-simpl [DeN00]

% Status   : Unsatisfiable
% Rating   : 0.00 v7.4.0, 0.04 v7.3.0, 0.00 v7.0.0, 0.05 v6.3.0, 0.12 v6.2.0, 0.14 v6.1.0, 0.06 v6.0.0, 0.19 v5.5.0, 0.16 v5.4.0, 0.00 v5.2.0, 0.07 v4.1.0, 0.09 v4.0.1, 0.07 v4.0.0, 0.08 v3.7.0, 0.00 v2.4.0
% Syntax   : Number of clauses     :   13 (  13 unt;   0 nHn;   3 RR)
%            Number of literals    :   13 (  13 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   1 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   3 con; 0-2 aty)
%            Number of variables   :   22 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Include lattice theory axioms
include('Axioms/LAT001-0.ax').
%--------------------------------------------------------------------------
cnf(dist_join,hypothesis,
    join(X,meet(Y,Z)) = meet(join(X,Y),join(X,Z)) ).

cnf(dist_meet,hypothesis,
    meet(X,join(Y,Z)) = join(meet(X,Y),meet(X,Z)) ).

cnf(lhs1,hypothesis,
    join(xx,yy) = join(xx,zz) ).

cnf(lhs2,hypothesis,
    meet(xx,yy) = meet(xx,zz) ).

cnf(rhs,negated_conjecture,
    yy != zz ).

%--------------------------------------------------------------------------
