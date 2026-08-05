%--------------------------------------------------------------------------
% File     : BOO069-1 : TPTP v9.2.1. Released v2.6.0.
% Domain   : Boolean Algebra (Ternary)
% Problem  : Ternary Boolean Algebra Single axiom is complete, part 3
% Version  : [MP96] (equality) axioms.
% English  :

% Refs     : [McC98] McCune (1998), Email to G. Sutcliffe
%          : [MP96]  McCune & Padmanabhan (1996), Automated Deduction in Eq
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.09 v9.1.0, 0.14 v8.2.0, 0.21 v8.1.0, 0.25 v7.5.0, 0.21 v7.4.0, 0.30 v7.3.0, 0.21 v7.1.0, 0.11 v7.0.0, 0.16 v6.4.0, 0.21 v6.3.0, 0.24 v6.2.0, 0.21 v6.1.0, 0.19 v6.0.0, 0.33 v5.5.0, 0.32 v5.4.0, 0.13 v5.3.0, 0.08 v5.2.0, 0.14 v5.1.0, 0.13 v5.0.0, 0.14 v4.1.0, 0.18 v4.0.1, 0.14 v4.0.0, 0.15 v3.7.0, 0.11 v3.4.0, 0.12 v3.3.0, 0.00 v3.1.0, 0.11 v2.7.0, 0.00 v2.6.0
% Syntax   : Number of clauses     :    2 (   2 unt;   0 nHn;   1 RR)
%            Number of literals    :    2 (   2 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    4 (   4 usr;   2 con; 0-3 aty)
%            Number of variables   :    7 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : A UEQ part of BOO035-1
%--------------------------------------------------------------------------
cnf(single_axiom,axiom,
    multiply(multiply(A,inverse(A),B),inverse(multiply(multiply(C,D,E),F,multiply(C,D,G))),multiply(D,multiply(G,F,E),C)) = B ).

cnf(prove_tba_axioms_3,negated_conjecture,
    multiply(a,b,inverse(b)) != a ).

%--------------------------------------------------------------------------
