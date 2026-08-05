%--------------------------------------------------------------------------
% File     : COL087-1 : TPTP v9.2.1. Released v2.7.0.
% Domain   : Combinatory Logic
% Problem  : Strong fixed point for B and M
% Version  : [Cla03] axioms.
% English  : The strong fixed point property holds for the set with the
%            combinators B and M as a basis, where Bxyz = x(yz) and
%            Mx = xx.

% Refs     : [WM88]  Wos & McCune (1988), Challenge Problems Focusing on Eq
%          : [Cla03] Claessen (2003), Email to G. Sutcliffe
% Source   : [Cla03]
% Names    :

% Status   : Open
% Rating   : 1.00 v2.7.0
% Syntax   : Number of clauses     :    3 (   3 unt;   0 nHn;   1 RR)
%            Number of literals    :    3 (   3 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    4 (   4 usr;   2 con; 0-2 aty)
%            Number of variables   :    5 (   0 sgn)
% SPC      : CNF_OPN_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
cnf(definition_B,axiom,
    apply(apply(apply(b,X),Y),Z) = apply(X,apply(Y,Z)) ).

cnf(definition_M,axiom,
    apply(m,X) = apply(X,X) ).

cnf(strong_fixpoint,negated_conjecture,
    apply(Y,f(Y)) != apply(f(Y),apply(Y,f(Y))) ).

%--------------------------------------------------------------------------
