%--------------------------------------------------------------------------
% File     : GRP184-4 : TPTP v9.2.1. Bugfixed v1.2.1.
% Domain   : Group Theory (Lattice Ordered)
% Problem  : Orthogonal elements commute and form a subgroup
% Version  : [Fuc94] (equality) axioms : Augmented.
% English  :

% Refs     : [Fuc94] Fuchs (1994), The Application of Goal-Orientated Heuri
%          : [Sch95] Schulz (1995), Explanation Based Learning for Distribu
% Source   : [Sch95]
% Names    : p21x [Sch95]

% Status   : Unsatisfiable
% Rating   : 0.09 v9.1.0, 0.14 v9.0.0, 0.09 v8.2.0, 0.17 v8.1.0, 0.20 v7.5.0, 0.21 v7.4.0, 0.26 v7.3.0, 0.21 v7.1.0, 0.11 v6.4.0, 0.21 v6.3.0, 0.29 v6.1.0, 0.25 v6.0.0, 0.38 v5.5.0, 0.37 v5.4.0, 0.20 v5.3.0, 0.08 v5.2.0, 0.14 v5.1.0, 0.07 v5.0.0, 0.21 v4.1.0, 0.09 v4.0.1, 0.07 v4.0.0, 0.08 v3.7.0, 0.11 v3.4.0, 0.12 v3.3.0, 0.00 v2.7.0, 0.09 v2.6.0, 0.00 v2.2.1, 0.56 v2.2.0, 0.57 v2.1.0, 0.43 v2.0.0
% Syntax   : Number of clauses     :   21 (  21 unt;   0 nHn;   2 RR)
%            Number of literals    :   21 (  21 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   2 con; 0-2 aty)
%            Number of variables   :   40 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : ORDERING LPO inverse > product > greatest_lower_bound >
%            least_upper_bound > identity > a
% Bugfixes : v1.2.1 - Duplicate axioms in GRP004-2.ax removed.
%--------------------------------------------------------------------------
%----Include equality group theory axioms
include('Axioms/GRP004-0.ax').
%----Include Lattice ordered group (equality) axioms
include('Axioms/GRP004-2.ax').
%--------------------------------------------------------------------------
cnf(p21x_1,hypothesis,
    inverse(identity) = identity ).

cnf(p21x_2,hypothesis,
    inverse(inverse(X)) = X ).

cnf(p21x_3,hypothesis,
    inverse(multiply(X,Y)) = multiply(inverse(Y),inverse(X)) ).

cnf(p21x_4,hypothesis,
    inverse(greatest_lower_bound(X,Y)) = least_upper_bound(inverse(X),inverse(Y)) ).

cnf(p21x_5,hypothesis,
    inverse(least_upper_bound(X,Y)) = greatest_lower_bound(inverse(X),inverse(Y)) ).

cnf(prove_p21x,negated_conjecture,
    multiply(least_upper_bound(a,identity),inverse(greatest_lower_bound(a,identity))) != multiply(inverse(greatest_lower_bound(a,identity)),least_upper_bound(a,identity)) ).

%--------------------------------------------------------------------------
