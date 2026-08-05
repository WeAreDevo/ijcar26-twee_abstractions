%--------------------------------------------------------------------------
% File     : ROB005-1 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Robbins Algebra
% Problem  : Exists an idempotent element => Boolean
% Version  : [Win90] (equality) axioms.
% English  : If there is an element c such that c+c=c, then the algebra
%            is Boolean.

% Refs     : [HMT71] Henkin et al. (1971), Cylindrical Algebras
%          : [Win90] Winker (1990), Robbins Algebra: Conditions that make a
%          : [Ove90] Overbeek (1990), ATP competition announced at CADE-10
%          : [LW92]  Lusk & Wos (1992), Benchmark Problems in Which Equalit
%          : [Ove93] Overbeek (1993), The CADE-11 Competitions: A Personal
%          : [LM93]  Lusk & McCune (1993), Uniform Strategies: The CADE-11
%          : [Zha93] Zhang (1993), Automated Proofs of Equality Problems in
% Source   : [Ove90]
% Names    : CADE-11 Competition Eq-2 [Ove90]
%          : Lemma 2.4 [Win90]
%          : RA3 [LW92]
%          : THEOREM EQ-2 [LM93]
%          : PROBLEM 2 [Zha93]
%          : robbins.occ.in [OTTER]

% Status   : Unsatisfiable
% Rating   : 0.26 v9.1.0, 0.32 v9.0.0, 0.27 v8.2.0, 0.38 v8.1.0, 0.40 v7.5.0, 0.29 v7.4.0, 0.39 v7.3.0, 0.26 v7.1.0, 0.17 v7.0.0, 0.21 v6.4.0, 0.26 v6.3.0, 0.24 v6.2.0, 0.21 v6.1.0, 0.31 v6.0.0, 0.52 v5.5.0, 0.47 v5.4.0, 0.33 v5.3.0, 0.25 v5.2.0, 0.29 v5.1.0, 0.27 v5.0.0, 0.21 v4.1.0, 0.18 v4.0.1, 0.21 v4.0.0, 0.23 v3.7.0, 0.22 v3.4.0, 0.25 v3.3.0, 0.14 v3.2.0, 0.07 v3.1.0, 0.11 v2.7.0, 0.09 v2.6.0, 0.17 v2.5.0, 0.00 v2.4.0, 0.33 v2.3.0, 0.67 v2.2.1, 0.67 v2.2.0, 0.71 v2.1.0, 0.88 v2.0.0
% Syntax   : Number of clauses     :    5 (   5 unt;   0 nHn;   2 RR)
%            Number of literals    :    5 (   5 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   3 con; 0-2 aty)
%            Number of variables   :    7 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Commutativity, associativity, and Huntington's axiom
%            axiomatize Boolean algebra.
%--------------------------------------------------------------------------
%----Include axioms for Robbins algebra
include('Axioms/ROB001-0.ax').
%--------------------------------------------------------------------------
cnf(idempotence,hypothesis,
    add(c,c) = c ).

cnf(prove_huntingtons_axiom,negated_conjecture,
    add(negate(add(a,negate(b))),negate(add(negate(a),negate(b)))) != b ).

%--------------------------------------------------------------------------
