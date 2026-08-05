%--------------------------------------------------------------------------
% File     : LCL109-2 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Logic Calculi (Many valued sentential)
% Problem  : MV-4 depends on the Meredith system
% Version  : [Ove90] axioms.
%            Theorem formulation : Wajsberg algebra formulation.
% English  : An axiomatisation of the many valued sentential calculus
%            is {MV-1,MV-2,MV-3,MV-5} by Meredith. Wajsberg provided
%            a different axiomatisation. Show that MV-4 depends on the
%            Wajsberg system.

% Refs     : [Ove90] Overbeek (1990), ATP competition announced at CADE-10
%          : [LM92]  Lusk & McCune (1992), Experiments with ROO, a Parallel
%          : [LW92]  Lusk & Wos (1992), Benchmark Problems in Which Equalit
%          : [Ove93] Overbeek (1993), The CADE-11 Competitions: A Personal
%          : [LM93]  Lusk & McCune (1993), Uniform Strategies: The CADE-11
%          : [Zha93] Zhang (1993), Automated Proofs of Equality Problems in
% Source   : [Ove90]
% Names    : CADE-11 Competition Eq-5 [Ove90]
%          : Luka-5 [LM92]
%          : MV4 [LW92]
%          : THEOREM EQ-5 [LM93]
%          : PROBLEM 5 [Zha93]

% Status   : Unsatisfiable
% Rating   : 0.26 v9.1.0, 0.32 v9.0.0, 0.36 v8.2.0, 0.46 v8.1.0, 0.55 v7.5.0, 0.54 v7.4.0, 0.61 v7.3.0, 0.53 v7.1.0, 0.44 v7.0.0, 0.37 v6.4.0, 0.47 v6.2.0, 0.57 v6.1.0, 0.62 v6.0.0, 0.71 v5.5.0, 0.68 v5.4.0, 0.53 v5.3.0, 0.50 v5.1.0, 0.53 v5.0.0, 0.50 v4.1.0, 0.45 v4.0.1, 0.50 v4.0.0, 0.38 v3.7.0, 0.22 v3.4.0, 0.25 v3.3.0, 0.29 v3.1.0, 0.22 v2.7.0, 0.27 v2.6.0, 0.17 v2.5.0, 0.00 v2.4.0, 0.33 v2.2.1, 0.56 v2.2.0, 0.71 v2.1.0, 1.00 v2.0.0
% Syntax   : Number of clauses     :    5 (   5 unt;   0 nHn;   1 RR)
%            Number of literals    :    5 (   5 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   3 con; 0-2 aty)
%            Number of variables   :    8 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Include Wajsberg algebra axioms
include('Axioms/LCL001-0.ax').
%--------------------------------------------------------------------------
cnf(prove_wajsberg_mv_4,negated_conjecture,
    implies(implies(implies(a,b),implies(b,a)),implies(b,a)) != truth ).

%--------------------------------------------------------------------------
