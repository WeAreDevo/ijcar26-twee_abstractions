%--------------------------------------------------------------------------
% File     : ROB008-1 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Robbins Algebra
% Problem  : If -(a + -(b + c)) = -(a + b + -c) then a+b=a
% Version  : [Win90] (equality) axioms.
% English  :

% Refs     : [Win90] Winker (1990), Robbins Algebra: Conditions that make a
% Source   : [Win90]
% Names    : Lemma 3.1 [Win90]

% Status   : Unsatisfiable
% Rating   : 0.04 v9.1.0, 0.14 v9.0.0, 0.09 v8.2.0, 0.12 v8.1.0, 0.20 v7.5.0, 0.12 v7.4.0, 0.17 v7.3.0, 0.11 v7.1.0, 0.06 v7.0.0, 0.11 v6.3.0, 0.06 v6.2.0, 0.07 v6.1.0, 0.19 v6.0.0, 0.24 v5.5.0, 0.21 v5.4.0, 0.13 v5.3.0, 0.08 v5.2.0, 0.07 v5.1.0, 0.20 v5.0.0, 0.14 v4.1.0, 0.09 v4.0.1, 0.07 v4.0.0, 0.08 v3.7.0, 0.00 v2.2.1, 0.44 v2.2.0, 0.43 v2.1.0, 0.62 v2.0.0
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
    negate(add(a,negate(add(b,c)))) = negate(add(a,add(b,negate(c)))) ).

cnf(prove_result,negated_conjecture,
    add(a,b) != a ).

%--------------------------------------------------------------------------
