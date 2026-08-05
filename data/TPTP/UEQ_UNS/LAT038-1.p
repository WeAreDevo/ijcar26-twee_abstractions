%--------------------------------------------------------------------------
% File     : LAT038-1 : TPTP v9.2.1. Released v2.4.0.
% Domain   : Lattice Theory
% Problem  : Simplification rule in a distributive lattice
% Version  : [McC88] (equality) axioms.
% English  : In a distributive lattice, the following simplification rule
%            holds:
%            forall a, b, c, d:
%                if   f(a v b, d) = f(c v b, d) and
%                     f(a, d) & f(b, d) = f(c, d) & f(b, d)
%                then f(a,d) = f(c,d).

% Refs     : [DeN00] DeNivelle (2000), Email to G. Sutcliffe
%            [McC88] McCune (1988), Challenge Equality Problems in Lattice
% Source   : [DeN00]
% Names    : lattice-hemi-simplif [DeN00]

% Status   : Unsatisfiable
% Rating   : 0.17 v9.1.0, 0.23 v8.2.0, 0.25 v8.1.0, 0.30 v7.5.0, 0.29 v7.4.0, 0.35 v7.3.0, 0.32 v7.1.0, 0.28 v7.0.0, 0.37 v6.4.0, 0.32 v6.3.0, 0.29 v6.2.0, 0.36 v6.1.0, 0.44 v6.0.0, 0.52 v5.5.0, 0.47 v5.4.0, 0.40 v5.3.0, 0.50 v5.1.0, 0.53 v5.0.0, 0.57 v4.1.0, 0.27 v4.0.1, 0.43 v4.0.0, 0.38 v3.7.0, 0.11 v3.4.0, 0.12 v3.3.0, 0.43 v3.1.0, 0.44 v2.7.0, 0.36 v2.6.0, 0.17 v2.5.0, 0.25 v2.4.0
% Syntax   : Number of clauses     :   17 (  17 unt;   0 nHn;   3 RR)
%            Number of literals    :   17 (  17 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   5 con; 0-2 aty)
%            Number of variables   :   30 (   4 sgn)
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

cnf(f_on_left_join,axiom,
    f(join(U,V),W) = join(f(U,W),f(V,W)) ).

cnf(f_on_left_bottom,axiom,
    f(n0,W) = n0 ).

cnf(f_on_right_join,axiom,
    f(W,join(U,V)) = join(f(W,U),f(W,V)) ).

cnf(f_on_right_bottom,axiom,
    f(W,n0) = n0 ).

cnf(lhs1,hypothesis,
    f(join(aa,bb),dd) = f(join(cc,bb),dd) ).

cnf(lhs2,hypothesis,
    meet(f(aa,dd),f(bb,dd)) = meet(f(cc,dd),f(bb,dd)) ).

cnf(rhs,negated_conjecture,
    f(aa,dd) != f(cc,dd) ).

%--------------------------------------------------------------------------
