%--------------------------------------------------------------------------
% File     : RNG036-7 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Ring Theory
% Problem  : If X*X*X*X*X = X then the ring is commutative
% Version  : [LW91] (equality) axioms.
% English  : Given a ring in which for all x, x * x * x * x * x = x, prove
%            that for all x and y, x * y = y * x.

% Refs     : [LW91]  Lusk & Wos (1991), Benchmark Problems in Which Equalit
% Source   : [LW91]
% Names    : RT4 [LW91]

% Status   : Unknown
% Rating   : 1.00 v2.0.0
% Syntax   : Number of clauses     :   12 (  12 unt;   0 nHn;   2 RR)
%            Number of literals    :   12 (  12 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   4 con; 0-2 aty)
%            Number of variables   :   19 (   0 sgn)
% SPC      : CNF_UNK_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Include ring theory axioms
include('Axioms/RNG005-0.ax').
%--------------------------------------------------------------------------
cnf(x_fifthed_is_x,hypothesis,
    multiply(X,multiply(X,multiply(X,multiply(X,X)))) = X ).

cnf(a_times_b_is_c,negated_conjecture,
    multiply(a,b) = c ).

cnf(prove_commutativity,negated_conjecture,
    multiply(b,a) != c ).

%--------------------------------------------------------------------------
