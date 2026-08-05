%--------------------------------------------------------------------------
% File     : GRP114-1 : TPTP v9.2.1. Released v1.2.0.
% Domain   : Group Theory
% Problem  : Product of positive and negative parts of X equals X
% Version  : [MOW76] (equality) axioms : Augmented.
% English  : Prove that for each element X in a group, X is equal to the
%            product of its positive part (the union with the identity)
%            and its negative part (the intersection with the identity).

% Refs     : [Wos94] Wos (1994), Challenge in Group Theory
% Source   : [Wos94]
% Names    : - [Wos94]

% Status   : Unsatisfiable
% Rating   : 0.30 v9.1.0, 0.41 v9.0.0, 0.36 v8.2.0, 0.38 v8.1.0, 0.40 v7.5.0, 0.29 v7.4.0, 0.43 v7.3.0, 0.32 v7.1.0, 0.28 v7.0.0, 0.32 v6.4.0, 0.42 v6.3.0, 0.47 v6.2.0, 0.57 v6.1.0, 0.50 v6.0.0, 0.57 v5.5.0, 0.63 v5.4.0, 0.47 v5.3.0, 0.42 v5.2.0, 0.43 v5.1.0, 0.53 v5.0.0, 0.50 v4.1.0, 0.55 v4.0.1, 0.43 v4.0.0, 0.38 v3.7.0, 0.33 v3.4.0, 0.25 v3.3.0, 0.29 v3.1.0, 0.22 v2.7.0, 0.36 v2.6.0, 0.17 v2.5.0, 0.00 v2.4.0, 0.00 v2.2.1, 0.44 v2.2.0, 0.57 v2.1.0, 0.86 v2.0.0
% Syntax   : Number of clauses     :   21 (  21 unt;   0 nHn;   2 RR)
%            Number of literals    :   21 (  21 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   2 con; 0-2 aty)
%            Number of variables   :   38 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : I know some of the axioms are redundant, and have put comments
%            to that effect. However, I don't know how to make a complete
%            standard axiomatisation for the union and intersection axioms.
%--------------------------------------------------------------------------
%----Include the axioms for named groups
include('Axioms/GRP004-0.ax').
%--------------------------------------------------------------------------
%----This axiom is a lemma
cnf(inverse_of_identity,axiom,
    inverse(identity) = identity ).

%----This axiom is a lemma
cnf(inverse_involution,axiom,
    inverse(inverse(X)) = X ).

%----This axiom is a lemma
cnf(inverse_product_lemma,axiom,
    inverse(multiply(X,Y)) = multiply(inverse(Y),inverse(X)) ).

cnf(intersection_idempotent,axiom,
    intersection(X,X) = X ).

cnf(union_idempotent,axiom,
    union(X,X) = X ).

cnf(intersection_commutative,axiom,
    intersection(X,Y) = intersection(Y,X) ).

cnf(union_commutative,axiom,
    union(X,Y) = union(Y,X) ).

cnf(intersection_associative,axiom,
    intersection(X,intersection(Y,Z)) = intersection(intersection(X,Y),Z) ).

cnf(union_associative,axiom,
    union(X,union(Y,Z)) = union(union(X,Y),Z) ).

cnf(union_intersection_absorbtion,axiom,
    union(intersection(X,Y),Y) = Y ).

cnf(intersection_union_absorbtion,axiom,
    intersection(union(X,Y),Y) = Y ).

cnf(multiply_union1,axiom,
    multiply(X,union(Y,Z)) = union(multiply(X,Y),multiply(X,Z)) ).

cnf(multiply_intersection1,axiom,
    multiply(X,intersection(Y,Z)) = intersection(multiply(X,Y),multiply(X,Z)) ).

cnf(multiply_union2,axiom,
    multiply(union(Y,Z),X) = union(multiply(Y,X),multiply(Z,X)) ).

cnf(multiply_intersection2,axiom,
    multiply(intersection(Y,Z),X) = intersection(multiply(Y,X),multiply(Z,X)) ).

cnf(positive_part,axiom,
    positive_part(X) = union(X,identity) ).

cnf(negative_part,axiom,
    negative_part(X) = intersection(X,identity) ).

cnf(prove_product,negated_conjecture,
    multiply(positive_part(a),negative_part(a)) != a ).

%--------------------------------------------------------------------------
