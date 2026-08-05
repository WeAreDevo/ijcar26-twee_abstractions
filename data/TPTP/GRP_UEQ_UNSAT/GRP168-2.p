%--------------------------------------------------------------------------
% File     : GRP168-2 : TPTP v9.2.1. Bugfixed v1.2.1.
% Domain   : Group Theory (Lattice Ordered)
% Problem  : Inner group automorphisms are order preserving
% Version  : [Fuc94] (equality) axioms.
%            Theorem formulation : Dual.
% English  :

% Refs     : [Fuc94] Fuchs (1994), The Application of Goal-Orientated Heuri
%          : [Sch95] Schulz (1995), Explanation Based Learning for Distribu
% Source   : [Sch95]
% Names    : p01b [Sch95]

% Status   : Unsatisfiable
% Rating   : 0.00 v9.1.0, 0.05 v8.2.0, 0.08 v8.1.0, 0.10 v7.5.0, 0.12 v7.4.0, 0.13 v7.3.0, 0.11 v7.1.0, 0.06 v7.0.0, 0.16 v6.3.0, 0.18 v6.2.0, 0.21 v6.1.0, 0.19 v6.0.0, 0.24 v5.5.0, 0.16 v5.4.0, 0.13 v5.3.0, 0.17 v5.2.0, 0.14 v5.1.0, 0.20 v5.0.0, 0.21 v4.1.0, 0.18 v4.0.1, 0.21 v4.0.0, 0.23 v3.7.0, 0.11 v3.4.0, 0.12 v3.3.0, 0.14 v3.2.0, 0.07 v3.1.0, 0.11 v2.7.0, 0.00 v2.1.0, 0.14 v2.0.0
% Syntax   : Number of clauses     :   17 (  17 unt;   0 nHn;   2 RR)
%            Number of literals    :   17 (  17 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   4 con; 0-2 aty)
%            Number of variables   :   33 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : ORDERING LPO  inverse > product > greatest_lower_bound >
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
cnf(p01b_1,hypothesis,
    greatest_lower_bound(a,b) = a ).

cnf(prove_p01b,negated_conjecture,
    greatest_lower_bound(multiply(inverse(c),multiply(a,c)),multiply(inverse(c),multiply(b,c))) != multiply(inverse(c),multiply(a,c)) ).

%--------------------------------------------------------------------------
