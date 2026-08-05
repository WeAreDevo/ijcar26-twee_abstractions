%--------------------------------------------------------------------------
% File     : GRP185-1 : TPTP v9.2.1. Bugfixed v1.2.1.
% Domain   : Group Theory (Lattice Ordered)
% Problem  : Application of monotonicity and distributivity
% Version  : [Fuc94] (equality) axioms.
% English  :

% Refs     : [Fuc94] Fuchs (1994), The Application of Goal-Orientated Heuri
%          : [Sch95] Schulz (1995), Explanation Based Learning for Distribu
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.13 v9.1.0, 0.18 v9.0.0, 0.23 v8.2.0, 0.33 v8.1.0, 0.25 v7.4.0, 0.35 v7.3.0, 0.21 v7.1.0, 0.22 v7.0.0, 0.37 v6.3.0, 0.29 v6.1.0, 0.44 v6.0.0, 0.62 v5.5.0, 0.53 v5.4.0, 0.47 v5.3.0, 0.33 v5.2.0, 0.43 v5.1.0, 0.33 v5.0.0, 0.36 v4.0.0, 0.38 v3.7.0, 0.22 v3.4.0, 0.12 v3.3.0, 0.21 v3.2.0, 0.07 v3.1.0, 0.11 v2.7.0, 0.27 v2.6.0, 0.17 v2.5.0, 0.25 v2.4.0, 0.67 v2.2.1, 0.67 v2.2.0, 0.57 v2.1.0, 0.29 v2.0.0
% Syntax   : Number of clauses     :   16 (  16 unt;   0 nHn;   1 RR)
%            Number of literals    :   16 (  16 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   3 con; 0-2 aty)
%            Number of variables   :   33 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : ORDERING LPO inverse > product > greatest_lower_bound >
%            least_upper_bound > identity > a > b
%          : This is a standardized version of the problem that appears in
%            [Sch95].
% Bugfixes : v1.2.1 - Duplicate axioms in GRP004-2.ax removed.
%--------------------------------------------------------------------------
%----Include equality group theory axioms
include('Axioms/GRP004-0.ax').
%----Include Lattice ordered group (equality) axioms
include('Axioms/GRP004-2.ax').
%--------------------------------------------------------------------------
cnf(prove_p22a,negated_conjecture,
    least_upper_bound(least_upper_bound(multiply(a,b),identity),multiply(least_upper_bound(a,identity),least_upper_bound(b,identity))) != multiply(least_upper_bound(a,identity),least_upper_bound(b,identity)) ).

%--------------------------------------------------------------------------
