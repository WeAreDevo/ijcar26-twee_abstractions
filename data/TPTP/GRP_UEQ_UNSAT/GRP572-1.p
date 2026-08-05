%--------------------------------------------------------------------------
% File     : GRP572-1 : TPTP v9.2.1. Bugfixed v2.7.0.
% Domain   : Group Theory (Abelian)
% Problem  : Axiom for Abelian group theory, in double div and id, part 4
% Version  : [McC93] (equality) axioms.
% English  :

% Refs     : [McC93] McCune (1993), Single Axioms for Groups and Abelian Gr
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.00 v9.1.0, 0.05 v8.2.0, 0.04 v8.1.0, 0.05 v7.5.0, 0.08 v7.4.0, 0.17 v7.3.0, 0.16 v7.1.0, 0.06 v7.0.0, 0.11 v6.4.0, 0.16 v6.3.0, 0.18 v6.2.0, 0.21 v6.1.0, 0.12 v6.0.0, 0.29 v5.5.0, 0.26 v5.4.0, 0.07 v5.3.0, 0.08 v5.2.0, 0.14 v5.1.0, 0.13 v5.0.0, 0.07 v4.1.0, 0.00 v4.0.1, 0.07 v4.0.0, 0.08 v3.7.0, 0.00 v3.3.0, 0.07 v3.1.0, 0.11 v2.7.0
% Syntax   : Number of clauses     :    5 (   5 unt;   0 nHn;   1 RR)
%            Number of literals    :    5 (   5 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   3 con; 0-2 aty)
%            Number of variables   :    7 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : A UEQ part of GRP100-1
% Bugfixes : v2.7.0 - Grounded conjecture
%--------------------------------------------------------------------------
cnf(single_axiom,axiom,
    double_divide(double_divide(A,double_divide(double_divide(B,double_divide(A,C)),double_divide(C,identity))),double_divide(identity,identity)) = B ).

cnf(multiply,axiom,
    multiply(A,B) = double_divide(double_divide(B,A),identity) ).

cnf(inverse,axiom,
    inverse(A) = double_divide(A,identity) ).

cnf(identity,axiom,
    identity = double_divide(A,inverse(A)) ).

cnf(prove_these_axioms_4,negated_conjecture,
    multiply(a,b) != multiply(b,a) ).

%--------------------------------------------------------------------------
