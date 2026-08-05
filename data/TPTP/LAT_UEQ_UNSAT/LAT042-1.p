%--------------------------------------------------------------------------
% File     : LAT042-1 : TPTP v9.2.1. Released v2.5.0.
% Domain   : Lattice Theory
% Problem  : Lattice modularity from Boolean algebra
% Version  : [McC88] (equality) axioms.
% English  :

% Refs     : [McC88] McCune (1988), Challenge Equality Problems in Lattice
%          : [RW01]  Rose & Wilkinson (2001), Application of Model Search
% Source   : [RW01]
% Names    : eqp-a1.in [RW01]

% Status   : Unsatisfiable
% Rating   : 0.00 v8.1.0, 0.05 v7.5.0, 0.00 v7.4.0, 0.09 v7.3.0, 0.00 v6.4.0, 0.05 v6.3.0, 0.06 v6.2.0, 0.07 v6.1.0, 0.06 v6.0.0, 0.14 v5.5.0, 0.05 v5.4.0, 0.07 v5.3.0, 0.08 v5.2.0, 0.07 v5.0.0, 0.00 v3.4.0, 0.12 v3.3.0, 0.07 v3.2.0, 0.00 v2.5.0
% Syntax   : Number of clauses     :   13 (  13 unt;   0 nHn;   1 RR)
%            Number of literals    :   13 (  13 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   5 con; 0-2 aty)
%            Number of variables   :   22 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Include lattice axioms
include('Axioms/LAT001-0.ax').
%--------------------------------------------------------------------------
% Distributivity (4)
cnf(distributivity,axiom,
    meet(X,join(Y,Z)) = join(meet(X,Y),meet(X,Z)) ).

% Invertability (5)
cnf(invertability1,axiom,
    join(complement(X),X) = n1 ).

cnf(invertability2,axiom,
    meet(complement(X),X) = n0 ).

cnf(invertability3,axiom,
    complement(complement(X)) = X ).

%----Preceding gives us Boolean Algebra
%----Denial of modular law:
cnf(prove_modular_law,negated_conjecture,
    join(a,meet(b,join(a,c))) != meet(join(a,b),join(a,c)) ).

%--------------------------------------------------------------------------
