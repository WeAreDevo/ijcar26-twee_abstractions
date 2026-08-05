%------------------------------------------------------------------------------
% File     : REL019-2 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Relation Algebra
% Problem  : Vectors are closed under meet
% Version  : [Mad95] (equational) axioms : Augmented.
% English  : If x and y are vectors then x meet y is a vector too.

% Refs     : [Mad95] Maddux (1995), Relation-Algebraic Semantics
%          : [Hoe08] Hoefner (2008), Email to G. Sutcliffe
% Source   : [Hoe08]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.65 v9.1.0, 0.68 v9.0.0, 0.64 v8.2.0, 0.67 v8.1.0, 0.80 v7.5.0, 0.79 v7.4.0, 0.83 v7.3.0, 0.74 v7.1.0, 0.67 v7.0.0, 0.68 v6.4.0, 0.79 v6.3.0, 0.82 v6.2.0, 0.79 v6.1.0, 0.81 v5.5.0, 0.84 v5.4.0, 0.80 v5.3.0, 0.75 v5.2.0, 0.79 v5.1.0, 0.80 v5.0.0, 0.86 v4.1.0, 0.82 v4.0.1, 0.86 v4.0.0
% Syntax   : Number of clauses     :   19 (  19 unt;   0 nHn;   3 RR)
%            Number of literals    :   19 (  19 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    7 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   10 (  10 usr;   5 con; 0-2 aty)
%            Number of variables   :   34 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : tptp2X -f tptp:short -t cnf:otter REL019+2.p
%------------------------------------------------------------------------------
%----Include axioms of relation algebra
include('Axioms/REL001-0.ax').
%----Include Dedekind and modular laws
include('Axioms/REL001-1.ax').
%------------------------------------------------------------------------------
cnf(goals_17,negated_conjecture,
    composition(sk1,top) = sk1 ).

cnf(goals_18,negated_conjecture,
    composition(sk2,top) = sk2 ).

cnf(goals_19,negated_conjecture,
    composition(meet(sk1,sk2),top) != meet(sk1,sk2) ).

%------------------------------------------------------------------------------
