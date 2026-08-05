%--------------------------------------------------------------------------
% File     : ALG005-1 : TPTP v9.2.1. Released v2.2.0.
% Domain   : General Algebra
% Problem  : Associativity of intersection in terms of set difference.
% Version  : [MP96] (equality) axioms : Especial.
% English  : Starting with Kalman's basis for families of sets closed under
%            set difference, we define intersection and show it to be
%            associative.

% Refs     : [McC98] McCune (1998), Email to G. Sutcliffe
%          : [MP96]  McCune & Padmanabhan (1996), Automated Deduction in Eq
% Source   : [McC98]
% Names    : SD-2-a [MP96]

% Status   : Unsatisfiable
% Rating   : 0.04 v9.1.0, 0.09 v8.2.0, 0.17 v8.1.0, 0.20 v7.5.0, 0.25 v7.4.0, 0.26 v7.3.0, 0.11 v7.0.0, 0.16 v6.4.0, 0.21 v6.3.0, 0.18 v6.2.0, 0.25 v6.0.0, 0.43 v5.5.0, 0.42 v5.4.0, 0.27 v5.3.0, 0.17 v5.2.0, 0.27 v5.0.0, 0.09 v4.0.1, 0.14 v4.0.0, 0.15 v3.7.0, 0.11 v3.4.0, 0.12 v3.3.0, 0.22 v2.7.0, 0.00 v2.2.1
% Syntax   : Number of clauses     :    5 (   5 unt;   0 nHn;   1 RR)
%            Number of literals    :    5 (   5 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   3 con; 0-2 aty)
%            Number of variables   :    9 (   1 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Kalman's axioms for set difference:
cnf(set_difference_1,axiom,
    difference(X,difference(Y,X)) = X ).

cnf(set_difference_2,axiom,
    difference(X,difference(X,Y)) = difference(Y,difference(Y,X)) ).

cnf(set_difference_3,axiom,
    difference(difference(X,Y),Z) = difference(difference(X,Z),difference(Y,Z)) ).

%----Definition of intersection:
cnf(intersection,axiom,
    multiply(X,Y) = difference(X,difference(X,Y)) ).

%----Denial of associativity:
cnf(prove_associativity_of_multiply,negated_conjecture,
    multiply(multiply(a,b),c) != multiply(a,multiply(b,c)) ).

%--------------------------------------------------------------------------
