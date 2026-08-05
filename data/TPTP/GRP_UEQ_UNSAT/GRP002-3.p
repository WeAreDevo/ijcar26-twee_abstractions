%--------------------------------------------------------------------------
% File     : GRP002-3 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Group Theory
% Problem  : Commutator equals identity in groups of order 3
% Version  : [Ove90] (equality) axioms.
% English  : In a group, if (for all x) the cube of x is the identity
%            (i.e. a group of order 3), then the equation [[x,y],y]=
%            identity holds, where [x,y] is the product of x, y, the
%            inverse of x and the inverse of y (i.e. the commutator
%            of x and y).

% Refs     : [Ove93] Overbeek (1993), The CADE-11 Competitions: A Personal
%          : [LM93]  Lusk & McCune (1993), Uniform Strategies: The CADE-11
%          : [Zha93] Zhang (1993), Automated Proofs of Equality Problems in
%          : [Ove90] Overbeek (1990), ATP competition announced at CADE-10
%          : [MOW76] McCharen et al. (1976), Problems and Experiments for a
% Source   : [Ove90]
% Names    : CADE-11 Competition Eq-1 [Ove90]
%          : THEOREM EQ-1 [LM93]
%          : PROBLEM 1 [Zha93]
%          : comm.in [OTTER]

% Status   : Unsatisfiable
% Rating   : 0.00 v9.1.0, 0.05 v8.2.0, 0.12 v8.1.0, 0.15 v7.5.0, 0.12 v7.4.0, 0.22 v7.3.0, 0.11 v7.1.0, 0.00 v7.0.0, 0.11 v6.4.0, 0.16 v6.3.0, 0.12 v6.2.0, 0.14 v6.1.0, 0.12 v6.0.0, 0.29 v5.5.0, 0.32 v5.4.0, 0.13 v5.3.0, 0.08 v5.2.0, 0.14 v5.1.0, 0.07 v4.1.0, 0.09 v4.0.1, 0.07 v4.0.0, 0.08 v3.7.0, 0.11 v3.4.0, 0.12 v3.3.0, 0.00 v3.1.0, 0.11 v2.7.0, 0.00 v2.2.1, 0.33 v2.2.0, 0.43 v2.1.0, 0.25 v2.0.0
% Syntax   : Number of clauses     :    6 (   6 unt;   0 nHn;   1 RR)
%            Number of literals    :    6 (   6 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   3 con; 0-2 aty)
%            Number of variables   :    8 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Uses an explicit formulation of the commutator.
%          : Same axioms as [MOW76] (equality) axioms.
%--------------------------------------------------------------------------
%----Include group theory axioms
include('Axioms/GRP004-0.ax').
%--------------------------------------------------------------------------
%----Definition of the commutator
cnf(commutator,axiom,
    commutator(X,Y) = multiply(X,multiply(Y,multiply(inverse(X),inverse(Y)))) ).

cnf(x_cubed_is_identity,hypothesis,
    multiply(X,multiply(X,X)) = identity ).

cnf(prove_commutator,negated_conjecture,
    commutator(commutator(a,b),b) != identity ).

%--------------------------------------------------------------------------
