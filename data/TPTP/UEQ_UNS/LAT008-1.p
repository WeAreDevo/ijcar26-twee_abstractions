%--------------------------------------------------------------------------
% File     : LAT008-1 : TPTP v9.2.1. Released v2.2.0.
% Domain   : Lattice Theory (Distributive lattices)
% Problem  : Sholander's basis for distributive lattices, part 5 (of 6).
% Version  : [MP96] (equality) axioms.
% English  : This is part of the proof that Sholanders 2-basis for
%            distributive lattices is correct. Here we prove the absorption
%            law  x v (x ^ y) = x.

% Refs     : [McC98] McCune (1998), Email to G. Sutcliffe
%          : [MP96]  McCune & Padmanabhan (1996), Automated Deduction in Eq
% Source   : [McC98]
% Names    : LT-3-f [MP96]

% Status   : Unsatisfiable
% Rating   : 0.04 v9.1.0, 0.09 v8.2.0, 0.08 v8.1.0, 0.10 v7.5.0, 0.12 v7.4.0, 0.22 v7.3.0, 0.16 v7.1.0, 0.11 v6.4.0, 0.16 v6.3.0, 0.12 v6.2.0, 0.14 v6.1.0, 0.12 v6.0.0, 0.24 v5.5.0, 0.21 v5.4.0, 0.07 v5.3.0, 0.08 v5.2.0, 0.07 v5.1.0, 0.13 v5.0.0, 0.07 v4.1.0, 0.00 v4.0.1, 0.07 v4.0.0, 0.08 v3.7.0, 0.00 v3.3.0, 0.07 v3.1.0, 0.11 v2.7.0, 0.00 v2.2.1
% Syntax   : Number of clauses     :    3 (   3 unt;   0 nHn;   1 RR)
%            Number of literals    :    3 (   3 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    4 (   4 usr;   2 con; 0-2 aty)
%            Number of variables   :    5 (   1 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Sholander's 2-basis for distributive lattices:
cnf(absorption,axiom,
    meet(X,join(X,Y)) = X ).

cnf(distribution,axiom,
    meet(X,join(Y,Z)) = join(meet(Z,X),meet(Y,X)) ).

%----Denial of the conclusion:
cnf(prove_absorbtion_dual,negated_conjecture,
    join(a,meet(a,b)) != a ).

%--------------------------------------------------------------------------
