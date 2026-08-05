%--------------------------------------------------------------------------
% File     : GRP185-3 : TPTP v9.2.1. Bugfixed v1.2.1.
% Domain   : Group Theory (Lattice Ordered)
% Problem  : Application of monotonicity and distributivity
% Version  : [Fuc94] (equality) axioms.
%            Theorem formulation : Using a dual definition of =<.
% English  :

% Refs     : [Fuc94] Fuchs (1994), The Application of Goal-Orientated Heuri
%          : [Sch95] Schulz (1995), Explanation Based Learning for Distribu
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.26 v9.1.0, 0.27 v9.0.0, 0.32 v8.2.0, 0.46 v8.1.0, 0.60 v7.5.0, 0.46 v7.4.0, 0.43 v7.3.0, 0.42 v7.1.0, 0.33 v7.0.0, 0.42 v6.4.0, 0.47 v6.3.0, 0.41 v6.2.0, 0.43 v6.1.0, 0.44 v6.0.0, 0.67 v5.5.0, 0.63 v5.4.0, 0.47 v5.3.0, 0.33 v5.2.0, 0.43 v5.1.0, 0.47 v5.0.0, 0.50 v4.1.0, 0.55 v4.0.1, 0.50 v4.0.0, 0.54 v3.7.0, 0.33 v3.4.0, 0.25 v3.3.0, 0.21 v3.1.0, 0.33 v2.7.0, 0.36 v2.6.0, 0.67 v2.5.0, 0.75 v2.4.0, 0.33 v2.2.1, 0.56 v2.2.0, 0.43 v2.1.0, 0.43 v2.0.0
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
cnf(prove_p22b,negated_conjecture,
    greatest_lower_bound(least_upper_bound(multiply(a,b),identity),multiply(least_upper_bound(a,identity),least_upper_bound(b,identity))) != least_upper_bound(multiply(a,b),identity) ).

%--------------------------------------------------------------------------
