%------------------------------------------------------------------------------
% File     : ROB030-1 : TPTP v9.2.1. Released v3.1.0.
% Domain   : Robbins Algebra
% Problem  : Exists absorbed element => Exists absorbed within negation element
% Version  : [Win90] (equality) axioms.
%            Theorem formulation : Denies Huntington's axiom.
% English  : If there are elements c and d such that c+d=d, then the
%            algebra is Boolean.

% Refs     : [Win90] Winker (1990), Robbins Algebra: Conditions that make a
%          : [Loe04] Loechner (2004), Email to Geoff Sutcliffe
% Source   : [Loe04]
% Names    : (1) [Loe04]

% Status   : Unsatisfiable
% Rating   : 0.00 v7.4.0, 0.04 v7.3.0, 0.00 v6.3.0, 0.06 v6.2.0, 0.07 v6.1.0, 0.00 v6.0.0, 0.10 v5.5.0, 0.05 v5.4.0, 0.00 v5.2.0, 0.07 v5.1.0, 0.13 v5.0.0, 0.07 v4.1.0, 0.09 v4.0.1, 0.07 v4.0.0, 0.08 v3.7.0, 0.00 v3.1.0
% Syntax   : Number of clauses     :    5 (   5 unt;   0 nHn;   2 RR)
%            Number of literals    :    5 (   5 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    4 (   4 usr;   2 con; 0-2 aty)
%            Number of variables   :    9 (   1 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%------------------------------------------------------------------------------
%----Include axioms for Robbins algebra
include('Axioms/ROB001-0.ax').
%------------------------------------------------------------------------------
cnf(absorbtion,hypothesis,
    add(c,d) = d ).

cnf(prove_absorption_within_negation,negated_conjecture,
    negate(add(A,B)) != negate(B) ).

%------------------------------------------------------------------------------
