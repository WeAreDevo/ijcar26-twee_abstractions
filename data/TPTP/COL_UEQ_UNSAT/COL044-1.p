%--------------------------------------------------------------------------
% File     : COL044-1 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Combinatory Logic
% Problem  : Strong fixed point for B and N
% Version  : [WM88] (equality) axioms.
% English  : The strong fixed point property holds for the set
%            P consisting of the combinators B and N, where ((Bx)y)z
%            = x(yz), ((Nx)y)z = ((xz)y)z.

% Refs     : [Smu85] Smullyan (1978), To Mock a Mocking Bird and Other Logi
%          : [MW87]  McCune & Wos (1987), A Case Study in Automated Theorem
%          : [WM88]  Wos & McCune (1988), Challenge Problems Focusing on Eq
%          : [MW88]  McCune & Wos (1988), Some Fixed Point Problems in Comb
%          : [LW92]  Lusk & Wos (1992), Benchmark Problems in Which Equalit
%          : [Wos93] Wos (1993), The Kernel Strategy and Its Use for the St
% Source   : [MW88]
% Names    : - [MW88]
%          : CL3 [LW92]
%          : Question 5 [Wos93]

% Status   : Unsatisfiable
% Rating   : 0.22 v9.1.0, 0.27 v8.2.0, 0.29 v8.1.0, 0.35 v7.5.0, 0.33 v7.4.0, 0.39 v7.3.0, 0.37 v7.1.0, 0.28 v7.0.0, 0.26 v6.4.0, 0.32 v6.3.0, 0.29 v6.1.0, 0.31 v6.0.0, 0.38 v5.5.0, 0.32 v5.4.0, 0.33 v5.3.0, 0.42 v5.2.0, 0.36 v5.1.0, 0.47 v5.0.0, 0.43 v4.1.0, 0.36 v4.0.1, 0.43 v4.0.0, 0.46 v3.7.0, 0.22 v3.4.0, 0.25 v3.3.0, 0.29 v3.2.0, 0.21 v3.1.0, 0.22 v2.7.0, 0.18 v2.6.0, 0.33 v2.5.0, 0.00 v2.2.1, 0.11 v2.2.0, 0.00 v2.1.0, 0.25 v2.0.0
% Syntax   : Number of clauses     :    3 (   3 unt;   0 nHn;   1 RR)
%            Number of literals    :    3 (   3 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    4 (   4 usr;   2 con; 0-2 aty)
%            Number of variables   :    7 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
cnf(b_definition,axiom,
    apply(apply(apply(b,X),Y),Z) = apply(X,apply(Y,Z)) ).

cnf(n_definition,axiom,
    apply(apply(apply(n,X),Y),Z) = apply(apply(apply(X,Z),Y),Z) ).

cnf(prove_fixed_point,negated_conjecture,
    apply(Y,f(Y)) != apply(f(Y),apply(Y,f(Y))) ).

%--------------------------------------------------------------------------
