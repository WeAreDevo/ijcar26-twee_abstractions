%--------------------------------------------------------------------------
% File     : GRP203-1 : TPTP v9.2.1. Released v2.2.0.
% Domain   : Group Theory (Loops)
% Problem  : Left identity, left inverse, Moufang-3 => Moufang-2
% Version  : [MP96] (equality) axioms : Especial.
% English  :

% Refs     : [McC98] McCune (1998), Email to G. Sutcliffe
%          : [MP96]  McCune & Padmanabhan (1996), Automated Deduction in Eq
% Source   : [McC98]
% Names    : MFL-7 [MP96]

% Status   : Unsatisfiable
% Rating   : 0.26 v9.1.0, 0.32 v8.2.0, 0.38 v8.1.0, 0.45 v7.5.0, 0.46 v7.4.0, 0.52 v7.3.0, 0.47 v7.1.0, 0.39 v7.0.0, 0.32 v6.4.0, 0.37 v6.3.0, 0.35 v6.2.0, 0.36 v6.1.0, 0.44 v6.0.0, 0.57 v5.5.0, 0.47 v5.4.0, 0.33 v5.3.0, 0.25 v5.2.0, 0.29 v5.1.0, 0.27 v5.0.0, 0.21 v4.1.0, 0.27 v4.0.1, 0.29 v4.0.0, 0.23 v3.7.0, 0.11 v3.4.0, 0.12 v3.3.0, 0.14 v3.2.0, 0.21 v3.1.0, 0.11 v2.7.0, 0.18 v2.6.0, 0.00 v2.2.1
% Syntax   : Number of clauses     :    4 (   4 unt;   0 nHn;   1 RR)
%            Number of literals    :    4 (   4 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   4 con; 0-2 aty)
%            Number of variables   :    5 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Given left identity and left inverse, Moufang-2 and Moufang-3
%            are equivalent, but Moufang-1 is weaker (see MFL-8).
%--------------------------------------------------------------------------
%----Left identity and left inverse:
cnf(left_identity,axiom,
    multiply(identity,X) = X ).

cnf(left_inverse,axiom,
    multiply(left_inverse(X),X) = identity ).

%----Moufang-3:
cnf(moufang3,axiom,
    multiply(multiply(multiply(X,Y),X),Z) = multiply(X,multiply(Y,multiply(X,Z))) ).

%----Denial of Moufang-2:
cnf(prove_moufang2,negated_conjecture,
    multiply(multiply(multiply(a,b),c),b) != multiply(a,multiply(b,multiply(c,b))) ).

%--------------------------------------------------------------------------
