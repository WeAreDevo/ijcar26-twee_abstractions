%--------------------------------------------------------------------------
% File     : GRP496-1 : TPTP v9.2.1. Released v2.6.0.
% Domain   : Group Theory
% Problem  : Axiom for group theory, in double division and identity, part 1
% Version  : [McC93] (equality) axioms.
% English  :

% Refs     : [McC93] McCune (1993), Single Axioms for Groups and Abelian Gr
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.00 v9.1.0, 0.05 v8.2.0, 0.04 v8.1.0, 0.05 v7.5.0, 0.04 v7.4.0, 0.09 v7.3.0, 0.05 v7.1.0, 0.00 v6.3.0, 0.06 v6.2.0, 0.07 v6.1.0, 0.00 v6.0.0, 0.05 v5.5.0, 0.00 v2.6.0
% Syntax   : Number of clauses     :    5 (   5 unt;   0 nHn;   1 RR)
%            Number of literals    :    5 (   5 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   2 con; 0-2 aty)
%            Number of variables   :    7 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : A UEQ part of GRP080-1
%--------------------------------------------------------------------------
cnf(single_axiom,axiom,
    double_divide(double_divide(identity,double_divide(A,double_divide(B,identity))),double_divide(double_divide(B,double_divide(C,A)),identity)) = C ).

cnf(multiply,axiom,
    multiply(A,B) = double_divide(double_divide(B,A),identity) ).

cnf(inverse,axiom,
    inverse(A) = double_divide(A,identity) ).

cnf(identity,axiom,
    identity = double_divide(A,inverse(A)) ).

cnf(prove_these_axioms_1,negated_conjecture,
    multiply(inverse(a1),a1) != identity ).

%--------------------------------------------------------------------------
