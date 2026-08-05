%--------------------------------------------------------------------------
% File     : COL049-1 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Combinatory Logic
% Problem  : Strong fixed point for B, W, and M
% Version  : [WM88] (equality) axioms.
% English  : The strong fixed point property holds for the set
%            P consisting of the combinators B, W, and M, where ((Bx)y)z
%            = x(yz), (Wx)y = (xy)y, Mx = xx.

% Refs     : [Smu85] Smullyan (1978), To Mock a Mocking Bird and Other Logi
%          : [MW87]  McCune & Wos (1987), A Case Study in Automated Theorem
%          : [WM88]  Wos & McCune (1988), Challenge Problems Focusing on Eq
%          : [Ove90] Overbeek (1990), ATP competition announced at CADE-10
%          : [LW92]  Lusk & Wos (1992), Benchmark Problems in Which Equalit
%          : [Wos93] Wos (1993), The Kernel Strategy and Its Use for the St
%          : [Ove93] Overbeek (1993), The CADE-11 Competitions: A Personal
%          : [LM93]  Lusk & McCune (1993), Uniform Strategies: The CADE-11
%          : [Zha93] Zhang (1993), Automated Proofs of Equality Problems in
% Source   : [Ove90]
% Names    : Problem 2 [WM88]
%          : CADE-11 Competition Eq-6 [Ove90]
%          : CL1 [LW92]
%          : THEOREM EQ-6 [LM93]
%          : Question 2 [Wos93]
%          : PROBLEM 6 [Zha93]

% Status   : Unsatisfiable
% Rating   : 0.30 v9.1.0, 0.36 v8.2.0, 0.42 v8.1.0, 0.40 v7.5.0, 0.46 v7.4.0, 0.52 v7.3.0, 0.47 v7.2.0, 0.53 v7.1.0, 0.44 v7.0.0, 0.42 v6.3.0, 0.41 v6.2.0, 0.43 v6.1.0, 0.44 v6.0.0, 0.57 v5.5.0, 0.53 v5.3.0, 0.50 v5.2.0, 0.43 v5.1.0, 0.47 v5.0.0, 0.50 v4.1.0, 0.36 v4.0.1, 0.43 v4.0.0, 0.46 v3.7.0, 0.22 v3.4.0, 0.25 v3.3.0, 0.29 v3.1.0, 0.44 v2.7.0, 0.27 v2.6.0, 0.17 v2.5.0, 0.25 v2.4.0, 0.00 v2.2.1, 0.22 v2.2.0, 0.14 v2.1.0, 0.62 v2.0.0
% Syntax   : Number of clauses     :    4 (   4 unt;   0 nHn;   1 RR)
%            Number of literals    :    4 (   4 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   3 con; 0-2 aty)
%            Number of variables   :    7 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
cnf(b_definition,axiom,
    apply(apply(apply(b,X),Y),Z) = apply(X,apply(Y,Z)) ).

cnf(w_definition,axiom,
    apply(apply(w,X),Y) = apply(apply(X,Y),Y) ).

cnf(m_definition,axiom,
    apply(m,X) = apply(X,X) ).

cnf(prove_strong_fixed_point,negated_conjecture,
    apply(Y,f(Y)) != apply(f(Y),apply(Y,f(Y))) ).

%--------------------------------------------------------------------------
