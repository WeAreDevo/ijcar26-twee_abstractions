%--------------------------------------------------------------------------
% File     : ROB020-2 : TPTP v9.2.1. Bugfixed v3.1.0.
% Domain   : Robbins Algebra
% Problem  : -(a + -b)=b => Exists idempotent element
% Version  : [Win90] (equality) axioms.
%            Theorem formulation : Denies Huntington's axiom, double
%            negation, and idempotence.
% English  : If there exist a, b such that -(a + -b) = b, the algebra
%            is Boolean.

% Refs     : [HMT71] Henkin et al. (1971), Cylindrical Algebras
%          : [Win90] Winker (1990), Robbins Algebra: Conditions that make a
% Source   : [Win90]
% Names    : Corollary 3.10 [Win90]

% Status   : Unknown
% Rating   : 1.00 v3.1.0
% Syntax   : Number of clauses     :    5 (   5 unt;   0 nHn;   2 RR)
%            Number of literals    :    5 (   5 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    4 (   4 usr;   2 con; 0-2 aty)
%            Number of variables   :    8 (   0 sgn)
% SPC      : CNF_UNK_RFO_PEQ_UEQ

% Comments : Commutativity, associativity, and Huntington's axiom
%            axiomatize Boolean algebra.
% Bugfixes : v3.1.0 - Removed extra negated_conjecture clauses.
%--------------------------------------------------------------------------
%----Include axioms for Robbins algebra
include('Axioms/ROB001-0.ax').
%--------------------------------------------------------------------------
cnf(condition1,hypothesis,
    negate(add(a,negate(b))) = b ).

cnf(prove_idempotence,negated_conjecture,
    add(X,X) != X ).

%--------------------------------------------------------------------------
