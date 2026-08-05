%--------------------------------------------------------------------------
% File     : LAT009-1 : TPTP v9.2.1. Released v2.2.0.
% Domain   : Lattice Theory
% Problem  : A self-dual form of distributivity for lattice theory.
% Version  : [MP96] (equality) axioms : Especial.
% English  : From lattice theory axioms and a self-dual form of
%            distributivity, we prove ordinary distributivity.

% Refs     : [McC98] McCune (1998), Email to G. Sutcliffe
%          : [MP96]  McCune & Padmanabhan (1996), Automated Deduction in Eq
% Source   : [McC98]
% Names    : LT-5 [MP96]

% Status   : Unsatisfiable
% Rating   : 0.09 v8.2.0, 0.17 v8.1.0, 0.20 v7.5.0, 0.12 v7.4.0, 0.17 v7.3.0, 0.05 v7.1.0, 0.00 v7.0.0, 0.11 v6.4.0, 0.16 v6.3.0, 0.12 v6.2.0, 0.14 v6.1.0, 0.19 v6.0.0, 0.38 v5.5.0, 0.37 v5.4.0, 0.20 v5.3.0, 0.08 v5.2.0, 0.14 v5.1.0, 0.13 v5.0.0, 0.14 v4.1.0, 0.18 v4.0.1, 0.14 v4.0.0, 0.08 v3.7.0, 0.11 v3.4.0, 0.12 v3.3.0, 0.00 v2.2.1
% Syntax   : Number of clauses     :   10 (  10 unt;   0 nHn;   1 RR)
%            Number of literals    :   10 (  10 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   3 con; 0-2 aty)
%            Number of variables   :   19 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Include lattice axioms
include('Axioms/LAT001-0.ax').
%--------------------------------------------------------------------------
%----A self-dual form of distributivity for lattice theory.
cnf(distributivity_dual,axiom,
    join(meet(join(meet(X,Y),Z),Y),meet(Z,X)) = meet(join(meet(join(X,Y),Z),Y),join(Z,X)) ).

%----Denial of ordinary distributivity.
cnf(prove_distributivity,negated_conjecture,
    join(a,meet(b,c)) != meet(join(a,b),join(a,c)) ).

%--------------------------------------------------------------------------
