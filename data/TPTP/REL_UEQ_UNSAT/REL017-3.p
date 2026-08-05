%------------------------------------------------------------------------------
% File     : REL017-3 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Relation Algebra
% Problem  : Another modular law
% Version  : [Mad95] (equational) axioms : Augmented.
% English  :

% Refs     : [Mad95] Maddux (1995), Relation-Algebraic Semantics
%          : [Hoe08] Hoefner (2008), Email to G. Sutcliffe
% Source   : [Hoe08]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.96 v9.1.0, 0.91 v9.0.0, 0.95 v8.2.0, 0.96 v8.1.0, 0.95 v7.5.0, 0.96 v7.4.0, 0.91 v7.3.0, 0.95 v7.1.0, 0.89 v7.0.0, 0.95 v6.3.0, 0.94 v6.2.0, 1.00 v4.0.0
% Syntax   : Number of clauses     :   17 (  17 unt;   0 nHn;   1 RR)
%            Number of literals    :   17 (  17 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    7 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   11 (  11 usr;   6 con; 0-2 aty)
%            Number of variables   :   34 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : tptp2X -f tptp:short -t cnf:otter REL017+3.p
%------------------------------------------------------------------------------
%----Include axioms of relation algebra
include('Axioms/REL001-0.ax').
%----Include Dedekind and modular laws
include('Axioms/REL001-1.ax').
%------------------------------------------------------------------------------
cnf(goals_17,negated_conjecture,
    join(complement(composition(sk1,sk2)),composition(sk1,sk3)) != join(complement(composition(sk1,meet(sk2,complement(sk3)))),composition(sk1,sk3)) ).

%------------------------------------------------------------------------------
