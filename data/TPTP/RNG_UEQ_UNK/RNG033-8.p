%--------------------------------------------------------------------------
% File     : RNG033-8 : TPTP v9.2.1. Bugfixed v2.3.0.
% Domain   : Ring Theory (Alternative)
% Problem  : A fairly complex equation with associators
% Version  : [Ste87] (equality) axioms : Augmented.
% English  : assr(X.Y,Z,W)+assr(X,Y,comm(Z,W)) = X.assr(Y,Z,W)+assr(X,Z,W).Y

% Refs     : [Ste87] Stevens (1987), Some Experiments in Nonassociative Rin
% Source   : [TPTP]
% Names    :

% Status   : Unknown
% Rating   : 1.00 v2.3.0
% Syntax   : Number of clauses     :   17 (  17 unt;   0 nHn;   1 RR)
%            Number of literals    :   17 (  17 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   10 (  10 usr;   5 con; 0-3 aty)
%            Number of variables   :   30 (   2 sgn)
% SPC      : CNF_UNK_RFO_PEQ_UEQ

% Comments : This includes the right Moufang identity, which [Ste87]
%            suggests in a useful lemma for this problem.
% Bugfixes : v2.3.0 - Clause right_moufang fixed.
%--------------------------------------------------------------------------
%----Include nonassociative ring axioms
include('Axioms/RNG003-0.ax').
%--------------------------------------------------------------------------
%----Right Moufang
cnf(right_moufang,hypothesis,
    multiply(Z,multiply(X,multiply(Y,X))) = multiply(multiply(multiply(Z,X),Y),X) ).

cnf(prove_challenge,negated_conjecture,
    add(associator(multiply(x,y),z,w),associator(x,y,commutator(z,w))) != add(multiply(x,associator(y,z,w)),multiply(associator(x,z,w),y)) ).

%--------------------------------------------------------------------------
