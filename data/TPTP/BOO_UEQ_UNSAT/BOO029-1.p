%--------------------------------------------------------------------------
% File     : BOO029-1 : TPTP v9.2.1. Released v2.2.0.
% Domain   : Boolean Algebra
% Problem  : Self-dual 2-basis from majority reduction, part 3.
% Version  : [MP96] (equality) axioms : Especial.
% English  : This is part of a proof that there exists an independent
%            self-dual-2-basis for Boolean algebra by majority reduction.

% Refs     : [McC98] McCune (1998), Email to G. Sutcliffe
%          : [MP96]  McCune & Padmanabhan (1996), Automated Deduction in Eq
% Source   : [McC98]
% Names    : DUAL-BA-5-c [MP96]

% Status   : Unsatisfiable
% Rating   : 0.09 v9.1.0, 0.14 v8.2.0, 0.08 v8.1.0, 0.10 v7.5.0, 0.08 v7.4.0, 0.17 v7.3.0, 0.11 v7.1.0, 0.06 v7.0.0, 0.05 v6.3.0, 0.06 v6.2.0, 0.07 v6.1.0, 0.12 v6.0.0, 0.29 v5.5.0, 0.26 v5.4.0, 0.07 v5.3.0, 0.00 v5.2.0, 0.07 v5.1.0, 0.13 v5.0.0, 0.07 v4.1.0, 0.09 v4.0.1, 0.07 v4.0.0, 0.08 v3.7.0, 0.00 v2.2.1
% Syntax   : Number of clauses     :   11 (  11 unt;   0 nHn;   1 RR)
%            Number of literals    :   11 (  11 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   2 con; 0-2 aty)
%            Number of variables   :   26 (   8 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Properties L1, L3, and B1 of Boolean Algebra:
cnf(l1,axiom,
    add(X,multiply(Y,multiply(X,Z))) = X ).

cnf(l3,axiom,
    add(add(multiply(X,Y),multiply(Y,Z)),Y) = Y ).

cnf(b1,axiom,
    multiply(add(X,Y),add(X,inverse(Y))) = X ).

%----The corresponding dual properties L2, L4, and B2.
cnf(l2,axiom,
    multiply(X,add(Y,add(X,Z))) = X ).

cnf(l4,axiom,
    multiply(multiply(add(X,Y),add(Y,Z)),Y) = Y ).

cnf(b2,axiom,
    add(multiply(X,Y),multiply(X,inverse(Y))) = X ).

%----Associativity and Commutativity of both operations:
cnf(commutativity_of_add,axiom,
    add(X,Y) = add(Y,X) ).

cnf(commutativity_of_multiply,axiom,
    multiply(X,Y) = multiply(Y,X) ).

cnf(associativity_of_add,axiom,
    add(add(X,Y),Z) = add(X,add(Y,Z)) ).

cnf(associativity_of_multiply,axiom,
    multiply(multiply(X,Y),Z) = multiply(X,multiply(Y,Z)) ).

%----Denial of conclusion:
cnf(prove_equal_inverse,negated_conjecture,
    add(b,inverse(b)) != add(a,inverse(a)) ).

%--------------------------------------------------------------------------
