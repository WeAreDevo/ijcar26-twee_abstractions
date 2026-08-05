%--------------------------------------------------------------------------
% File     : GRP170-4 : TPTP v9.2.1. Bugfixed v1.2.1.
% Domain   : Group Theory (Lattice Ordered)
% Problem  : General form of monotonicity
% Version  : [Fuc94] (equality) axioms.
%            Theorem formulation : Dual and using different definitions
%            for =<.
% English  :

% Refs     : [Fuc94] Fuchs (1994), The Application of Goal-Orientated Heuri
%          : [Sch95] Schulz (1995), Explanation Based Learning for Distribu
% Source   : [Sch95]
% Names    : p03d [Sch95]

% Status   : Unsatisfiable
% Rating   : 0.17 v9.1.0, 0.23 v9.0.0, 0.18 v8.2.0, 0.12 v8.1.0, 0.15 v7.5.0, 0.08 v7.4.0, 0.22 v7.3.0, 0.11 v7.1.0, 0.06 v7.0.0, 0.16 v6.3.0, 0.18 v6.2.0, 0.21 v6.1.0, 0.31 v6.0.0, 0.43 v5.5.0, 0.42 v5.4.0, 0.33 v5.3.0, 0.25 v5.2.0, 0.36 v5.1.0, 0.27 v5.0.0, 0.21 v4.1.0, 0.09 v4.0.1, 0.07 v4.0.0, 0.08 v3.7.0, 0.11 v3.4.0, 0.12 v3.3.0, 0.07 v3.2.0, 0.00 v2.2.1, 0.67 v2.2.0, 0.71 v2.1.0, 0.57 v2.0.0
% Syntax   : Number of clauses     :   18 (  18 unt;   0 nHn;   3 RR)
%            Number of literals    :   18 (  18 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    9 (   9 usr;   5 con; 0-2 aty)
%            Number of variables   :   33 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : ORDERING LPO inverse > product > greatest_lower_bound >
%            least_upper_bound > identity > a > b > c > d
% Bugfixes : v1.2.1 - Duplicate axioms in GRP004-2.ax removed.
%--------------------------------------------------------------------------
%----Include equality group theory axioms
include('Axioms/GRP004-0.ax').
%----Include Lattice ordered group (equality) axioms
include('Axioms/GRP004-2.ax').
%--------------------------------------------------------------------------
cnf(p03d_1,hypothesis,
    least_upper_bound(a,b) = b ).

cnf(p03d_2,hypothesis,
    greatest_lower_bound(c,d) = c ).

cnf(prove_p03d,negated_conjecture,
    least_upper_bound(multiply(a,c),multiply(b,d)) != multiply(b,d) ).

%--------------------------------------------------------------------------
