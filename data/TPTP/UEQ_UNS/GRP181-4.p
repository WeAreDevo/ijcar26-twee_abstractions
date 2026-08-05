%--------------------------------------------------------------------------
% File     : GRP181-4 : TPTP v9.2.1. Bugfixed v1.2.1.
% Domain   : Group Theory (Lattice Ordered)
% Problem  : Distributivity of a lattice
% Version  : [Fuc94] (equality) axioms : Augmented.
% English  :

% Refs     : [Fuc94] Fuchs (1994), The Application of Goal-Orientated Heuri
%          : [Sch95] Schulz (1995), Explanation Based Learning for Distribu
% Source   : [Sch95]
% Names    : p12x [Sch95]

% Status   : Unsatisfiable
% Rating   : 0.17 v9.1.0, 0.27 v9.0.0, 0.23 v8.2.0, 0.25 v8.1.0, 0.35 v7.5.0, 0.38 v7.4.0, 0.43 v7.3.0, 0.32 v7.1.0, 0.22 v7.0.0, 0.32 v6.4.0, 0.37 v6.3.0, 0.35 v6.2.0, 0.50 v6.1.0, 0.56 v6.0.0, 0.67 v5.5.0, 0.68 v5.4.0, 0.60 v5.3.0, 0.58 v5.2.0, 0.57 v5.1.0, 0.53 v5.0.0, 0.50 v4.1.0, 0.36 v4.0.1, 0.50 v4.0.0, 0.46 v3.7.0, 0.33 v3.4.0, 0.25 v3.3.0, 0.43 v3.1.0, 0.44 v2.7.0, 0.36 v2.6.0, 0.00 v2.2.1, 0.56 v2.2.0, 0.57 v2.1.0, 1.00 v2.0.0
% Syntax   : Number of clauses     :   23 (  23 unt;   0 nHn;   4 RR)
%            Number of literals    :   23 (  23 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   4 con; 0-2 aty)
%            Number of variables   :   40 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : ORDERING LPO inverse > product > greatest_lower_bound >
%            least_upper_bound > identity > a > b > c
%          : ORDERING LPO greatest_lower_bound > least_upper_bound >
%            inverse > product > identity > a > b > c
% Bugfixes : v1.2.1 - Duplicate axioms in GRP004-2.ax removed.
%--------------------------------------------------------------------------
%----Include equality group theory axioms
include('Axioms/GRP004-0.ax').
%----Include Lattice ordered group (equality) axioms
include('Axioms/GRP004-2.ax').
%--------------------------------------------------------------------------
cnf(p12x_1,hypothesis,
    inverse(identity) = identity ).

cnf(p12x_2,hypothesis,
    inverse(inverse(X)) = X ).

cnf(p12x_3,hypothesis,
    inverse(multiply(X,Y)) = multiply(inverse(Y),inverse(X)) ).

cnf(p12x_4,hypothesis,
    greatest_lower_bound(a,c) = greatest_lower_bound(b,c) ).

cnf(p12x_5,hypothesis,
    least_upper_bound(a,c) = least_upper_bound(b,c) ).

cnf(p12x_6,hypothesis,
    inverse(greatest_lower_bound(X,Y)) = least_upper_bound(inverse(X),inverse(Y)) ).

cnf(p12x_7,hypothesis,
    inverse(least_upper_bound(X,Y)) = greatest_lower_bound(inverse(X),inverse(Y)) ).

cnf(prove_p12x,negated_conjecture,
    a != b ).

%--------------------------------------------------------------------------
