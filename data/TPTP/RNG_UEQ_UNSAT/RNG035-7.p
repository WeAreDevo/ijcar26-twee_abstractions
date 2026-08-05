%--------------------------------------------------------------------------
% File     : RNG035-7 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Ring Theory
% Problem  : If X*X*X*X = X then the ring is commutative
% Version  : [LW91] (equality) axioms.
% English  : Given a ring in which for all x, x * x * x * x = x, prove
%            that for all x and y, x * y = y * x.

% Refs     : [LW91]  Lusk & Wos (1991), Benchmark Problems in Which Equalit
% Source   : [LW91]
% Names    : RT3 [LW91]

% Status   : Unsatisfiable
% Rating   : 0.65 v9.1.0, 0.68 v8.2.0, 0.75 v8.1.0, 0.85 v7.5.0, 0.79 v7.4.0, 0.83 v7.3.0, 0.79 v7.1.0, 0.78 v7.0.0, 0.79 v6.3.0, 0.76 v6.2.0, 0.71 v6.1.0, 0.81 v6.0.0, 0.90 v5.5.0, 0.89 v5.4.0, 0.93 v5.3.0, 0.92 v5.2.0, 0.86 v5.1.0, 0.80 v5.0.0, 0.79 v4.1.0, 0.82 v4.0.1, 0.79 v4.0.0, 0.77 v3.7.0, 0.89 v3.4.0, 0.88 v3.3.0, 0.79 v3.2.0, 0.86 v3.1.0, 0.67 v2.7.0, 0.73 v2.6.0, 0.50 v2.5.0, 0.25 v2.4.0, 0.33 v2.2.1, 1.00 v2.0.0
% Syntax   : Number of clauses     :   12 (  12 unt;   0 nHn;   2 RR)
%            Number of literals    :   12 (  12 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   4 con; 0-2 aty)
%            Number of variables   :   19 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Include ring theory axioms
include('Axioms/RNG005-0.ax').
%--------------------------------------------------------------------------
cnf(x_fourthed_is_x,hypothesis,
    multiply(X,multiply(X,multiply(X,X))) = X ).

cnf(a_times_b_is_c,negated_conjecture,
    multiply(a,b) = c ).

cnf(prove_commutativity,negated_conjecture,
    multiply(b,a) != c ).

%--------------------------------------------------------------------------
