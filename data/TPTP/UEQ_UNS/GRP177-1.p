%--------------------------------------------------------------------------
% File     : GRP177-1 : TPTP v9.2.1. Bugfixed v1.2.1.
% Domain   : Group Theory (Lattice Ordered)
% Problem  : A consequence of monotonicity
% Version  : [Fuc94] (equality) axioms.
% English  :

% Refs     : [Fuc94] Fuchs (1994), The Application of Goal-Orientated Heuri
%          : [Sch95] Schulz (1995), Explanation Based Learning for Distribu
% Source   : [Sch95]
% Names    : p08a [Sch95]

% Status   : Unsatisfiable
% Rating   : 0.96 v9.1.0, 0.91 v9.0.0, 0.95 v8.2.0, 0.96 v8.1.0, 0.95 v7.5.0, 1.00 v2.0.0
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
cnf(p08a_1,hypothesis,
    least_upper_bound(identity,a) = a ).

cnf(p08a_2,hypothesis,
    least_upper_bound(identity,b) = b ).

cnf(p08a_3,hypothesis,
    least_upper_bound(identity,c) = c ).

cnf(prove_p08a,negated_conjecture,
    least_upper_bound(greatest_lower_bound(a,multiply(b,c)),multiply(greatest_lower_bound(a,b),greatest_lower_bound(a,c))) != multiply(greatest_lower_bound(a,b),greatest_lower_bound(a,c)) ).

%--------------------------------------------------------------------------
