%--------------------------------------------------------------------------
% File     : LAT083-1 : TPTP v9.2.1. Released v2.6.0.
% Domain   : Lattice Theory
% Problem  : Axiom for lattice theory, part 4
% Version  : [MP96] (equality) axioms.
% English  :

% Refs     : [McC98] McCune (1998), Email to G. Sutcliffe
%          : [MP96]  McCune & Padmanabhan (1996), Automated Deduction in Eq
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.30 v9.1.0, 0.36 v8.2.0, 0.42 v8.1.0, 0.50 v7.5.0, 0.38 v7.4.0, 0.43 v7.3.0, 0.42 v7.1.0, 0.33 v7.0.0, 0.37 v6.4.0, 0.42 v6.3.0, 0.41 v6.2.0, 0.43 v6.1.0, 0.56 v6.0.0, 0.67 v5.5.0, 0.63 v5.4.0, 0.60 v5.3.0, 0.58 v5.2.0, 0.57 v5.1.0, 0.60 v5.0.0, 0.57 v4.1.0, 0.64 v4.0.1, 0.50 v4.0.0, 0.46 v3.7.0, 0.56 v3.4.0, 0.50 v3.3.0, 0.36 v3.1.0, 0.11 v2.7.0, 0.55 v2.6.0
% Syntax   : Number of clauses     :    2 (   2 unt;   0 nHn;   1 RR)
%            Number of literals    :    2 (   2 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :   12 (   3 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    3 (   3 usr;   1 con; 0-2 aty)
%            Number of variables   :    7 (   1 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : A UEQ part of LAT015-1
%--------------------------------------------------------------------------
cnf(single_axiom,axiom,
    join(meet(join(meet(A,B),meet(B,join(A,B))),C),meet(join(meet(A,join(join(meet(D,B),meet(B,E)),B)),meet(join(meet(B,meet(meet(join(D,join(B,E)),join(F,B)),B)),meet(G,join(B,meet(meet(join(D,join(B,E)),join(F,B)),B)))),join(A,join(join(meet(D,B),meet(B,E)),B)))),join(join(meet(A,B),meet(B,join(A,B))),C))) = B ).

cnf(prove_normal_axioms_4,negated_conjecture,
    join(a,a) != a ).

%--------------------------------------------------------------------------
