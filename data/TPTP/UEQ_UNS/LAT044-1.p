%--------------------------------------------------------------------------
% File     : LAT044-1 : TPTP v9.2.1. Released v2.5.0.
% Domain   : Lattice Theory
% Problem  : Lattice weak orthomodular law from orthomodular lattice
% Version  : [McC88] (equality) axioms.
% English  :

% Refs     : [McC88] McCune (1988), Challenge Equality Problems in Lattice
%          : [RW01]  Rose & Wilkinson (2001), Application of Model Search
% Source   : [RW01]
% Names    : eqp-c.in [RW01]

% Status   : Unsatisfiable
% Rating   : 0.26 v9.1.0, 0.32 v9.0.0, 0.36 v8.2.0, 0.33 v8.1.0, 0.25 v7.4.0, 0.30 v7.3.0, 0.32 v7.2.0, 0.26 v7.1.0, 0.17 v7.0.0, 0.16 v6.4.0, 0.26 v6.3.0, 0.29 v6.1.0, 0.44 v6.0.0, 0.57 v5.5.0, 0.53 v5.4.0, 0.47 v5.3.0, 0.33 v5.2.0, 0.36 v5.1.0, 0.33 v5.0.0, 0.21 v4.1.0, 0.18 v4.0.1, 0.21 v4.0.0, 0.15 v3.7.0, 0.11 v3.4.0, 0.12 v3.3.0, 0.21 v3.2.0, 0.14 v3.1.0, 0.00 v2.7.0, 0.27 v2.6.0, 0.00 v2.5.0
% Syntax   : Number of clauses     :   15 (  15 unt;   0 nHn;   1 RR)
%            Number of literals    :   15 (  15 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   4 con; 0-2 aty)
%            Number of variables   :   25 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Include lattice axioms
include('Axioms/LAT001-0.ax').
%--------------------------------------------------------------------------
%----Compatibility (6)
cnf(compatibility1,axiom,
    complement(join(X,Y)) = meet(complement(X),complement(Y)) ).

cnf(compatibility2,axiom,
    complement(meet(X,Y)) = join(complement(X),complement(Y)) ).

%----Invertability (5)
cnf(invertability1,axiom,
    join(complement(X),X) = n1 ).

cnf(invertability2,axiom,
    meet(complement(X),X) = n0 ).

cnf(invertability3,axiom,
    complement(complement(X)) = X ).

%----Orthomodular law (8)
cnf(orthomodular_law,axiom,
    join(X,meet(complement(X),join(X,Y))) = join(X,Y) ).

%----Denial of weak orthomodular law (10)
cnf(prove_weak_orthomodular_law,negated_conjecture,
    join(meet(complement(a),join(a,b)),join(complement(b),meet(a,b))) != n1 ).

%--------------------------------------------------------------------------
