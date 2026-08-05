%--------------------------------------------------------------------------
% File     : COL070-1 : TPTP v9.2.1. Released v1.2.0.
% Domain   : Combinatory Logic
% Problem  : Weak fixed point for B and N1
% Version  : [WM88] (equality) axioms.
% English  : The weak fixed point property holds for the set P consisting
%            of the combinators B and N1, where N1xyz = xyyz, ((Bx)y)z
%            = x(yz).

% Refs     : [WM88]  Wos & McCune (1988), Challenge Problems Focusing on Eq
%          : [Wos93] Wos (1993), The Kernel Strategy and Its Use for the St
%          : [Zha94] Zhang (1994), Solution to Another Open Question in Com
% Source   : [Wos93]
% Names    : Question 12 [Wos93]

% Status   : Unsatisfiable
% Rating   : 0.13 v9.1.0, 0.18 v8.2.0, 0.21 v8.1.0, 0.25 v7.4.0, 0.30 v7.3.0, 0.26 v7.1.0, 0.17 v7.0.0, 0.16 v6.4.0, 0.26 v6.3.0, 0.24 v6.2.0, 0.21 v6.1.0, 0.06 v6.0.0, 0.19 v5.5.0, 0.11 v5.4.0, 0.07 v5.3.0, 0.08 v5.2.0, 0.07 v5.1.0, 0.20 v5.0.0, 0.21 v4.1.0, 0.18 v4.0.1, 0.29 v4.0.0, 0.31 v3.7.0, 0.11 v3.4.0, 0.12 v3.3.0, 0.07 v3.1.0, 0.11 v2.7.0, 0.00 v2.0.0
% Syntax   : Number of clauses     :    3 (   3 unt;   0 nHn;   1 RR)
%            Number of literals    :    3 (   3 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    4 (   4 usr;   3 con; 0-2 aty)
%            Number of variables   :    7 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
cnf(n1_definition,axiom,
    apply(apply(apply(n1,X),Y),Z) = apply(apply(apply(X,Y),Y),Z) ).

cnf(b_definition,axiom,
    apply(apply(apply(b,X),Y),Z) = apply(X,apply(Y,Z)) ).

cnf(prove_fixed_point,negated_conjecture,
    Y != apply(combinator,Y) ).

%--------------------------------------------------------------------------
