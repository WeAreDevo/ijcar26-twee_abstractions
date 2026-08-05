%--------------------------------------------------------------------------
% File     : GRP167-1 : TPTP v9.2.1. Bugfixed v1.2.1.
% Domain   : Group Theory (Lattice Ordered)
% Problem  : Product of positive and negative parts
% Version  : [Fuc94] (equality) axioms.
% English  : Each element in a lattice ordered group can be stated as a
%            product of it's positive and it's negative part.

% Refs     : [Fuc94] Fuchs (1994), The Application of Goal-Orientated Heuri
%          : [Sch95] Schulz (1995), Explanation Based Learning for Distribu
%          : [Dah95] Dahn (1995), Email to G. Sutcliffe
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.22 v9.1.0, 0.27 v8.2.0, 0.38 v8.1.0, 0.35 v7.5.0, 0.33 v7.4.0, 0.48 v7.3.0, 0.37 v7.1.0, 0.28 v7.0.0, 0.32 v6.4.0, 0.37 v6.3.0, 0.41 v6.2.0, 0.43 v6.1.0, 0.44 v6.0.0, 0.52 v5.5.0, 0.58 v5.4.0, 0.47 v5.3.0, 0.33 v5.2.0, 0.36 v5.1.0, 0.33 v5.0.0, 0.29 v4.1.0, 0.27 v4.0.1, 0.21 v4.0.0, 0.23 v3.7.0, 0.22 v3.4.0, 0.25 v3.3.0, 0.21 v3.1.0, 0.11 v2.7.0, 0.18 v2.6.0, 0.17 v2.5.0, 0.00 v2.4.0, 0.00 v2.2.1, 0.33 v2.2.0, 0.43 v2.1.0, 0.86 v2.0.0
% Syntax   : Number of clauses     :   20 (  20 unt;   0 nHn;   1 RR)
%            Number of literals    :   20 (  20 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   2 con; 0-2 aty)
%            Number of variables   :   41 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : ORDERING LPO inverse > greatest_lower_bound >
%            least_upper_bound > product > negative_part > positive_part >
%            identity > a
%          : This is a standardized version of the problem that appears in
%            [Sch95].
%          : [Dah95] says "This is crucial for reducing some problems
%            on arbitrary elements to problems on positive elements. The
%            proof is relatively difficult. It is non-obvious to humans
%            since the standard tactics (unfold definitions - use
%            distributivity - simplify) is not useful."
% Bugfixes : v1.2.1 - Duplicate axioms in GRP004-2.ax removed.
%--------------------------------------------------------------------------
%----Include equality group theory axioms
include('Axioms/GRP004-0.ax').
%----Include Lattice ordered group (equality) axioms
include('Axioms/GRP004-2.ax').
%--------------------------------------------------------------------------
cnf(lat4_1,axiom,
    positive_part(X) = least_upper_bound(X,identity) ).

cnf(lat4_2,axiom,
    negative_part(X) = greatest_lower_bound(X,identity) ).

cnf(lat4_3,axiom,
    least_upper_bound(X,greatest_lower_bound(Y,Z)) = greatest_lower_bound(least_upper_bound(X,Y),least_upper_bound(X,Z)) ).

cnf(lat4_4,axiom,
    greatest_lower_bound(X,least_upper_bound(Y,Z)) = least_upper_bound(greatest_lower_bound(X,Y),greatest_lower_bound(X,Z)) ).

cnf(prove_lat4,negated_conjecture,
    a != multiply(positive_part(a),negative_part(a)) ).

%--------------------------------------------------------------------------
