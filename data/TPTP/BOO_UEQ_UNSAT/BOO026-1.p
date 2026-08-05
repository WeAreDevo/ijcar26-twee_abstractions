%--------------------------------------------------------------------------
% File     : BOO026-1 : TPTP v9.2.1. Released v2.2.0.
% Domain   : Boolean Algebra
% Problem  : Absorption from self-dual independent 2-basis
% Version  : [MP96] (eqiality) axioms : Especial.
% English  : This is part of a proof that there exists an independent self-dual
%            2-basis for Boolean Algebra.  You may note that the basis
%            below has more than 2 equations; but don't worry, it can be
%            reduced to 2 (large) equations by Pixley reduction.

% Refs     : [Wos98] Wos (1998), Automating the Search for Elegant Proofs
%          : [McC98] McCune (1998), Email to G. Sutcliffe
%          : [MP96]  McCune & Padmanabhan (1996), Automated Deduction in Eq
% Source   : [McC98]
% Names    : DUAL-BA-3 [MP96]
%          : DUAL-BA-3 [Wos98]

% Status   : Unsatisfiable
% Rating   : 0.13 v9.1.0, 0.23 v9.0.0, 0.18 v8.2.0, 0.21 v8.1.0, 0.20 v7.5.0, 0.25 v7.4.0, 0.30 v7.3.0, 0.32 v7.1.0, 0.22 v7.0.0, 0.32 v6.4.0, 0.42 v6.3.0, 0.47 v6.2.0, 0.50 v6.1.0, 0.31 v6.0.0, 0.48 v5.5.0, 0.47 v5.4.0, 0.27 v5.3.0, 0.17 v5.2.0, 0.21 v5.1.0, 0.20 v5.0.0, 0.21 v4.1.0, 0.09 v4.0.1, 0.14 v4.0.0, 0.23 v3.7.0, 0.11 v3.4.0, 0.12 v3.3.0, 0.07 v3.1.0, 0.11 v2.7.0, 0.00 v2.2.1
% Syntax   : Number of clauses     :   11 (  11 unt;   0 nHn;   1 RR)
%            Number of literals    :   11 (  11 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   4 con; 0-2 aty)
%            Number of variables   :   20 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : The original proof has 816 steps.  Wos later found a 99-step
%            proof.
%--------------------------------------------------------------------------
%----Two Boolean algebra properties and their duals:
cnf(multiply_add_property,axiom,
    multiply(X,add(Y,Z)) = add(multiply(Y,X),multiply(Z,X)) ).

cnf(additive_inverse,axiom,
    add(X,inverse(X)) = n1 ).

cnf(add_multiply_property,axiom,
    add(X,multiply(Y,Z)) = multiply(add(Y,X),add(Z,X)) ).

cnf(multiplicative_inverse,axiom,
    multiply(X,inverse(X)) = n0 ).

%----Expanded Pixley properties and their duals:
cnf(pixley1,axiom,
    add(multiply(X,inverse(X)),add(multiply(X,Y),multiply(inverse(X),Y))) = Y ).

cnf(pixley2,axiom,
    add(multiply(X,inverse(Y)),add(multiply(X,Y),multiply(inverse(Y),Y))) = X ).

cnf(pixley3,axiom,
    add(multiply(X,inverse(Y)),add(multiply(X,X),multiply(inverse(Y),X))) = X ).

cnf(pixley1_dual,axiom,
    multiply(add(X,inverse(X)),multiply(add(X,Y),add(inverse(X),Y))) = Y ).

cnf(pixley2_dual,axiom,
    multiply(add(X,inverse(Y)),multiply(add(X,Y),add(inverse(Y),Y))) = X ).

cnf(pixley3_dual,axiom,
    multiply(add(X,inverse(Y)),multiply(add(X,X),add(inverse(Y),X))) = X ).

%----Denial of the conclusion:
cnf(prove_multiply_add,negated_conjecture,
    multiply(add(a,b),b) != b ).

%--------------------------------------------------------------------------
