%--------------------------------------------------------------------------
% File     : GRP206-1 : TPTP v9.2.1. Released v2.3.0.
% Domain   : Group Theory (Loops)
% Problem  : In Loops, Moufang-4 => Moufang-1.
% Version  : [MP96] (equality) axioms.
% English  :

% Refs     : [Wos96] Wos (1996), OTTER and the Moufang Identity Problem
% Source   : [Wos96]
% Names    : - [Wos96]

% Status   : Unsatisfiable
% Rating   : 0.00 v9.1.0, 0.05 v9.0.0, 0.00 v8.2.0, 0.04 v8.1.0, 0.05 v7.5.0, 0.04 v7.4.0, 0.09 v7.3.0, 0.00 v7.0.0, 0.11 v6.3.0, 0.12 v6.2.0, 0.14 v6.1.0, 0.06 v6.0.0, 0.19 v5.5.0, 0.16 v5.4.0, 0.00 v5.1.0, 0.13 v5.0.0, 0.14 v4.1.0, 0.18 v4.0.1, 0.14 v4.0.0, 0.15 v3.7.0, 0.11 v3.4.0, 0.12 v3.3.0, 0.00 v2.3.0
% Syntax   : Number of clauses     :   10 (  10 unt;   0 nHn;   1 RR)
%            Number of literals    :   10 (  10 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    9 (   9 usr;   4 con; 0-2 aty)
%            Number of variables   :   15 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Loop axioms:
cnf(left_identity,axiom,
    multiply(identity,X) = X ).

cnf(right_identity,axiom,
    multiply(X,identity) = X ).

cnf(multiply_left_division,axiom,
    multiply(X,left_division(X,Y)) = Y ).

cnf(left_division_multiply,axiom,
    left_division(X,multiply(X,Y)) = Y ).

cnf(multiply_right_division,axiom,
    multiply(right_division(X,Y),Y) = X ).

cnf(right_division_multiply,axiom,
    right_division(multiply(X,Y),Y) = X ).

cnf(right_inverse,axiom,
    multiply(X,right_inverse(X)) = identity ).

cnf(left_inverse,axiom,
    multiply(left_inverse(X),X) = identity ).

%----Moufang-4
cnf(moufang4,axiom,
    multiply(X,multiply(multiply(Y,Z),X)) = multiply(multiply(X,Y),multiply(Z,X)) ).

%----Denial of Moufang-1
cnf(prove_moufang1,negated_conjecture,
    multiply(multiply(a,multiply(b,c)),a) != multiply(multiply(a,b),multiply(c,a)) ).

%--------------------------------------------------------------------------
