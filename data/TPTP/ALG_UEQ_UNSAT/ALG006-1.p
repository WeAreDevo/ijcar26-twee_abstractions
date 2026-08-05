%--------------------------------------------------------------------------
% File     : ALG006-1 : TPTP v9.2.1. Released v2.2.0.
% Domain   : General Algebra
% Problem  : Simplification of Kalman's set difference basis (part 1)
% Version  : [MP96] (equality) axioms : Especial.
% English  : This is part 1 of a proof that one of the axioms in Kalman's
%            basis for set difference can be simplified.

% Refs     : [McC98] McCune (1998), Email to G. Sutcliffe
%          : [MP96]  McCune & Padmanabhan (1996), Automated Deduction in Eq
% Source   : [McC98]
% Names    : SD-3-a [MP96]

% Status   : Unsatisfiable
% Rating   : 0.04 v9.1.0, 0.05 v8.2.0, 0.04 v8.1.0, 0.15 v7.5.0, 0.17 v7.4.0, 0.22 v7.3.0, 0.06 v7.0.0, 0.05 v6.4.0, 0.11 v6.3.0, 0.06 v6.2.0, 0.06 v6.0.0, 0.24 v5.5.0, 0.26 v5.4.0, 0.07 v5.3.0, 0.00 v5.2.0, 0.07 v5.0.0, 0.00 v3.4.0, 0.12 v3.3.0, 0.00 v2.2.1
% Syntax   : Number of clauses     :    4 (   4 unt;   0 nHn;   1 RR)
%            Number of literals    :    4 (   4 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    4 (   4 usr;   3 con; 0-2 aty)
%            Number of variables   :    7 (   1 sgn)
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

%----Denial of simplified third axiom:
cnf(prove_set_difference_3_simplified,negated_conjecture,
    difference(difference(a,c),b) != difference(difference(a,b),c) ).

%--------------------------------------------------------------------------
