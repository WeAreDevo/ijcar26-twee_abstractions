%--------------------------------------------------------------------------
% File     : GRP177-2 : TPTP v9.2.1. Bugfixed v1.2.1.
% Domain   : Group Theory (Lattice Ordered)
% Problem  : A consequence of monotonicity
% Version  : [Fuc94] (equality) axioms.
%            Theorem formulation : Dual.
% English  :

% Refs     : [Fuc94] Fuchs (1994), The Application of Goal-Orientated Heuri
%          : [Sch95] Schulz (1995), Explanation Based Learning for Distribu
% Source   : [Sch95]
% Names    : p08b [Sch95]

% Status   : Unsatisfiable
% Rating   : 0.61 v9.1.0, 0.55 v8.2.0, 0.62 v8.1.0, 0.75 v7.5.0, 0.54 v7.4.0, 0.61 v7.3.0, 0.53 v7.1.0, 0.50 v7.0.0, 0.53 v6.4.0, 0.58 v6.3.0, 0.53 v6.2.0, 0.43 v6.1.0, 0.56 v6.0.0, 0.67 v5.5.0, 0.63 v5.4.0, 0.47 v5.3.0, 0.33 v5.2.0, 0.43 v5.1.0, 0.40 v5.0.0, 0.36 v4.0.1, 0.43 v4.0.0, 0.46 v3.7.0, 0.33 v3.4.0, 0.25 v3.3.0, 0.21 v3.1.0, 0.33 v2.7.0, 0.36 v2.6.0, 0.50 v2.5.0, 0.75 v2.4.0, 0.67 v2.2.1, 0.78 v2.2.0, 0.71 v2.1.0, 0.86 v2.0.0
% Syntax   : Number of clauses     :   19 (  19 unt;   0 nHn;   4 RR)
%            Number of literals    :   19 (  19 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   4 con; 0-2 aty)
%            Number of variables   :   33 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : ORDERING LPO inverse > product > greatest_lower_bound >
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
cnf(p08b_1,hypothesis,
    greatest_lower_bound(identity,a) = identity ).

cnf(p08b_2,hypothesis,
    greatest_lower_bound(identity,b) = identity ).

cnf(p08b_3,hypothesis,
    greatest_lower_bound(identity,c) = identity ).

cnf(prove_p08b,negated_conjecture,
    greatest_lower_bound(greatest_lower_bound(a,multiply(b,c)),multiply(greatest_lower_bound(a,b),greatest_lower_bound(a,c))) != greatest_lower_bound(a,multiply(b,c)) ).

%--------------------------------------------------------------------------
