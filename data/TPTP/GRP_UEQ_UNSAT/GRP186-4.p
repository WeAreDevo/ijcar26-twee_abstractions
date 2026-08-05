%--------------------------------------------------------------------------
% File     : GRP186-4 : TPTP v9.2.1. Bugfixed v1.2.1.
% Domain   : Group Theory (Lattice Ordered)
% Problem  : Application of distributivity and group theory
% Version  : [Fuc94] (equality) axioms : Augmented.
%            Theorem formulation : Switched from GLB to LUB.
% English  :

% Refs     : [Fuc94] Fuchs (1994), The Application of Goal-Orientated Heuri
%          : [Sch95] Schulz (1995), Explanation Based Learning for Distribu
% Source   : [Sch95]
% Names    : p23x [Sch95]

% Status   : Unsatisfiable
% Rating   : 0.00 v9.1.0, 0.05 v9.0.0, 0.00 v8.1.0, 0.05 v7.5.0, 0.00 v7.4.0, 0.04 v7.3.0, 0.05 v7.1.0, 0.00 v7.0.0, 0.05 v6.4.0, 0.11 v6.3.0, 0.06 v6.2.0, 0.07 v6.1.0, 0.06 v6.0.0, 0.24 v5.5.0, 0.21 v5.4.0, 0.00 v5.2.0, 0.07 v5.0.0, 0.00 v2.1.0, 0.14 v2.0.0
% Syntax   : Number of clauses     :   19 (  19 unt;   0 nHn;   2 RR)
%            Number of literals    :   19 (  19 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   3 con; 0-2 aty)
%            Number of variables   :   36 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : ORDERING LPO inverse > product > greatest_lower_bound >
%            least_upper_bound > identity > a > b
% Bugfixes : v1.2.1 - Duplicate axioms in GRP004-2.ax removed.
%--------------------------------------------------------------------------
%----Include equality group theory axioms
include('Axioms/GRP004-0.ax').
%----Include Lattice ordered group (equality) axioms
include('Axioms/GRP004-2.ax').
%--------------------------------------------------------------------------
cnf(p23x_1,hypothesis,
    inverse(identity) = identity ).

cnf(p23x_2,hypothesis,
    inverse(inverse(X)) = X ).

cnf(p23x_3,hypothesis,
    inverse(multiply(X,Y)) = multiply(inverse(Y),inverse(X)) ).

cnf(prove_p23x,negated_conjecture,
    least_upper_bound(multiply(a,b),identity) != multiply(a,least_upper_bound(inverse(a),b)) ).

%--------------------------------------------------------------------------
