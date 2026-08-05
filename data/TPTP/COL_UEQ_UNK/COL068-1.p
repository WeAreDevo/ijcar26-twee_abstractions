%--------------------------------------------------------------------------
% File     : COL068-1 : TPTP v9.2.1. Released v1.2.0.
% Domain   : Combinatory Logic
% Problem  : Weak fixed point for B and S
% Version  : [WM88] (equality) axioms.
% English  : The weak fixed point property holds for the set P consisting
%            of the combinators B and S, where ((Sx)y)z (xz)(yz), ((Bx)y)z
%            = x(yz).

% Refs     : [WM88]  Wos & McCune (1988), Challenge Problems Focusing on Eq
%          : [Wos93] Wos (1993), The Kernel Strategy and Its Use for the St
% Source   : [Wos93]
% Names    : Question 11 [Wos93]

% Status   : Unknown
% Rating   : 1.00 v2.0.0
% Syntax   : Number of clauses     :    3 (   3 unt;   0 nHn;   1 RR)
%            Number of literals    :    3 (   3 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    4 (   4 usr;   3 con; 0-2 aty)
%            Number of variables   :    7 (   0 sgn)
% SPC      : CNF_UNK_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
cnf(s_definition,axiom,
    apply(apply(apply(s,X),Y),Z) = apply(apply(X,Z),apply(Y,Z)) ).

cnf(b_definition,axiom,
    apply(apply(apply(b,X),Y),Z) = apply(X,apply(Y,Z)) ).

cnf(prove_fixed_point,negated_conjecture,
    Y != apply(combinator,Y) ).

%--------------------------------------------------------------------------
