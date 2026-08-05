%--------------------------------------------------------------------------
% File     : ROB013-1 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Robbins Algebra
% Problem  : If -(a + b) = c then -(c + -(-b + a)) = a
% Version  : [Win90] (equality) axioms.
% English  :

% Refs     : [Win90] Winker (1990), Robbins Algebra: Conditions that make a
% Source   : [Win90]
% Names    : Lemma 3.5 [Win90]

% Status   : Unsatisfiable
% Rating   : 0.00 v7.4.0, 0.04 v7.3.0, 0.00 v7.0.0, 0.05 v6.3.0, 0.00 v6.0.0, 0.05 v5.5.0, 0.00 v2.0.0
% Syntax   : Number of clauses     :    5 (   5 unt;   0 nHn;   2 RR)
%            Number of literals    :    5 (   5 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   3 con; 0-2 aty)
%            Number of variables   :    7 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Include axioms for Robbins algebra
include('Axioms/ROB001-0.ax').
%--------------------------------------------------------------------------
cnf(condition,hypothesis,
    negate(add(a,b)) = c ).

cnf(prove_result,negated_conjecture,
    negate(add(c,negate(add(negate(b),a)))) != a ).

%--------------------------------------------------------------------------
