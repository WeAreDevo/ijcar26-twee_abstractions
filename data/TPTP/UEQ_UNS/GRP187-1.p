%--------------------------------------------------------------------------
% File     : GRP187-1 : TPTP v9.2.1. Bugfixed v1.2.1.
% Domain   : Group Theory (Lattice Ordered)
% Problem  : Orthogonal elements commute
% Version  : [Fuc94] (equality) axioms.
% English  :

% Refs     : [Fuc94] Fuchs (1994), The Application of Goal-Orientated Heuri
%          : [Sch95] Schulz (1995), Explanation Based Learning for Distribu
%          : [Dah95] Dahn (1995), Email to G. Sutcliffe
% Source   : [Sch95]
% Names    : p33 [Sch95]

% Status   : Unsatisfiable
% Rating   : 0.70 v9.1.0, 0.68 v8.2.0, 0.67 v8.1.0, 0.75 v7.4.0, 0.78 v7.3.0, 0.68 v7.1.0, 0.61 v7.0.0, 0.63 v6.4.0, 0.74 v6.3.0, 0.71 v6.2.0, 0.57 v6.1.0, 0.75 v6.0.0, 0.76 v5.5.0, 0.79 v5.4.0, 0.80 v5.3.0, 0.75 v5.2.0, 0.79 v5.1.0, 0.80 v5.0.0, 0.79 v4.1.0, 0.73 v4.0.1, 0.71 v4.0.0, 0.62 v3.7.0, 0.56 v3.4.0, 0.62 v3.3.0, 0.64 v3.1.0, 0.56 v2.7.0, 0.55 v2.6.0, 0.50 v2.5.0, 0.75 v2.4.0, 0.67 v2.2.1, 1.00 v2.0.0
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
%          : [Dah95] says "Non-obvious. Usually proved using lat4."
% Bugfixes : v1.2.1 - Duplicate axioms in GRP004-2.ax removed.
%--------------------------------------------------------------------------
%----Include equality group theory axioms
include('Axioms/GRP004-0.ax').
%----Include Lattice ordered group (equality) axioms
include('Axioms/GRP004-2.ax').
%--------------------------------------------------------------------------
cnf(p33_1,hypothesis,
    greatest_lower_bound(least_upper_bound(a,inverse(a)),least_upper_bound(b,inverse(b))) = identity ).

cnf(prove_p33,negated_conjecture,
    multiply(a,b) != multiply(b,a) ).

%--------------------------------------------------------------------------
