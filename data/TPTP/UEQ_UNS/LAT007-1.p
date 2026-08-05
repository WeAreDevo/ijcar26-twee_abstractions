%--------------------------------------------------------------------------
% File     : LAT007-1 : TPTP v9.2.1. Released v2.2.0.
% Domain   : Lattice Theory (Distributive lattices)
% Problem  : Sholander's basis for distributive lattices, part 5 (of 6).
% Version  : [MP96] (equality) axioms.
% English  : This is part of the proof that Sholanders 2-basis for
%            distributive lattices is correct. Here we prove associativity
%            of join.

% Refs     : [McC98] McCune (1998), Email to G. Sutcliffe
%          : [MP96]  McCune & Padmanabhan (1996), Automated Deduction in Eq
% Source   : [McC98]
% Names    : LT-3-e [MP96]

% Status   : Unsatisfiable
% Rating   : 0.17 v9.1.0, 0.23 v8.2.0, 0.33 v8.1.0, 0.30 v7.5.0, 0.33 v7.4.0, 0.43 v7.3.0, 0.32 v7.1.0, 0.22 v7.0.0, 0.26 v6.4.0, 0.42 v6.3.0, 0.41 v6.2.0, 0.43 v6.1.0, 0.44 v6.0.0, 0.52 v5.5.0, 0.58 v5.4.0, 0.47 v5.3.0, 0.42 v5.2.0, 0.43 v5.1.0, 0.53 v5.0.0, 0.50 v4.1.0, 0.36 v4.0.0, 0.46 v3.7.0, 0.33 v3.4.0, 0.38 v3.3.0, 0.36 v3.1.0, 0.33 v2.7.0, 0.27 v2.6.0, 0.17 v2.5.0, 0.00 v2.2.1
% Syntax   : Number of clauses     :    3 (   3 unt;   0 nHn;   1 RR)
%            Number of literals    :    3 (   3 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   3 con; 0-2 aty)
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
cnf(prove_associativity_of_join,negated_conjecture,
    join(join(a,b),c) != join(a,join(b,c)) ).

%--------------------------------------------------------------------------
