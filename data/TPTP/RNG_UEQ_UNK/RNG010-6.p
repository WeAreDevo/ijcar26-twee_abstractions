%--------------------------------------------------------------------------
% File     : RNG010-6 : TPTP v9.2.1. Bugfixed v2.3.0.
% Domain   : Ring Theory (Right alternative)
% Problem  : Skew symmetry of the auxilliary function
% Version  : [Ste87] (equality) axioms.
% English  : The three Moufang identities imply the skew symmetry
%            of s(W,X,Y,Z) = (W*X,Y,Z) - X*(W,Y,Z) - (X,Y,Z)*W.
%            Recall that skew symmetry means that the function sign
%            changes when any two arguments are swapped. This problem
%            proves the case for swapping the first two arguments.

% Refs     : [Ste87] Stevens (1987), Some Experiments in Nonassociative Rin
% Source   : [TPTP]
% Names    :

% Status   : Unknown
% Rating   : 1.00 v2.3.0
% Syntax   : Number of clauses     :   20 (  20 unt;   0 nHn;   1 RR)
%            Number of literals    :   20 (  20 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   11 (  11 usr;   5 con; 0-4 aty)
%            Number of variables   :   40 (   2 sgn)
% SPC      : CNF_UNK_RFO_PEQ_UEQ

% Comments :
% Bugfixes : v2.3.0 - Clause prove_skew_symmetry fixed.
%          : v2.3.0 - Left alternative law added in.
%          : v2.3.0 - Clauses right_moufang and left_moufang fixed.
%--------------------------------------------------------------------------
%----Include nonassociative ring axioms.
include('Axioms/RNG003-0.ax').
%--------------------------------------------------------------------------
%----Definition of s
cnf(defines_s,axiom,
    s(W,X,Y,Z) = add(add(associator(multiply(W,X),Y,Z),additive_inverse(multiply(X,associator(W,Y,Z)))),additive_inverse(multiply(associator(X,Y,Z),W))) ).

%----Right Moufang
cnf(right_moufang,hypothesis,
    multiply(Z,multiply(X,multiply(Y,X))) = multiply(multiply(multiply(Z,X),Y),X) ).

%----Left Moufang
cnf(left_moufang,hypothesis,
    multiply(multiply(X,multiply(Y,X)),Z) = multiply(X,multiply(Y,multiply(X,Z))) ).

cnf(middle_moufang,hypothesis,
    multiply(multiply(X,Y),multiply(Z,X)) = multiply(multiply(X,multiply(Y,Z)),X) ).

cnf(prove_skew_symmetry,negated_conjecture,
    s(a,b,c,d) != additive_inverse(s(b,a,c,d)) ).

%--------------------------------------------------------------------------
