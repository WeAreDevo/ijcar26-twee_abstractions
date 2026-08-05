%--------------------------------------------------------------------------
% File     : GRP164-2 : TPTP v9.2.1. Bugfixed v1.2.1.
% Domain   : Group Theory (Lattice Ordered)
% Problem  : The lattice of each LOG is distributive
% Version  : [Fuc94] (equality) axioms.
%            Theorem formulation : Dual.
% English  :

% Refs     : [Fuc94] Fuchs (1994), The Application of Goal-Orientated Heuri
%          : [Sch95] Schulz (1995), Explanation Based Learning for Distribu
% Source   : [Sch95]
% Names    : distrun [Sch95]

% Status   : Unsatisfiable
% Rating   : 0.96 v9.1.0, 0.91 v8.2.0, 0.83 v8.1.0, 0.95 v7.5.0, 0.92 v7.4.0, 0.96 v7.3.0, 0.89 v7.1.0, 0.94 v7.0.0, 0.95 v6.3.0, 0.94 v6.2.0, 0.93 v6.1.0, 0.94 v6.0.0, 0.95 v5.4.0, 0.93 v5.3.0, 0.92 v5.2.0, 0.93 v4.1.0, 0.91 v4.0.1, 0.93 v4.0.0, 0.92 v3.7.0, 0.89 v3.4.0, 0.88 v3.3.0, 0.93 v3.1.0, 0.89 v2.7.0, 0.91 v2.6.0, 0.83 v2.5.0, 0.75 v2.4.0, 0.67 v2.2.1, 1.00 v2.0.0
% Syntax   : Number of clauses     :   16 (  16 unt;   0 nHn;   1 RR)
%            Number of literals    :   16 (  16 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   4 con; 0-2 aty)
%            Number of variables   :   33 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : ORDERING LPO inverse > product > greatest_lower_bound >
%            least_upper_bound > identity > a > b > c
% Bugfixes : v1.2.1 - Duplicate axioms in GRP004-2.ax removed.
%--------------------------------------------------------------------------
%----Include equality group theory axioms
include('Axioms/GRP004-0.ax').
%----Include Lattice ordered group (equality) axioms
include('Axioms/GRP004-2.ax').
%--------------------------------------------------------------------------
cnf(prove_distrun,negated_conjecture,
    greatest_lower_bound(a,least_upper_bound(b,c)) != least_upper_bound(greatest_lower_bound(a,b),greatest_lower_bound(a,c)) ).

%--------------------------------------------------------------------------
