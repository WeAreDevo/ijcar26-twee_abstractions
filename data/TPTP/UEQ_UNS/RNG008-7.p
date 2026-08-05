%--------------------------------------------------------------------------
% File     : RNG008-7 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Ring Theory
% Problem  : Boolean rings are commutative
% Version  : [LW91] (equality) axioms.
% English  : Given a ring in which for all x, x * x = x, prove that for
%            all x and y, x * y = y * x.

% Refs     : [LO85]  Lusk & Overbeek (1985), Reasoning about Equality
%          : [Wos88] Wos (1988), Automated Reasoning - 33 Basic Research Pr
%          : [LW91]  Lusk & Wos (1991), Benchmark Problems in Which Equalit
% Source   : [LW91]
% Names    : Problem 3 [LO85]
%          : Test Problem 8 [Wos88]
%          : Boolean Rings [Wos88]
%          : RT1 [LW91]

% Status   : Unsatisfiable
% Rating   : 0.04 v9.1.0, 0.09 v8.2.0, 0.08 v8.1.0, 0.15 v7.5.0, 0.17 v7.4.0, 0.26 v7.3.0, 0.21 v7.1.0, 0.11 v6.4.0, 0.16 v6.3.0, 0.12 v6.2.0, 0.14 v6.1.0, 0.12 v6.0.0, 0.29 v5.5.0, 0.37 v5.4.0, 0.20 v5.3.0, 0.08 v5.2.0, 0.14 v5.1.0, 0.20 v5.0.0, 0.14 v4.1.0, 0.09 v4.0.1, 0.14 v4.0.0, 0.15 v3.7.0, 0.00 v3.3.0, 0.07 v3.1.0, 0.11 v2.7.0, 0.00 v2.2.1, 0.22 v2.2.0, 0.29 v2.1.0, 0.25 v2.0.0
% Syntax   : Number of clauses     :   12 (  12 unt;   0 nHn;   2 RR)
%            Number of literals    :   12 (  12 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   1 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   4 con; 0-2 aty)
%            Number of variables   :   19 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : This is very similar to ring_x2.in [OTTER].
%--------------------------------------------------------------------------
%----Include ring theory axioms
include('Axioms/RNG005-0.ax').
%--------------------------------------------------------------------------
cnf(boolean_ring,hypothesis,
    multiply(X,X) = X ).

cnf(a_times_b_is_c,negated_conjecture,
    multiply(a,b) = c ).

cnf(prove_commutativity,negated_conjecture,
    multiply(b,a) != c ).

%--------------------------------------------------------------------------
