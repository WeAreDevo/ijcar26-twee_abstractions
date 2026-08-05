%--------------------------------------------------------------------------
% File     : GRP483-1 : TPTP v9.2.1. Released v2.6.0.
% Domain   : Group Theory
% Problem  : Axiom for group theory, in double division and identity, part 3
% Version  : [McC93] (equality) axioms.
% English  :

% Refs     : [Neu86] Neumann (1986), Yet Another Single Law for Groups
%          : [McC93] McCune (1993), Single Axioms for Groups and Abelian Gr
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.09 v9.1.0, 0.14 v9.0.0, 0.09 v8.2.0, 0.12 v8.1.0, 0.15 v7.5.0, 0.12 v7.4.0, 0.22 v7.3.0, 0.16 v7.1.0, 0.06 v7.0.0, 0.11 v6.4.0, 0.16 v6.3.0, 0.06 v6.2.0, 0.07 v6.1.0, 0.06 v6.0.0, 0.24 v5.5.0, 0.26 v5.4.0, 0.07 v5.3.0, 0.00 v5.2.0, 0.07 v5.0.0, 0.00 v3.4.0, 0.12 v3.3.0, 0.00 v2.6.0
% Syntax   : Number of clauses     :    5 (   5 unt;   0 nHn;   1 RR)
%            Number of literals    :    5 (   5 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    7 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   4 con; 0-2 aty)
%            Number of variables   :    8 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : A UEQ part of GRP075-1
%--------------------------------------------------------------------------
cnf(single_axiom,axiom,
    double_divide(double_divide(double_divide(A,double_divide(B,identity)),double_divide(double_divide(C,double_divide(D,double_divide(D,identity))),double_divide(A,identity))),B) = C ).

cnf(multiply,axiom,
    multiply(A,B) = double_divide(double_divide(B,A),identity) ).

cnf(inverse,axiom,
    inverse(A) = double_divide(A,identity) ).

cnf(identity,axiom,
    identity = double_divide(A,inverse(A)) ).

cnf(prove_these_axioms_3,negated_conjecture,
    multiply(multiply(a3,b3),c3) != multiply(a3,multiply(b3,c3)) ).

%--------------------------------------------------------------------------
