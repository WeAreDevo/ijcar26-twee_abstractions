%--------------------------------------------------------------------------
% File     : RNG010-5 : TPTP v9.2.1. Bugfixed v2.3.0.
% Domain   : Ring Theory (Right alternative)
% Problem  : Skew symmetry of the auxilliary function
% Version  : [Ove90] (equality) axioms :
%            Incomplete > Augmented > Incomplete.
% English  : The three Moufang identities imply the skew symmetry
%            of s(W,X,Y,Z) = (W*X,Y,Z) - X*(W,Y,Z) - (X,Y,Z)*W.
%            Recall that skew symmetry means that the function sign
%            changes when any two arguments are swapped. This problem
%            proves the case for swapping the first two arguments.

% Refs     : [Ove90] Overbeek (1990), ATP competition announced at CADE-10
%          : [Ove93] Overbeek (1993), The CADE-11 Competitions: A Personal
%          : [LM93]  Lusk & McCune (1993), Uniform Strategies: The CADE-11
%          : [Zha93] Zhang (1993), Automated Proofs of Equality Problems in
% Source   : [Ove90]
% Names    : CADE-11 Competition Eq-9 [Ove90]
%          : THEOREM EQ-9 [LM93]
%          : PROBLEM 9 [Zha93]

% Status   : Unknown
% Rating   : 1.00 v2.3.0
% Syntax   : Number of clauses     :   27 (  27 unt;   0 nHn;   2 RR)
%            Number of literals    :   27 (  27 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   11 (  11 usr;   5 con; 0-4 aty)
%            Number of variables   :   52 (   2 sgn)
% SPC      : CNF_UNK_RFO_PEQ_UEQ

% Comments : I copied this directly. I think the Moufang identities may
%            be wrong. At least they're in another form.
%          : Yes, now they known to be wrong, and bugfixed in v2.3.0.
% Bugfixes : v2.3.0 - Clauses right_moufang and left_moufang fixed.
%--------------------------------------------------------------------------
%----Commutativity of addition
cnf(commutative_addition,axiom,
    add(X,Y) = add(Y,X) ).

%----Associativity of addition
cnf(associative_addition,axiom,
    add(add(X,Y),Z) = add(X,add(Y,Z)) ).

%----Additive identity
cnf(right_identity,axiom,
    add(X,additive_identity) = X ).

cnf(left_identity,axiom,
    add(additive_identity,X) = X ).

%----Additive inverse
cnf(right_additive_inverse,axiom,
    add(X,additive_inverse(X)) = additive_identity ).

cnf(left_additive_inverse,axiom,
    add(additive_inverse(X),X) = additive_identity ).

%----Inverse of identity is identity, stupid
cnf(additive_inverse_identity,axiom,
    additive_inverse(additive_identity) = additive_identity ).

%----Axiom of Overbeek
cnf(property_of_inverse_and_add,axiom,
    add(X,add(additive_inverse(X),Y)) = Y ).

%----Inverse of (x + y) is additive_inverse(x) + additive_inverse(y),
cnf(distribute_additive_inverse,axiom,
    additive_inverse(add(X,Y)) = add(additive_inverse(X),additive_inverse(Y)) ).

%----Inverse of additive_inverse of X is X
cnf(additive_inverse_additive_inverse,axiom,
    additive_inverse(additive_inverse(X)) = X ).

%----Behavior of 0 and the multiplication operation
cnf(multiply_additive_id1,axiom,
    multiply(X,additive_identity) = additive_identity ).

cnf(multiply_additive_id2,axiom,
    multiply(additive_identity,X) = additive_identity ).

%----Axiom of Overbeek
cnf(product_of_inverse,axiom,
    multiply(additive_inverse(X),additive_inverse(Y)) = multiply(X,Y) ).

%----x * additive_inverse(y) = additive_inverse (x * y),
cnf(multiply_additive_inverse1,axiom,
    multiply(X,additive_inverse(Y)) = additive_inverse(multiply(X,Y)) ).

cnf(multiply_additive_inverse2,axiom,
    multiply(additive_inverse(X),Y) = additive_inverse(multiply(X,Y)) ).

%----Distributive property of product over sum
cnf(distribute1,axiom,
    multiply(X,add(Y,Z)) = add(multiply(X,Y),multiply(X,Z)) ).

cnf(distribute2,axiom,
    multiply(add(X,Y),Z) = add(multiply(X,Z),multiply(Y,Z)) ).

%----Right alternative law
cnf(right_alternative,axiom,
    multiply(multiply(X,Y),Y) = multiply(X,multiply(Y,Y)) ).

%----Associator
cnf(associator,axiom,
    associator(X,Y,Z) = add(multiply(multiply(X,Y),Z),additive_inverse(multiply(X,multiply(Y,Z)))) ).

%----Commutator
cnf(commutator,axiom,
    commutator(X,Y) = add(multiply(Y,X),additive_inverse(multiply(X,Y))) ).

%----Middle associator identity
cnf(middle_associator,axiom,
    multiply(multiply(associator(X,X,Y),X),associator(X,X,Y)) = additive_identity ).

%----Left alternative law
cnf(left_alternative,axiom,
    multiply(multiply(X,X),Y) = multiply(X,multiply(X,Y)) ).

%----Definition of s
cnf(defines_s,axiom,
    s(W,X,Y,Z) = add(add(associator(multiply(W,X),Y,Z),additive_inverse(multiply(X,associator(W,Y,Z)))),additive_inverse(multiply(associator(X,Y,Z),W))) ).

%----Right Moufang
cnf(right_moufang,hypothesis,
    multiply(Z,multiply(X,multiply(Y,X))) = multiply(multiply(multiply(Z,X),Y),X) ).

%----Left Moufang
cnf(left_moufang,hypothesis,
    multiply(multiply(X,multiply(Y,X)),Z) = multiply(X,multiply(Y,multiply(X,Z))) ).

%----Middle Moufang
cnf(middle_moufang,hypothesis,
    multiply(multiply(X,Y),multiply(Z,X)) = multiply(multiply(X,multiply(Y,Z)),X) ).

cnf(prove_skew_symmetry,negated_conjecture,
    s(a,b,c,d) != additive_inverse(s(b,a,c,d)) ).

%--------------------------------------------------------------------------
