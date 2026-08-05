%--------------------------------------------------------------------------
% File     : GRP010-4 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Group Theory
% Problem  : Inverse is a symmetric relationship
% Version  : [Wos65] (equality) axioms : Incomplete.
% English  : If a is an inverse of b then b is an inverse of a.

% Refs     : [Wos65] Wos (1965), Unpublished Note
%          : [Pel86] Pelletier (1986), Seventy-five Problems for Testing Au
% Source   : [Pel86]
% Names    : Pelletier 64 [Pel86]

% Status   : Unsatisfiable
% Rating   : 0.04 v9.1.0, 0.00 v8.1.0, 0.05 v7.5.0, 0.04 v7.4.0, 0.13 v7.3.0, 0.11 v7.1.0, 0.06 v7.0.0, 0.05 v6.3.0, 0.06 v6.2.0, 0.07 v6.1.0, 0.06 v6.0.0, 0.14 v5.5.0, 0.11 v5.4.0, 0.00 v5.1.0, 0.07 v4.1.0, 0.09 v4.0.1, 0.07 v4.0.0, 0.08 v3.7.0, 0.00 v2.1.0, 0.13 v2.0.0
% Syntax   : Number of clauses     :    5 (   5 unt;   0 nHn;   2 RR)
%            Number of literals    :    5 (   5 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   1 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   3 con; 0-2 aty)
%            Number of variables   :    5 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : [Pel86] says "... problems, published I think, by Larry Wos
%            (but I cannot locate where)."
%--------------------------------------------------------------------------
%----The operation '*' is associative
cnf(associativity,axiom,
    multiply(multiply(X,Y),Z) = multiply(X,multiply(Y,Z)) ).

%----There exists an identity element 'e' defined below.
cnf(left_identity,axiom,
    multiply(identity,X) = X ).

cnf(left_inverse,axiom,
    multiply(inverse(X),X) = identity ).

cnf(c_times_b_is_e,hypothesis,
    multiply(c,b) = identity ).

cnf(prove_b_times_c_is_e,negated_conjecture,
    multiply(b,c) != identity ).

%--------------------------------------------------------------------------
