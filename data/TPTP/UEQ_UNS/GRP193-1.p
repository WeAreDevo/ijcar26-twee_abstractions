%--------------------------------------------------------------------------
% File     : GRP193-1 : TPTP v9.2.1. Bugfixed v1.2.1.
% Domain   : Group Theory (Lattice Ordered)
% Problem  : A combination of distributivity and monotonicity
% Version  : [Fuc94] (equality) axioms.
% English  :

% Refs     : [Fuc94] Fuchs (1994), The Application of Goal-Orientated Heuri
%          : [Sch95] Schulz (1995), Explanation Based Learning for Distribu
% Source   : [Sch95]
% Names    : p8_9a [Sch95]

% Status   : Unsatisfiable
% Rating   : 0.00 v7.5.0, 0.04 v7.4.0, 0.09 v7.3.0, 0.00 v7.0.0, 0.05 v6.3.0, 0.12 v6.2.0, 0.14 v6.1.0, 0.06 v6.0.0, 0.19 v5.5.0, 0.16 v5.4.0, 0.00 v5.2.0, 0.07 v5.1.0, 0.00 v5.0.0, 0.07 v4.1.0, 0.09 v4.0.1, 0.07 v4.0.0, 0.08 v3.7.0, 0.11 v3.4.0, 0.12 v3.3.0, 0.00 v2.2.1, 0.44 v2.2.0, 0.43 v2.1.0, 0.14 v2.0.0
% Syntax   : Number of clauses     :   21 (  21 unt;   0 nHn;   6 RR)
%            Number of literals    :   21 (  21 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   4 con; 0-2 aty)
%            Number of variables   :   33 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : ORDERING LPO greatest_lower_bound > least_upper_bound >
%            inverse > product > identity > a > b > c
% Bugfixes : v1.2.1 - Duplicate axioms in GRP004-2.ax removed.
%--------------------------------------------------------------------------
%----Include equality group theory axioms
include('Axioms/GRP004-0.ax').
%----Include Lattice ordered group (equality) axioms
include('Axioms/GRP004-2.ax').
%--------------------------------------------------------------------------
cnf(p8_9a_1,hypothesis,
    least_upper_bound(identity,a) = a ).

cnf(p8_9a_2,hypothesis,
    least_upper_bound(identity,b) = b ).

cnf(p8_9a_3,hypothesis,
    least_upper_bound(identity,c) = c ).

cnf(p8_9a_4,hypothesis,
    greatest_lower_bound(a,b) = identity ).

cnf(p8_9a_5,hypothesis,
    least_upper_bound(greatest_lower_bound(a,multiply(b,c)),multiply(greatest_lower_bound(a,b),greatest_lower_bound(a,c))) = multiply(greatest_lower_bound(a,b),greatest_lower_bound(a,c)) ).

cnf(prove_p8_9a,negated_conjecture,
    greatest_lower_bound(a,multiply(b,c)) != greatest_lower_bound(a,c) ).

%--------------------------------------------------------------------------
