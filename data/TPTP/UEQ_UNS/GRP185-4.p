%--------------------------------------------------------------------------
% File     : GRP185-4 : TPTP v9.2.1. Bugfixed v1.2.1.
% Domain   : Group Theory (Lattice Ordered)
% Problem  : Application of monotonicity and distributivity
% Version  : [Fuc94] (equality) axioms : Augmented.
%            Theorem formulation : Using a dual definition of =<.
% English  :

% Refs     : [Fuc94] Fuchs (1994), The Application of Goal-Orientated Heuri
%          : [Sch95] Schulz (1995), Explanation Based Learning for Distribu
% Source   : [Sch95]
% Names    : p22b [Sch95]

% Status   : Unsatisfiable
% Rating   : 0.26 v9.1.0, 0.32 v8.2.0, 0.46 v8.1.0, 0.60 v7.5.0, 0.42 v7.4.0, 0.39 v7.3.0, 0.37 v7.1.0, 0.33 v7.0.0, 0.42 v6.4.0, 0.47 v6.3.0, 0.41 v6.2.0, 0.50 v6.0.0, 0.62 v5.5.0, 0.58 v5.4.0, 0.47 v5.3.0, 0.33 v5.2.0, 0.43 v5.1.0, 0.40 v5.0.0, 0.43 v4.1.0, 0.45 v4.0.1, 0.43 v4.0.0, 0.46 v3.7.0, 0.33 v3.4.0, 0.25 v3.3.0, 0.21 v3.1.0, 0.33 v2.7.0, 0.36 v2.6.0, 0.67 v2.5.0, 0.75 v2.4.0, 0.67 v2.2.1, 0.67 v2.2.0, 0.57 v2.1.0, 0.43 v2.0.0
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
cnf(p22b_1,hypothesis,
    inverse(identity) = identity ).

cnf(p22b_2,hypothesis,
    inverse(inverse(X)) = X ).

cnf(p22b_3,hypothesis,
    inverse(multiply(X,Y)) = multiply(inverse(Y),inverse(X)) ).

cnf(prove_p22b,negated_conjecture,
    greatest_lower_bound(least_upper_bound(multiply(a,b),identity),multiply(least_upper_bound(a,identity),least_upper_bound(b,identity))) != least_upper_bound(multiply(a,b),identity) ).

%--------------------------------------------------------------------------
