%--------------------------------------------------------------------------
% File     : GRP175-4 : TPTP v9.2.1. Bugfixed v1.2.1.
% Domain   : Group Theory (Lattice Ordered)
% Problem  : Positivity is preserved under inner automorphisms
% Version  : [Fuc94] (equality) axioms.
%            Theorem formulation : Variant, and using different definitions
%            for =<.
% English  :

% Refs     : [Fuc94] Fuchs (1994), The Application of Goal-Orientated Heuri
%          : [Sch95] Schulz (1995), Explanation Based Learning for Distribu
% Source   : [Sch95]
% Names    : p06d [Sch95]

% Status   : Unsatisfiable
% Rating   : 0.00 v8.2.0, 0.04 v8.1.0, 0.10 v7.5.0, 0.08 v7.4.0, 0.13 v7.3.0, 0.05 v7.1.0, 0.06 v7.0.0, 0.11 v6.4.0, 0.16 v6.3.0, 0.24 v6.2.0, 0.21 v6.1.0, 0.19 v6.0.0, 0.38 v5.5.0, 0.37 v5.4.0, 0.20 v5.3.0, 0.25 v5.2.0, 0.29 v5.1.0, 0.33 v5.0.0, 0.29 v4.1.0, 0.18 v4.0.1, 0.14 v4.0.0, 0.15 v3.7.0, 0.11 v3.4.0, 0.12 v3.3.0, 0.07 v3.2.0, 0.00 v3.1.0, 0.11 v2.7.0, 0.00 v2.2.1, 0.44 v2.2.0, 0.43 v2.1.0, 0.29 v2.0.0
% Syntax   : Number of clauses     :   17 (  17 unt;   0 nHn;   2 RR)
%            Number of literals    :   17 (  17 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   3 con; 0-2 aty)
%            Number of variables   :   33 (   2 sgn)
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
cnf(p06d_1,hypothesis,
    greatest_lower_bound(identity,b) = identity ).

cnf(prove_p06d,negated_conjecture,
    least_upper_bound(identity,multiply(inverse(a),multiply(b,a))) != multiply(inverse(a),multiply(b,a)) ).

%--------------------------------------------------------------------------
