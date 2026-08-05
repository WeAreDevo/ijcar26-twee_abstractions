%--------------------------------------------------------------------------
% File     : BOO002-2 : TPTP v9.2.1. Released v1.1.0.
% Domain   : Boolean Algebra (Ternary)
% Problem  : In B3 algebra, X * X^-1 * Y = Y
% Version  : [OTTER] (equality) axioms : Reduced & Augmented > Incomplete.
% English  :

% Refs     : [Wos88] Wos (1988), Automated Reasoning - 33 Basic Research Pr
% Source   : [Wos88]
% Names    : Test Problem 13 [Wos88]
%          : Lemma for Axiom Independence [Wos88]

% Status   : Unsatisfiable
% Rating   : 0.04 v9.1.0, 0.09 v8.2.0, 0.08 v8.1.0, 0.15 v7.5.0, 0.08 v7.4.0, 0.17 v7.3.0, 0.11 v7.1.0, 0.06 v7.0.0, 0.05 v6.3.0, 0.06 v6.2.0, 0.07 v6.1.0, 0.25 v6.0.0, 0.38 v5.5.0, 0.37 v5.4.0, 0.20 v5.3.0, 0.08 v5.2.0, 0.14 v5.1.0, 0.20 v5.0.0, 0.14 v4.1.0, 0.00 v2.7.0, 0.09 v2.6.0, 0.00 v2.2.1, 0.33 v2.2.0, 0.43 v2.1.0, 0.38 v2.0.0
% Syntax   : Number of clauses     :    6 (   6 unt;   0 nHn;   1 RR)
%            Number of literals    :    6 (   6 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   1 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    4 (   4 usr;   2 con; 0-3 aty)
%            Number of variables   :   13 (   3 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : This version contains an extra lemma
%--------------------------------------------------------------------------
%----Don't include ternary Boolean algebra axioms, as one is omitted
%include('axioms/BOO001-0.ax').
%--------------------------------------------------------------------------
cnf(associativity,axiom,
    multiply(multiply(V,W,X),Y,multiply(V,W,Z)) = multiply(V,W,multiply(X,Y,Z)) ).

cnf(ternary_multiply_1,axiom,
    multiply(Y,X,X) = X ).

cnf(ternary_multiply_2,axiom,
    multiply(X,X,Y) = X ).

cnf(left_inverse,axiom,
    multiply(inverse(Y),Y,X) = X ).

%----This axiom is omitted
% input_clause(right_inverse,axiom,
%     [++equal(multiply(X,Y,inverse(Y)),X)]).

cnf(extra_lemma,axiom,
    multiply(X,Y,X) = X ).

cnf(prove_equation,negated_conjecture,
    multiply(a,inverse(a),b) != b ).

%--------------------------------------------------------------------------
