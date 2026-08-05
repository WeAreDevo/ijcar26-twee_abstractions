%--------------------------------------------------------------------------
% File     : RNG010-7 : TPTP v9.2.1. Bugfixed v2.3.0.
% Domain   : Ring Theory (Right alternative)
% Problem  : Skew symmetry of the auxilliary function
% Version  : [Ste87] (equality) axioms : Augmented.
% English  : The three Moufang identities imply the skew symmetry
%            of s(W,X,Y,Z) = (W*X,Y,Z) - X*(W,Y,Z) - (X,Y,Z)*W.
%            Recall that skew symmetry means that the function sign
%            changes when any two arguments are swapped. This problem
%            proves the case for swapping the first two arguments.

% Refs     : [Ste87] Stevens (1987), Some Experiments in Nonassociative Rin
% Source   : [TPTP]
% Names    :

% Status   : Unknown
% Rating   : 1.00 v2.3.0
% Syntax   : Number of clauses     :   27 (  27 unt;   0 nHn;   1 RR)
%            Number of literals    :   27 (  27 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   11 (  11 usr;   5 con; 0-4 aty)
%            Number of variables   :   58 (   2 sgn)
% SPC      : CNF_UNK_RFO_PEQ_UEQ

% Comments : Extra lemmas added to help the ITP prover.
% Bugfixes : v2.3.0 - Clause prove_skew_symmetry fixed.
%          : v2.3.0 - Left alternative law added in.
%          : v2.3.0 - Clauses right_moufang and left_moufang fixed.
%--------------------------------------------------------------------------
%----Include nonassociative ring axioms.
include('Axioms/RNG003-0.ax').
%--------------------------------------------------------------------------
%----The next 7 clauses are extra lemmas which Stevens found useful
cnf(product_of_inverses,axiom,
    multiply(additive_inverse(X),additive_inverse(Y)) = multiply(X,Y) ).

cnf(inverse_product1,axiom,
    multiply(additive_inverse(X),Y) = additive_inverse(multiply(X,Y)) ).

cnf(inverse_product2,axiom,
    multiply(X,additive_inverse(Y)) = additive_inverse(multiply(X,Y)) ).

cnf(distributivity_of_difference1,axiom,
    multiply(X,add(Y,additive_inverse(Z))) = add(multiply(X,Y),additive_inverse(multiply(X,Z))) ).

cnf(distributivity_of_difference2,axiom,
    multiply(add(X,additive_inverse(Y)),Z) = add(multiply(X,Z),additive_inverse(multiply(Y,Z))) ).

cnf(distributivity_of_difference3,axiom,
    multiply(additive_inverse(X),add(Y,Z)) = add(additive_inverse(multiply(X,Y)),additive_inverse(multiply(X,Z))) ).

cnf(distributivity_of_difference4,axiom,
    multiply(add(X,Y),additive_inverse(Z)) = add(additive_inverse(multiply(X,Z)),additive_inverse(multiply(Y,Z))) ).

%----Definition of s
cnf(defines_s,axiom,
    s(W,X,Y,Z) = add(add(associator(multiply(W,X),Y,Z),additive_inverse(multiply(X,associator(W,Y,Z)))),additive_inverse(multiply(associator(X,Y,Z),W))) ).

%----Right Moufang
cnf(right_moufang,hypothesis,
    multiply(Z,multiply(X,multiply(Y,X))) = multiply(multiply(multiply(Z,X),Y),X) ).

%----Left Moufang
cnf(left_moufang,hypothesis,
    multiply(multiply(X,multiply(Y,X)),Z) = multiply(X,multiply(Y,multiply(X,Z))) ).

cnf(middle_moufang,hypothesis,
    multiply(multiply(X,Y),multiply(Z,X)) = multiply(multiply(X,multiply(Y,Z)),X) ).

cnf(prove_skew_symmetry,negated_conjecture,
    s(a,b,c,d) != additive_inverse(s(b,a,c,d)) ).

%--------------------------------------------------------------------------
