%--------------------------------------------------------------------------
% File     : GRP205-1 : TPTP v9.2.1. Released v2.3.0.
% Domain   : Group Theory (Loops)
% Problem  : In Loops, Moufang-3 => Moufang-4.
% Version  : [MP96] (equality) axioms.
% English  :

% Refs     : [Wos96] Wos (1996), OTTER and the Moufang Identity Problem
% Source   : [Wos96]
% Names    : - [Wos96]

% Status   : Unsatisfiable
% Rating   : 0.26 v9.1.0, 0.27 v8.2.0, 0.38 v8.1.0, 0.30 v7.5.0, 0.38 v7.4.0, 0.43 v7.3.0, 0.42 v7.1.0, 0.33 v7.0.0, 0.32 v6.4.0, 0.37 v6.3.0, 0.35 v6.2.0, 0.36 v6.1.0, 0.44 v6.0.0, 0.52 v5.5.0, 0.53 v5.4.0, 0.40 v5.3.0, 0.42 v5.2.0, 0.43 v5.1.0, 0.47 v5.0.0, 0.43 v4.1.0, 0.27 v4.0.1, 0.43 v4.0.0, 0.38 v3.7.0, 0.33 v3.4.0, 0.38 v3.3.0, 0.43 v3.1.0, 0.33 v2.7.0, 0.36 v2.6.0, 0.00 v2.4.0, 0.33 v2.3.0
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

%----Moufang-3
cnf(moufang3,axiom,
    multiply(multiply(multiply(X,Y),X),Z) = multiply(X,multiply(Y,multiply(X,Z))) ).

%----Denial of Moufang-4
cnf(prove_moufang4,negated_conjecture,
    multiply(x,multiply(multiply(y,z),x)) != multiply(multiply(x,y),multiply(z,x)) ).

%--------------------------------------------------------------------------
