%--------------------------------------------------------------------------
% File     : GRP184-3 : TPTP v9.2.1. Bugfixed v1.2.1.
% Domain   : Group Theory (Lattice Ordered)
% Problem  : Orthogonal elements commute and form a subgroup
% Version  : [Fuc94] (equality) axioms : Augmented.
% English  :

% Refs     : [Fuc94] Fuchs (1994), The Application of Goal-Orientated Heuri
%          : [Sch95] Schulz (1995), Explanation Based Learning for Distribu
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.35 v9.1.0, 0.41 v9.0.0, 0.36 v8.2.0, 0.50 v8.1.0, 0.55 v7.5.0, 0.50 v7.4.0, 0.57 v7.3.0, 0.53 v7.1.0, 0.44 v7.0.0, 0.53 v6.2.0, 0.50 v6.0.0, 0.67 v5.5.0, 0.68 v5.4.0, 0.53 v5.3.0, 0.42 v5.2.0, 0.50 v5.1.0, 0.47 v5.0.0, 0.43 v4.1.0, 0.45 v4.0.1, 0.43 v4.0.0, 0.38 v3.7.0, 0.33 v3.4.0, 0.25 v3.3.0, 0.21 v3.1.0, 0.00 v2.7.0, 0.45 v2.6.0, 0.33 v2.5.0, 0.00 v2.4.0, 0.00 v2.2.1, 0.67 v2.2.0, 0.71 v2.1.0, 0.86 v2.0.0
% Syntax   : Number of clauses     :   16 (  16 unt;   0 nHn;   1 RR)
%            Number of literals    :   16 (  16 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   2 con; 0-2 aty)
%            Number of variables   :   33 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : ORDERING LPO inverse > product > greatest_lower_bound >
%            least_upper_bound > identity > a
%          : This is a standardized version of the problem that appears in
%            [Sch95].
% Bugfixes : v1.2.1 - Duplicate axioms in GRP004-2.ax removed.
%--------------------------------------------------------------------------
%----Include equality group theory axioms
include('Axioms/GRP004-0.ax').
%----Include Lattice ordered group (equality) axioms
include('Axioms/GRP004-2.ax').
%--------------------------------------------------------------------------
cnf(prove_p21x,negated_conjecture,
    multiply(least_upper_bound(a,identity),inverse(greatest_lower_bound(a,identity))) != multiply(inverse(greatest_lower_bound(a,identity)),least_upper_bound(a,identity)) ).

%--------------------------------------------------------------------------
