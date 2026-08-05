%--------------------------------------------------------------------------
% File     : GRP002-2 : TPTP v9.2.1. Bugfixed v1.2.1.
% Domain   : Group Theory
% Problem  : Commutator equals identity in groups of order 3
% Version  : [MOW76] (equality) axioms.
% English  : In a group, if (for all x) the cube of x is the identity
%            (i.e. a group of order 3), then the equation [[x,y],y]=
%            identity holds, where [x,y] is the product of x, y, the
%            inverse of x and the inverse of y (i.e. the commutator
%            of x and y).

% Refs     : [MOW76] McCharen et al. (1976), Problems and Experiments for a
% Source   : [ANL]
% Names    : commutator.ver2.in [ANL]

% Status   : Unsatisfiable
% Rating   : 0.00 v9.1.0, 0.05 v8.2.0, 0.12 v8.1.0, 0.15 v7.5.0, 0.12 v7.4.0, 0.22 v7.3.0, 0.11 v7.1.0, 0.00 v7.0.0, 0.05 v6.4.0, 0.11 v6.3.0, 0.12 v6.2.0, 0.14 v6.1.0, 0.06 v6.0.0, 0.29 v5.5.0, 0.21 v5.4.0, 0.00 v5.2.0, 0.07 v5.1.0, 0.13 v5.0.0, 0.14 v4.1.0, 0.18 v4.0.1, 0.14 v4.0.0, 0.15 v3.7.0, 0.11 v3.4.0, 0.12 v3.3.0, 0.00 v2.2.1, 0.22 v2.2.0, 0.29 v2.1.0, 0.29 v2.0.0
% Syntax   : Number of clauses     :   12 (  12 unt;   0 nHn;   6 RR)
%            Number of literals    :   12 (  12 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   10 (  10 usr;   8 con; 0-2 aty)
%            Number of variables   :    8 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
% Bugfixes : v1.2.1 - Clause x_cubed_is_identity fixed.
%--------------------------------------------------------------------------
include('Axioms/GRP004-0.ax').
%--------------------------------------------------------------------------
%----Redundant two axioms, but established in standard axiomatizations.
cnf(right_identity,axiom,
    multiply(X,identity) = X ).

cnf(right_inverse,axiom,
    multiply(X,inverse(X)) = identity ).

%----This hypothesis is omitted in the ANL source version
cnf(x_cubed_is_identity,hypothesis,
    multiply(X,multiply(X,X)) = identity ).

cnf(a_times_b_is_c,negated_conjecture,
    multiply(a,b) = c ).

cnf(c_times_inverse_a_is_d,negated_conjecture,
    multiply(c,inverse(a)) = d ).

cnf(d_times_inverse_b_is_h,negated_conjecture,
    multiply(d,inverse(b)) = h ).

cnf(h_times_b_is_j,negated_conjecture,
    multiply(h,b) = j ).

cnf(j_times_inverse_h_is_k,negated_conjecture,
    multiply(j,inverse(h)) = k ).

cnf(prove_k_times_inverse_b_is_e,negated_conjecture,
    multiply(k,inverse(b)) != identity ).

%--------------------------------------------------------------------------
