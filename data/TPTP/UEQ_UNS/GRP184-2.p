%--------------------------------------------------------------------------
% File     : GRP184-2 : TPTP v9.2.1. Bugfixed v1.2.1.
% Domain   : Group Theory (Lattice Ordered)
% Problem  : Orthogonal elements commute and form a subgroup
% Version  : [Fuc94] (equality) axioms : Augmented.
% English  :

% Refs     : [Fuc94] Fuchs (1994), The Application of Goal-Orientated Heuri
%          : [Sch95] Schulz (1995), Explanation Based Learning for Distribu
% Source   : [Sch95]
% Names    : p21 [Sch95]

% Status   : Unsatisfiable
% Rating   : 0.26 v9.1.0, 0.32 v9.0.0, 0.23 v8.2.0, 0.33 v8.1.0, 0.45 v7.5.0, 0.29 v7.4.0, 0.35 v7.3.0, 0.26 v7.1.0, 0.17 v7.0.0, 0.16 v6.4.0, 0.26 v6.3.0, 0.29 v6.1.0, 0.38 v6.0.0, 0.57 v5.5.0, 0.58 v5.4.0, 0.33 v5.3.0, 0.25 v5.2.0, 0.29 v5.1.0, 0.27 v5.0.0, 0.21 v4.1.0, 0.18 v4.0.1, 0.21 v4.0.0, 0.23 v3.7.0, 0.22 v3.4.0, 0.25 v3.3.0, 0.14 v3.1.0, 0.00 v2.7.0, 0.18 v2.6.0, 0.17 v2.5.0, 0.00 v2.4.0, 0.00 v2.2.1, 0.56 v2.2.0, 0.57 v2.1.0, 0.71 v2.0.0
% Syntax   : Number of clauses     :   19 (  19 unt;   0 nHn;   2 RR)
%            Number of literals    :   19 (  19 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   2 con; 0-2 aty)
%            Number of variables   :   36 (   2 sgn)
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
cnf(p21_1,hypothesis,
    inverse(identity) = identity ).

cnf(p21_2,hypothesis,
    inverse(inverse(X)) = X ).

cnf(p21_3,hypothesis,
    inverse(multiply(X,Y)) = multiply(inverse(Y),inverse(X)) ).

cnf(prove_p21,negated_conjecture,
    multiply(least_upper_bound(a,identity),inverse(greatest_lower_bound(a,identity))) != multiply(inverse(greatest_lower_bound(a,identity)),least_upper_bound(a,identity)) ).

%--------------------------------------------------------------------------
