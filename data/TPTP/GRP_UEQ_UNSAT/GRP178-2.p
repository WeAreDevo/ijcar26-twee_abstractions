%--------------------------------------------------------------------------
% File     : GRP178-2 : TPTP v9.2.1. Bugfixed v1.2.1.
% Domain   : Group Theory (Lattice Ordered)
% Problem  : A consequence of monotonicity
% Version  : [Fuc94] (equality) axioms.
%            Theorem formulation : Dual.
% English  :

% Refs     : [Fuc94] Fuchs (1994), The Application of Goal-Orientated Heuri
%          : [Sch95] Schulz (1995), Explanation Based Learning for Distribu
% Source   : [Sch95]
% Names    : p09b [Sch95]

% Status   : Unsatisfiable
% Rating   : 0.43 v9.1.0, 0.45 v9.0.0, 0.41 v8.2.0, 0.42 v8.1.0, 0.50 v7.5.0, 0.42 v7.4.0, 0.57 v7.3.0, 0.47 v7.1.0, 0.44 v7.0.0, 0.42 v6.4.0, 0.53 v6.2.0, 0.43 v6.1.0, 0.50 v6.0.0, 0.57 v5.5.0, 0.58 v5.4.0, 0.47 v5.3.0, 0.33 v5.2.0, 0.43 v5.1.0, 0.40 v5.0.0, 0.36 v4.0.1, 0.29 v4.0.0, 0.23 v3.7.0, 0.22 v3.4.0, 0.25 v3.3.0, 0.21 v3.2.0, 0.14 v3.1.0, 0.22 v2.7.0, 0.45 v2.6.0, 0.33 v2.5.0, 0.25 v2.4.0, 0.00 v2.2.1, 0.67 v2.2.0, 0.71 v2.1.0, 0.43 v2.0.0
% Syntax   : Number of clauses     :   20 (  20 unt;   0 nHn;   5 RR)
%            Number of literals    :   20 (  20 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   1 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   4 con; 0-2 aty)
%            Number of variables   :   33 (   2 sgn)
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
cnf(p09b_1,hypothesis,
    greatest_lower_bound(identity,a) = identity ).

cnf(p09b_2,hypothesis,
    greatest_lower_bound(identity,b) = identity ).

cnf(p09b_3,hypothesis,
    greatest_lower_bound(identity,c) = identity ).

cnf(p09b_4,hypothesis,
    greatest_lower_bound(a,b) = identity ).

cnf(prove_p09b,negated_conjecture,
    greatest_lower_bound(a,multiply(b,c)) != greatest_lower_bound(a,c) ).

%--------------------------------------------------------------------------
