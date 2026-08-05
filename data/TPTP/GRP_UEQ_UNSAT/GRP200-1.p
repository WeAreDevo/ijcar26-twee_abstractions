%--------------------------------------------------------------------------
% File     : GRP200-1 : TPTP v9.2.1. Released v2.2.0.
% Domain   : Group Theory (Loops)
% Problem  : In Loops, Moufang-1 => Moufang-2.
% Version  : [MP96] (equality) axioms.
% English  :

% Refs     : [McC98] McCune (1998), Email to G. Sutcliffe
%          : [Wos96] Wos (1996), OTTER and the Moufang Identity Problem
%          : [MP96]  McCune & Padmanabhan (1996), Automated Deduction in Eq
% Source   : [McC98]
% Names    : MFL-1 [MP96]
%          : - [Wos96]

% Status   : Unsatisfiable
% Rating   : 0.13 v9.1.0, 0.18 v8.2.0, 0.25 v8.1.0, 0.20 v7.5.0, 0.33 v7.4.0, 0.35 v7.3.0, 0.26 v7.1.0, 0.17 v7.0.0, 0.21 v6.4.0, 0.32 v6.3.0, 0.29 v6.1.0, 0.25 v6.0.0, 0.43 v5.5.0, 0.37 v5.4.0, 0.20 v5.3.0, 0.25 v5.2.0, 0.29 v5.1.0, 0.33 v5.0.0, 0.36 v4.1.0, 0.18 v4.0.1, 0.36 v4.0.0, 0.38 v3.7.0, 0.22 v3.4.0, 0.25 v3.3.0, 0.29 v3.1.0, 0.33 v2.7.0, 0.27 v2.6.0, 0.00 v2.2.1
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

%----Moufang-1:
cnf(moufang1,axiom,
    multiply(multiply(X,multiply(Y,Z)),X) = multiply(multiply(X,Y),multiply(Z,X)) ).

%----Denial of Moufang-2:
cnf(prove_moufang2,negated_conjecture,
    multiply(multiply(multiply(a,b),c),b) != multiply(a,multiply(b,multiply(c,b))) ).

%--------------------------------------------------------------------------
