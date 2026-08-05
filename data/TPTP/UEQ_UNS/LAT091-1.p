%--------------------------------------------------------------------------
% File     : LAT091-1 : TPTP v9.2.1. Released v2.6.0.
% Domain   : Lattice Theory (Weakly Associative Lattices)
% Problem  : Absorption basis for WAL, part 4
% Version  : [MP96] (equality) axioms : Especial.
% English  :

% Refs     : [McC98] McCune (1998), Email to G. Sutcliffe
%          : [MP96]  McCune & Padmanabhan (1996), Automated Deduction in Eq
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.04 v9.1.0, 0.14 v9.0.0, 0.09 v8.2.0, 0.12 v8.1.0, 0.15 v7.5.0, 0.17 v7.4.0, 0.26 v7.1.0, 0.17 v7.0.0, 0.16 v6.4.0, 0.26 v6.3.0, 0.24 v6.2.0, 0.21 v6.1.0, 0.19 v6.0.0, 0.33 v5.5.0, 0.37 v5.4.0, 0.20 v5.3.0, 0.17 v5.2.0, 0.21 v5.1.0, 0.13 v5.0.0, 0.07 v4.1.0, 0.00 v4.0.1, 0.07 v4.0.0, 0.08 v3.7.0, 0.00 v3.4.0, 0.12 v3.3.0, 0.07 v3.1.0, 0.11 v2.7.0, 0.00 v2.6.0
% Syntax   : Number of clauses     :    6 (   6 unt;   0 nHn;   1 RR)
%            Number of literals    :    6 (   6 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    4 (   4 usr;   2 con; 0-2 aty)
%            Number of variables   :   12 (   5 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : A UEQ part of LAT029-1
%--------------------------------------------------------------------------
cnf(wal_absorbtion_1,axiom,
    join(meet(A,B),meet(A,join(A,B))) = A ).

cnf(wal_absorbtion_2,axiom,
    join(meet(A,A),meet(B,join(A,A))) = A ).

cnf(wal_absorbtion_3,axiom,
    join(meet(A,B),meet(B,join(A,B))) = B ).

cnf(wal_absorbtion_4,axiom,
    meet(meet(join(A,B),join(C,A)),A) = A ).

cnf(wal_absorbtion_5,axiom,
    join(join(meet(A,B),meet(C,A)),A) = A ).

cnf(prove_normal_axioms_4,negated_conjecture,
    join(b,a) != join(a,b) ).

%--------------------------------------------------------------------------
