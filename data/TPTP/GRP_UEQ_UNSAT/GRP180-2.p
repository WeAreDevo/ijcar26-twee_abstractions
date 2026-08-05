%--------------------------------------------------------------------------
% File     : GRP180-2 : TPTP v9.2.1. Bugfixed v1.2.1.
% Domain   : Group Theory (Lattice Ordered)
% Problem  : Consequence of converting between GLB and LUB
% Version  : [Fuc94] (equality) axioms : Augmented.
% English  :

% Refs     : [Fuc94] Fuchs (1994), The Application of Goal-Orientated Heuri
%          : [Sch95] Schulz (1995), Explanation Based Learning for Distribu
% Source   : [Sch95]
% Names    : p11 [Sch95]

% Status   : Unsatisfiable
% Rating   : 0.48 v9.1.0, 0.50 v9.0.0, 0.45 v8.2.0, 0.50 v8.1.0, 0.60 v7.5.0, 0.46 v7.4.0, 0.57 v7.3.0, 0.37 v7.1.0, 0.28 v7.0.0, 0.32 v6.4.0, 0.42 v6.3.0, 0.41 v6.2.0, 0.57 v6.1.0, 0.69 v6.0.0, 0.76 v5.5.0, 0.79 v5.4.0, 0.73 v5.3.0, 0.67 v5.2.0, 0.64 v5.1.0, 0.53 v5.0.0, 0.50 v4.1.0, 0.45 v4.0.1, 0.43 v4.0.0, 0.38 v3.7.0, 0.33 v3.4.0, 0.50 v3.3.0, 0.43 v3.1.0, 0.33 v2.7.0, 0.55 v2.6.0, 0.50 v2.5.0, 0.25 v2.4.0, 0.33 v2.2.1, 0.78 v2.2.0, 0.86 v2.1.0, 0.86 v2.0.0
% Syntax   : Number of clauses     :   19 (  19 unt;   0 nHn;   2 RR)
%            Number of literals    :   19 (  19 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   3 con; 0-2 aty)
%            Number of variables   :   36 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : ORDERING LPO inverse > product > greatest_lower_bound >
%            least_upper_bound > identity > a > b
%          : ORDERING LPO greatest_lower_bound > least_upper_bound >
%            inverse > product > identity > a > b
% Bugfixes : v1.2.1 - Duplicate axioms in GRP004-2.ax removed.
%--------------------------------------------------------------------------
%----Include equality group theory axioms
include('Axioms/GRP004-0.ax').
%----Include Lattice ordered group (equality) axioms
include('Axioms/GRP004-2.ax').
%--------------------------------------------------------------------------
cnf(p11_1,hypothesis,
    inverse(identity) = identity ).

cnf(p11_2,hypothesis,
    inverse(inverse(X)) = X ).

cnf(p11_3,hypothesis,
    inverse(multiply(X,Y)) = multiply(inverse(Y),inverse(X)) ).

cnf(prove_p11,negated_conjecture,
    multiply(a,multiply(inverse(greatest_lower_bound(a,b)),b)) != least_upper_bound(a,b) ).

%--------------------------------------------------------------------------
