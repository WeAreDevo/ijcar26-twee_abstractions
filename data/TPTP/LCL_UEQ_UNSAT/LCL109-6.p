%--------------------------------------------------------------------------
% File     : LCL109-6 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Logic Calculi (Wajsberg Algebra)
% Problem  : A theorem in the lattice structure of Wajsberg algebras
% Version  : [Bon91] (equality) axioms : Augmented.
%            Theorem formulation : Alternative Wajsberg algebras lattice
%            structure.
% English  :

% Refs     : [FRT84] Font et al. (1984), Wajsberg Algebras
%          : [AB90]  Anantharaman & Bonacina (1990), An Application of the
%          : [Bon91] Bonacina (1991), Problems in Lukasiewicz Logic
% Source   : [Bon91]
% Names    : Lattice structure theorem 8 [Bon91]

% Status   : Unsatisfiable
% Rating   : 0.22 v9.1.0, 0.18 v8.2.0, 0.21 v8.1.0, 0.25 v7.5.0, 0.21 v7.4.0, 0.30 v7.3.0, 0.26 v7.1.0, 0.22 v7.0.0, 0.21 v6.4.0, 0.26 v6.3.0, 0.35 v6.2.0, 0.43 v6.1.0, 0.44 v6.0.0, 0.52 v5.5.0, 0.58 v5.4.0, 0.40 v5.3.0, 0.25 v5.2.0, 0.29 v5.1.0, 0.40 v5.0.0, 0.43 v4.1.0, 0.36 v4.0.0, 0.31 v3.7.0, 0.11 v3.4.0, 0.12 v3.3.0, 0.14 v3.1.0, 0.11 v2.7.0, 0.09 v2.6.0, 0.17 v2.5.0, 0.00 v2.4.0, 0.00 v2.2.1, 0.67 v2.2.0, 0.71 v2.1.0, 0.88 v2.0.0
% Syntax   : Number of clauses     :   14 (  14 unt;   0 nHn;   2 RR)
%            Number of literals    :   14 (  14 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   4 con; 0-2 aty)
%            Number of variables   :   19 (   1 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Include Alternative Wajsberg algebra axioms
include('Axioms/LCL002-0.ax').
%--------------------------------------------------------------------------
%----Include some Alternative Wajsberg algebra definitions
% include('Axioms/LCL002-1.ax').
%----Definition that and_star is AC and xor is C
cnf(xor_commutativity,axiom,
    xor(X,Y) = xor(Y,X) ).

cnf(and_star_associativity,axiom,
    and_star(and_star(X,Y),Z) = and_star(X,and_star(Y,Z)) ).

cnf(and_star_commutativity,axiom,
    and_star(X,Y) = and_star(Y,X) ).

%----Definition of false in terms of true
cnf(false_definition,axiom,
    not(truth) = falsehood ).

%----Include the definition of implies in terms of xor and and_star
cnf(implies_definition,axiom,
    implies(X,Y) = xor(truth,and_star(X,xor(truth,Y))) ).

cnf(prove_wajsberg_mv_4,negated_conjecture,
    implies(implies(implies(a,b),implies(b,a)),implies(b,a)) != truth ).

%--------------------------------------------------------------------------
