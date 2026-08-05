%--------------------------------------------------------------------------
% File     : RNG008-4 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Ring Theory
% Problem  : Boolean rings are commutative
% Version  : [PS81] (equality) axioms.
%            Theorem formulation : Equality.
% English  : Given a ring in which for all x, x * x = x, prove that for
%            all x and y, x * y = y * x.

% Refs     : [MOW76] McCharen et al. (1976), Problems and Experiments for a
%          : [PS81]  Peterson & Stickel (1981), Complete Sets of Reductions
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.00 v9.1.0, 0.05 v8.2.0, 0.04 v8.1.0, 0.10 v7.5.0, 0.12 v7.4.0, 0.17 v7.3.0, 0.16 v7.1.0, 0.06 v7.0.0, 0.11 v6.4.0, 0.16 v6.3.0, 0.12 v6.2.0, 0.14 v6.1.0, 0.12 v6.0.0, 0.29 v5.5.0, 0.26 v5.4.0, 0.07 v5.3.0, 0.08 v5.2.0, 0.14 v5.1.0, 0.13 v5.0.0, 0.07 v4.1.0, 0.00 v4.0.1, 0.07 v4.0.0, 0.08 v3.7.0, 0.00 v3.3.0, 0.07 v3.1.0, 0.11 v2.7.0, 0.00 v2.2.1, 0.22 v2.2.0, 0.29 v2.1.0, 0.25 v2.0.0
% Syntax   : Number of clauses     :   17 (  17 unt;   0 nHn;   3 RR)
%            Number of literals    :   17 (  17 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   4 con; 0-2 aty)
%            Number of variables   :   26 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Include ring theory axioms
include('Axioms/RNG002-0.ax').
%--------------------------------------------------------------------------
cnf(boolean_ring,hypothesis,
    multiply(X,X) = X ).

cnf(a_times_b_is_c,negated_conjecture,
    multiply(a,b) = c ).

cnf(prove_commutativity,negated_conjecture,
    multiply(b,a) != c ).

%--------------------------------------------------------------------------
