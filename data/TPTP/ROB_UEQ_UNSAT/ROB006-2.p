%--------------------------------------------------------------------------
% File     : ROB006-2 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Robbins Algebra
% Problem  : Exists absorbed element => Exists idempotent element
% Version  : [Win90] (equality) axioms.
%            Theorem formulation : Denies idempotence.
% English  : If there are elements c and d such that c+d=d, then the
%            algebra is Boolean.

% Refs     : [HMT71] Henkin et al. (1971), Cylindrical Algebras
%          : [Win90] Winker (1990), Robbins Algebra: Conditions that make a
%          : [Wos92] Wos (1992), An Opportunity to Test Your Skills, and th
% Source   : [Wos92]
% Names    : Theorem 1.1 [Win90]

% Status   : Unsatisfiable
% Rating   : 0.96 v9.1.0, 0.95 v8.2.0, 0.96 v8.1.0, 1.00 v7.5.0, 0.96 v7.3.0, 0.95 v7.1.0, 0.94 v7.0.0, 0.95 v6.3.0, 0.94 v6.2.0, 0.86 v6.1.0, 0.94 v6.0.0, 0.95 v5.4.0, 0.87 v5.3.0, 0.83 v5.2.0, 0.86 v5.1.0, 0.93 v4.1.0, 0.91 v4.0.1, 0.93 v4.0.0, 0.92 v3.7.0, 0.78 v3.4.0, 0.88 v3.3.0, 0.86 v3.1.0, 0.89 v2.7.0, 0.91 v2.6.0, 0.83 v2.5.0, 0.75 v2.4.0, 0.67 v2.3.0, 1.00 v2.0.0
% Syntax   : Number of clauses     :    5 (   5 unt;   0 nHn;   2 RR)
%            Number of literals    :    5 (   5 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    4 (   4 usr;   2 con; 0-2 aty)
%            Number of variables   :    8 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Commutativity, associativity, and Huntington's axiom
%            axiomatize Boolean algebra.
%--------------------------------------------------------------------------
%----Include axioms for Robbins algebra
include('Axioms/ROB001-0.ax').
%--------------------------------------------------------------------------
cnf(absorbtion,hypothesis,
    add(c,d) = d ).

cnf(prove_idempotence,negated_conjecture,
    add(X,X) != X ).

%--------------------------------------------------------------------------
