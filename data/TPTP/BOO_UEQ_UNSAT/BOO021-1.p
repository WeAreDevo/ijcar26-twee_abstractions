%--------------------------------------------------------------------------
% File     : BOO021-1 : TPTP v9.2.1. Released v2.2.0.
% Domain   : Boolean Algebra
% Problem  : A Basis for Boolean Algebra
% Version  : [MP96] (equality) axioms.
% English  : This theorem starts with a (self-dual independent) basis_
%            for Boolean algebra and derives commutativity of product.

% Refs     : [McC98] McCune (1998), Email to G. Sutcliffe
%          : [MP96]  McCune & Padmanabhan (1996), Automated Deduction in Eq
% Source   : [McC98]
% Names    : DUAL-BA-1 [MP96]

% Status   : Unsatisfiable
% Rating   : 0.04 v9.1.0, 0.00 v7.5.0, 0.04 v7.3.0, 0.05 v7.1.0, 0.06 v7.0.0, 0.05 v6.4.0, 0.11 v6.3.0, 0.12 v6.2.0, 0.14 v6.1.0, 0.06 v6.0.0, 0.10 v5.5.0, 0.16 v5.4.0, 0.13 v5.3.0, 0.08 v5.2.0, 0.07 v5.1.0, 0.20 v5.0.0, 0.14 v4.1.0, 0.09 v4.0.1, 0.14 v4.0.0, 0.15 v3.7.0, 0.00 v3.3.0, 0.07 v3.1.0, 0.11 v2.7.0, 0.00 v2.2.1
% Syntax   : Number of clauses     :    7 (   7 unt;   0 nHn;   1 RR)
%            Number of literals    :    7 (   7 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   4 con; 0-2 aty)
%            Number of variables   :   12 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : The other part of this problem is to prove associativity.
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
cnf(prove_commutativity_of_multiply,negated_conjecture,
    multiply(b,a) != multiply(a,b) ).

%--------------------------------------------------------------------------
