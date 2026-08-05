%--------------------------------------------------------------------------
% File     : GRP146-1 : TPTP v9.2.1. Bugfixed v1.2.1.
% Domain   : Group Theory (Lattice Ordered)
% Problem  : Prove least upper-bound axiom using the LUB transformation
% Version  : [Fuc94] (equality) axioms.
% English  : This problem proves the original least upper-bound axiom from
%            the equational axiomatization.

% Refs     : [Fuc94] Fuchs (1994), The Application of Goal-Orientated Heuri
%          : [Sch95] Schulz (1995), Explanation Based Learning for Distribu
% Source   : [Sch95]
% Names    : ax_lub1a [Sch95]

% Status   : Unsatisfiable
% Rating   : 0.00 v8.2.0, 0.04 v8.1.0, 0.05 v7.5.0, 0.04 v7.4.0, 0.09 v7.3.0, 0.00 v7.0.0, 0.11 v6.3.0, 0.06 v6.2.0, 0.07 v6.1.0, 0.06 v6.0.0, 0.10 v5.5.0, 0.05 v5.4.0, 0.00 v3.4.0, 0.12 v3.3.0, 0.00 v2.0.0
% Syntax   : Number of clauses     :   18 (  18 unt;   0 nHn;   3 RR)
%            Number of literals    :   18 (  18 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   4 con; 0-2 aty)
%            Number of variables   :   33 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : ORDERING LPO  inverse > product > greatest_lower_bound >
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
cnf(ax_lub1a_1,hypothesis,
    least_upper_bound(a,c) = c ).

cnf(ax_lub1a_2,hypothesis,
    least_upper_bound(b,c) = c ).

cnf(prove_ax_lub1a,negated_conjecture,
    least_upper_bound(least_upper_bound(a,b),c) != c ).

%--------------------------------------------------------------------------
