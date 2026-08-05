%------------------------------------------------------------------------------
% File     : REL011-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Relation Algebra
% Problem  : Schroeder equivalence (second implication)
% Version  : [Mad95] (equational) axioms.
% English  : Describes the interplay between composition, converse and
%            complement, w.r.t. containment.

% Refs     : [Mad95] Maddux (1995), Relation-Algebraic Semantics
%          : [Hoe08] Hoefner (2008), Email to G. Sutcliffe
% Source   : [Hoe08]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.74 v9.1.0, 0.73 v9.0.0, 0.77 v8.2.0, 0.75 v8.1.0, 0.80 v7.5.0, 0.79 v7.4.0, 0.91 v7.3.0, 0.74 v7.1.0, 0.67 v7.0.0, 0.79 v6.4.0, 0.84 v6.3.0, 0.82 v6.2.0, 0.79 v6.1.0, 0.81 v6.0.0, 0.95 v5.4.0, 0.87 v5.3.0, 0.83 v5.2.0, 0.86 v5.1.0, 0.87 v5.0.0, 0.86 v4.1.0, 0.82 v4.0.1, 0.79 v4.0.0
% Syntax   : Number of clauses     :   15 (  15 unt;   0 nHn;   2 RR)
%            Number of literals    :   15 (  15 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   11 (  11 usr;   6 con; 0-2 aty)
%            Number of variables   :   25 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : tptp2X -f tptp:short -t cnf:otter REL011+1.p
%------------------------------------------------------------------------------
%----Include axioms of relation algebra
include('Axioms/REL001-0.ax').
%------------------------------------------------------------------------------
cnf(goals_14,negated_conjecture,
    meet(sk1,composition(converse(sk2),sk3)) = zero ).

cnf(goals_15,negated_conjecture,
    meet(composition(sk2,sk1),sk3) != zero ).

%------------------------------------------------------------------------------
