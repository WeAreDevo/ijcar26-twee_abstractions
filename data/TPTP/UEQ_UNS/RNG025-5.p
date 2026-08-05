%--------------------------------------------------------------------------
% File     : RNG025-5 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Ring Theory (Alternative)
% Problem  : Middle or Flexible Law
% Version  : [Ste87] (equality) axioms : Augmented.
%            Theorem formulation : Linearized.
% English  :

% Refs     : [Ste87] Stevens (1987), Some Experiments in Nonassociative Rin
%          : [Ste92] Stevens (1992), Unpublished Note
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.74 v9.1.0, 0.73 v9.0.0, 0.68 v8.2.0, 0.75 v8.1.0, 0.85 v7.5.0, 0.71 v7.4.0, 0.74 v7.3.0, 0.68 v7.1.0, 0.61 v7.0.0, 0.63 v6.4.0, 0.68 v6.3.0, 0.65 v6.2.0, 0.64 v6.1.0, 0.62 v6.0.0, 0.71 v5.5.0, 0.74 v5.4.0, 0.60 v5.3.0, 0.50 v5.2.0, 0.57 v5.1.0, 0.60 v5.0.0, 0.57 v4.1.0, 0.55 v4.0.1, 0.57 v4.0.0, 0.62 v3.7.0, 0.44 v3.4.0, 0.38 v3.3.0, 0.43 v3.2.0, 0.36 v3.1.0, 0.67 v2.7.0, 0.55 v2.6.0, 0.67 v2.5.0, 0.75 v2.4.0, 0.67 v2.2.1, 0.89 v2.2.0, 0.86 v2.1.0, 0.88 v2.0.0
% Syntax   : Number of clauses     :   23 (  23 unt;   0 nHn;   1 RR)
%            Number of literals    :   23 (  23 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    9 (   9 usr;   4 con; 0-3 aty)
%            Number of variables   :   45 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Include nonassociative ring axioms
include('Axioms/RNG003-0.ax').
%--------------------------------------------------------------------------
%----The next 7 clause are extra lemmas which Stevens found useful
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

cnf(prove_equation,negated_conjecture,
    add(associator(x,y,z),associator(x,z,y)) != additive_identity ).

%--------------------------------------------------------------------------
