%--------------------------------------------------------------------------
% File     : GRP181-3 : TPTP v9.2.1. Bugfixed v1.2.1.
% Domain   : Group Theory (Lattice Ordered)
% Problem  : Distributivity of a lattice
% Version  : [Fuc94] (equality) axioms : Augmented.
% English  :

% Refs     : [Fuc94] Fuchs (1994), The Application of Goal-Orientated Heuri
%          : [Sch95] Schulz (1995), Explanation Based Learning for Distribu
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.22 v9.1.0, 0.32 v8.2.0, 0.42 v8.1.0, 0.50 v7.5.0, 0.46 v7.4.0, 0.52 v7.3.0, 0.37 v7.1.0, 0.28 v7.0.0, 0.32 v6.4.0, 0.42 v6.3.0, 0.41 v6.2.0, 0.43 v6.1.0, 0.50 v6.0.0, 0.67 v5.5.0, 0.63 v5.4.0, 0.53 v5.3.0, 0.50 v5.1.0, 0.53 v5.0.0, 0.50 v4.1.0, 0.36 v4.0.1, 0.43 v4.0.0, 0.38 v3.7.0, 0.22 v3.4.0, 0.25 v3.3.0, 0.43 v3.1.0, 0.44 v2.7.0, 0.45 v2.6.0, 0.17 v2.5.0, 0.50 v2.4.0, 0.00 v2.2.1, 0.56 v2.2.0, 0.57 v2.1.0, 1.00 v2.0.0
% Syntax   : Number of clauses     :   20 (  20 unt;   0 nHn;   3 RR)
%            Number of literals    :   20 (  20 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   4 con; 0-2 aty)
%            Number of variables   :   37 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : ORDERING LPO inverse > product > greatest_lower_bound >
%            least_upper_bound > identity > a > b > c
%          : ORDERING LPO greatest_lower_bound > least_upper_bound >
%            inverse > product > identity > a > b > c
%          : This is a standardized version of the problem that appears in
%            [Sch95].
% Bugfixes : v1.2.1 - Duplicate axioms in GRP004-2.ax removed.
%--------------------------------------------------------------------------
%----Include equality group theory axioms
include('Axioms/GRP004-0.ax').
%----Include Lattice ordered group (equality) axioms
include('Axioms/GRP004-2.ax').
%--------------------------------------------------------------------------
cnf(p12x_1,hypothesis,
    greatest_lower_bound(a,c) = greatest_lower_bound(b,c) ).

cnf(p12x_2,hypothesis,
    least_upper_bound(a,c) = least_upper_bound(b,c) ).

cnf(p12x_3,hypothesis,
    inverse(greatest_lower_bound(X,Y)) = least_upper_bound(inverse(X),inverse(Y)) ).

cnf(p12x_4,hypothesis,
    inverse(least_upper_bound(X,Y)) = greatest_lower_bound(inverse(X),inverse(Y)) ).

cnf(prove_p12x,negated_conjecture,
    a != b ).

%--------------------------------------------------------------------------
