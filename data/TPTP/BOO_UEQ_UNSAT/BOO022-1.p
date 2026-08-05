%--------------------------------------------------------------------------
% File     : BOO022-1 : TPTP v9.2.1. Released v2.2.0.
% Domain   : Boolean Algebra
% Problem  : A Basis for Boolean Algebra
% Version  : [MP96] (equality) axioms.
% English  : This theorem starts with a (self-dual independent) 6-basis
%            for Boolean algebra and derives associativity of product.

% Refs     : [McC98] McCune (1998), Email to G. Sutcliffe
%          : [MP96]  McCune & Padmanabhan (1996), Automated Deduction in Eq
% Source   : [McC98]
% Names    : DUAL-BA-1 [MP96]

% Status   : Unsatisfiable
% Rating   : 0.00 v9.1.0, 0.09 v9.0.0, 0.05 v8.2.0, 0.12 v8.1.0, 0.25 v7.5.0, 0.17 v7.4.0, 0.26 v7.1.0, 0.17 v7.0.0, 0.21 v6.4.0, 0.32 v6.3.0, 0.29 v6.1.0, 0.31 v6.0.0, 0.48 v5.5.0, 0.47 v5.4.0, 0.33 v5.2.0, 0.36 v5.1.0, 0.27 v5.0.0, 0.21 v4.1.0, 0.09 v4.0.1, 0.14 v4.0.0, 0.15 v3.7.0, 0.11 v3.4.0, 0.12 v3.3.0, 0.14 v3.2.0, 0.07 v3.1.0, 0.22 v2.7.0, 0.00 v2.2.1
% Syntax   : Number of clauses     :    7 (   7 unt;   0 nHn;   1 RR)
%            Number of literals    :    7 (   7 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   5 con; 0-2 aty)
%            Number of variables   :   12 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : The other part of this problem is to prove commutativity.
%--------------------------------------------------------------------------
%----Boolean Algebra:
cnf(multiply_add,axiom,
    multiply(add(X,Y),Y) = Y ).

cnf(multiply_add_property,axiom,
    multiply(X,add(Y,Z)) = add(multiply(Y,X),multiply(Z,X)) ).

cnf(additive_inverse,axiom,
    add(X,inverse(X)) = n1 ).

cnf(add_multiply,axiom,
    add(multiply(X,Y),Y) = Y ).

cnf(add_multiply_property,axiom,
    add(X,multiply(Y,Z)) = multiply(add(Y,X),add(Z,X)) ).

cnf(multiplicative_inverse,axiom,
    multiply(X,inverse(X)) = n0 ).

%----Denial of conclusion:
cnf(prove_associativity_of_multiply,negated_conjecture,
    multiply(multiply(a,b),c) != multiply(a,multiply(b,c)) ).

%--------------------------------------------------------------------------
