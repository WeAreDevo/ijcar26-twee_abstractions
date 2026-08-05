%--------------------------------------------------------------------------
% File     : BOO025-1 : TPTP v9.2.1. Released v2.2.0.
% Domain   : Boolean Algebra
% Problem  : Half of Padmanabhan's 6-basis with Pixley, part 3.
% Version  : [MP96] (equality) axioms : Especial.
% English  : Part 3 (of 3) of the proof that half of Padmanaban's self-dual
%            independent 6-basis for Boolean Algebra, together with a Pixley
%            polynomial, is a basis for Boolean algebra.

% Refs     : [McC98] McCune (1998), Email to G. Sutcliffe
%          : [MP96]  McCune & Padmanabhan (1996), Automated Deduction in Eq
% Source   : [McC98]
% Names    : DUAL-BA-2-c [MP96]

% Status   : Unsatisfiable
% Rating   : 0.09 v9.1.0, 0.14 v8.2.0, 0.17 v8.1.0, 0.20 v7.5.0, 0.21 v7.4.0, 0.22 v7.3.0, 0.21 v7.1.0, 0.11 v7.0.0, 0.16 v6.4.0, 0.21 v6.3.0, 0.24 v6.2.0, 0.29 v6.1.0, 0.31 v6.0.0, 0.43 v5.5.0, 0.42 v5.4.0, 0.27 v5.3.0, 0.17 v5.2.0, 0.21 v5.1.0, 0.27 v5.0.0, 0.21 v4.1.0, 0.18 v4.0.1, 0.21 v4.0.0, 0.23 v3.7.0, 0.11 v3.4.0, 0.12 v3.3.0, 0.14 v3.2.0, 0.07 v3.1.0, 0.11 v2.7.0, 0.00 v2.2.1
% Syntax   : Number of clauses     :    8 (   8 unt;   0 nHn;   1 RR)
%            Number of literals    :    8 (   8 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   3 con; 0-3 aty)
%            Number of variables   :   15 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Half of Padmanabhan's self-dual independent 6-basis for Boolean Algebra:
cnf(multiply_add,axiom,
    multiply(add(X,Y),Y) = Y ).

cnf(multiply_add_property,axiom,
    multiply(X,add(Y,Z)) = add(multiply(Y,X),multiply(Z,X)) ).

cnf(additive_inverse,axiom,
    add(X,inverse(X)) = n1 ).

%----pixley(X,Y,Z) is a Pixley polynomial:
cnf(pixley_defn,axiom,
    pixley(X,Y,Z) = add(multiply(X,inverse(Y)),add(multiply(X,Z),multiply(inverse(Y),Z))) ).

cnf(pixley1,axiom,
    pixley(X,X,Y) = Y ).

cnf(pixley2,axiom,
    pixley(X,Y,Y) = X ).

cnf(pixley3,axiom,
    pixley(X,Y,X) = X ).

%----Denial of conclusion:
cnf(prove_equal_identity,negated_conjecture,
    multiply(b,inverse(b)) != multiply(a,inverse(a)) ).

%--------------------------------------------------------------------------
