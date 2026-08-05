%--------------------------------------------------------------------------
% File     : GRP002-4 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Group Theory
% Problem  : Commutator equals identity in groups of order 3
% Version  : [MOW76] (equality) axioms.
%            Theorem formulation : Explicit formulation of the commutator.
% English  : In a group, if (for all x) the cube of x is the identity
%            (i.e. a group of order 3), then the equation [[x,y],y]=
%            identity holds, where [x,y] is the product of x, y, the
%            inverse of x and the inverse of y (i.e. the commutator
%            of x and y).

% Refs     : [MOW76] McCharen et al. (1976), Problems and Experiments for a
%          : [LO85]  Lusk & Overbeek (1985), Reasoning about Equality
%          : [Wos88] Wos (1988), Automated Reasoning - 33 Basic Research Pr
%          : [LW92]  Lusk & Wos (1992), Benchmark Problems in Which Equalit
% Source   : [TPTP]
% Names    : Problem 4 [LO85]
%          : Test Problem 2 [Wos88]
%          : Commutator Theorem [Wos88]
%          : GT3 [LW92]

% Status   : Unsatisfiable
% Rating   : 0.04 v9.1.0, 0.14 v9.0.0, 0.09 v8.2.0, 0.17 v8.1.0, 0.20 v7.5.0, 0.17 v7.4.0, 0.26 v7.3.0, 0.16 v7.1.0, 0.06 v7.0.0, 0.11 v6.4.0, 0.16 v6.3.0, 0.12 v6.2.0, 0.14 v6.1.0, 0.12 v6.0.0, 0.29 v5.5.0, 0.26 v5.4.0, 0.07 v5.3.0, 0.08 v5.2.0, 0.14 v5.1.0, 0.07 v4.1.0, 0.09 v4.0.1, 0.07 v4.0.0, 0.08 v3.7.0, 0.11 v3.4.0, 0.12 v3.3.0, 0.00 v3.1.0, 0.11 v2.7.0, 0.00 v2.2.1, 0.33 v2.2.0, 0.43 v2.1.0, 0.25 v2.0.0
% Syntax   : Number of clauses     :    8 (   8 unt;   0 nHn;   1 RR)
%            Number of literals    :    8 (   8 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   3 con; 0-2 aty)
%            Number of variables   :   10 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Include group theory axioms
include('Axioms/GRP004-0.ax').
%--------------------------------------------------------------------------
%----Redundant two axioms, but used in established axiomatizations.
cnf(right_identity,axiom,
    multiply(X,identity) = X ).

cnf(right_inverse,axiom,
    multiply(X,inverse(X)) = identity ).

%----Definition of the commutator
cnf(commutator,axiom,
    commutator(X,Y) = multiply(X,multiply(Y,multiply(inverse(X),inverse(Y)))) ).

cnf(x_cubed_is_identity,hypothesis,
    multiply(X,multiply(X,X)) = identity ).

cnf(prove_commutator,negated_conjecture,
    commutator(commutator(a,b),b) != identity ).

%--------------------------------------------------------------------------
