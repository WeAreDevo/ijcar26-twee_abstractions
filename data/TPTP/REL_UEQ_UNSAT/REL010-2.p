%------------------------------------------------------------------------------
% File     : REL010-2 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Relation Algebra
% Problem  : Schroeder equivalence (first implication)
% Version  : [Mad95] (equational) axioms : Augmented.
% English  : Describes the interplay between composition, converse and
%            complement, w.r.t. containment.

% Refs     : [Mad95] Maddux (1995), Relation-Algebraic Semantics
%          : [Hoe08] Hoefner (2008), Email to G. Sutcliffe
% Source   : [Hoe08]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.35 v9.1.0, 0.41 v8.2.0, 0.46 v8.1.0, 0.40 v7.5.0, 0.42 v7.4.0, 0.43 v7.3.0, 0.37 v7.1.0, 0.33 v7.0.0, 0.42 v6.3.0, 0.41 v6.2.0, 0.43 v6.1.0, 0.50 v6.0.0, 0.67 v5.5.0, 0.63 v5.4.0, 0.53 v5.3.0, 0.50 v5.1.0, 0.53 v5.0.0, 0.50 v4.1.0, 0.36 v4.0.1, 0.43 v4.0.0
% Syntax   : Number of clauses     :   18 (  18 unt;   0 nHn;   2 RR)
%            Number of literals    :   18 (  18 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    7 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   11 (  11 usr;   6 con; 0-2 aty)
%            Number of variables   :   34 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : tptp2X -f tptp:short -t cnf:otter REL010+2.p
%------------------------------------------------------------------------------
%----Include axioms of relation algebra
include('Axioms/REL001-0.ax').
%----Include Dedekind and modular laws
include('Axioms/REL001-1.ax').
%------------------------------------------------------------------------------
cnf(goals_17,negated_conjecture,
    meet(composition(sk1,sk2),sk3) = zero ).

cnf(goals_18,negated_conjecture,
    meet(sk2,composition(converse(sk1),sk3)) != zero ).

%------------------------------------------------------------------------------
