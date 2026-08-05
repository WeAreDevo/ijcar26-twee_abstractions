%--------------------------------------------------------------------------
% File     : RNG009-5 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Ring Theory
% Problem  : If X*X*X = X then the ring is commutative
% Version  : [Peterson & Stickel, 1981] (equality) axioms :
%            Reduced > Incomplete.
% English  : Given a ring in which for all x, x * x * x = x, prove that
%            for all x and y, x * y = y * x.

% Refs     : [PS81]  Peterson & Stickel (1981), Complete Sets of Reductions
%          : [Ove90] Overbeek (1990), ATP competition announced at CADE-10
%          : [Ove93] Overbeek (1993), The CADE-11 Competitions: A Personal
%          : [LM93]  Lusk & McCune (1993), Uniform Strategies: The CADE-11
%          : [Zha93] Zhang (1993), Automated Proofs of Equality Problems in
% Source   : [Ove90]
% Names    : CADE-11 Competition Eq-7 [Ove90]
%          : THEOREM EQ-7 [LM93]
%          : PROBLEM 7 [Zha93]

% Status   : Unsatisfiable
% Rating   : 0.48 v9.1.0, 0.50 v8.2.0, 0.54 v8.1.0, 0.55 v7.5.0, 0.67 v7.4.0, 0.65 v7.3.0, 0.68 v7.2.0, 0.63 v7.1.0, 0.56 v7.0.0, 0.53 v6.4.0, 0.58 v6.3.0, 0.65 v6.2.0, 0.57 v6.1.0, 0.62 v6.0.0, 0.71 v5.5.0, 0.68 v5.4.0, 0.67 v5.2.0, 0.64 v5.1.0, 0.67 v5.0.0, 0.64 v4.0.0, 0.62 v3.7.0, 0.56 v3.4.0, 0.62 v3.3.0, 0.50 v3.1.0, 0.44 v2.7.0, 0.36 v2.6.0, 0.17 v2.5.0, 0.25 v2.4.0, 0.00 v2.2.1, 0.67 v2.2.0, 0.71 v2.1.0, 1.00 v2.0.0
% Syntax   : Number of clauses     :    9 (   9 unt;   0 nHn;   1 RR)
%            Number of literals    :    9 (   9 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   3 con; 0-2 aty)
%            Number of variables   :   17 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Right identity and inverse
cnf(right_identity,axiom,
    add(X,additive_identity) = X ).

cnf(right_additive_inverse,axiom,
    add(X,additive_inverse(X)) = additive_identity ).

%----Distributive property of product over sum
cnf(distribute1,axiom,
    multiply(X,add(Y,Z)) = add(multiply(X,Y),multiply(X,Z)) ).

cnf(distribute2,axiom,
    multiply(add(X,Y),Z) = add(multiply(X,Z),multiply(Y,Z)) ).

%----Associativity of addition
cnf(associative_addition,axiom,
    add(add(X,Y),Z) = add(X,add(Y,Z)) ).

%----Commutativity of addition
cnf(commutative_addition,axiom,
    add(X,Y) = add(Y,X) ).

%----Associativity of product
cnf(associative_multiplication,axiom,
    multiply(multiply(X,Y),Z) = multiply(X,multiply(Y,Z)) ).

cnf(x_cubed_is_x,hypothesis,
    multiply(X,multiply(X,X)) = X ).

cnf(prove_commutativity,negated_conjecture,
    multiply(a,b) != multiply(b,a) ).

%--------------------------------------------------------------------------
