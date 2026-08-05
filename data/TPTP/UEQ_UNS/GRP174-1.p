%--------------------------------------------------------------------------
% File     : GRP174-1 : TPTP v9.2.1. Bugfixed v1.2.1.
% Domain   : Group Theory (Lattice Ordered)
% Problem  : Each subgroup of positive elements is trivial
% Version  : [Fuc94] (equality) axioms.
% English  :

% Refs     : [Fuc94] Fuchs (1994), The Application of Goal-Orientated Heuri
%          : [Sch95] Schulz (1995), Explanation Based Learning for Distribu
% Source   : [Sch95]
% Names    : p05b [Sch95]

% Status   : Unsatisfiable
% Rating   : 0.00 v7.4.0, 0.04 v7.3.0, 0.00 v7.0.0, 0.05 v6.3.0, 0.12 v6.2.0, 0.14 v6.1.0, 0.06 v6.0.0, 0.19 v5.5.0, 0.16 v5.4.0, 0.00 v5.1.0, 0.07 v5.0.0, 0.00 v2.2.1, 0.11 v2.2.0, 0.14 v2.1.0, 0.14 v2.0.0
% Syntax   : Number of clauses     :   18 (  18 unt;   0 nHn;   3 RR)
%            Number of literals    :   18 (  18 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   2 con; 0-2 aty)
%            Number of variables   :   33 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : ORDERING LPO greatest_lower_bound > least_upper_bound >
%            inverse > product > identity > a
%          : ORDERING LPO inverse > product > greatest_lower_bound >
%            least_upper_bound > identity > a
% Bugfixes : v1.2.1 - Duplicate axioms in GRP004-2.ax removed.
%--------------------------------------------------------------------------
%----Include equality group theory axioms
include('Axioms/GRP004-0.ax').
%----Include Lattice ordered group (equality) axioms
include('Axioms/GRP004-2.ax').
%--------------------------------------------------------------------------
cnf(p05b_1,hypothesis,
    greatest_lower_bound(identity,a) = a ).

cnf(p05b_2,hypothesis,
    greatest_lower_bound(identity,inverse(a)) = inverse(a) ).

cnf(prove_p05b,negated_conjecture,
    identity != a ).

%--------------------------------------------------------------------------
