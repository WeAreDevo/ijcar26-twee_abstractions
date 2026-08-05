%------------------------------------------------------------------------------
% File     : REL049-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Relation Algebra
% Problem  : Join splitting
% Version  : [Mad95] (equational) axioms.
% English  : Join can be split into 2 inequations iff the join is on the
%            left hand side of an inequation.

% Refs     : [Mad95] Maddux (1995), Relation-Algebraic Semantics
%          : [Hoe08] Hoefner (2008), Email to G. Sutcliffe
% Source   : [Hoe08]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.00 v7.4.0, 0.04 v7.3.0, 0.00 v7.0.0, 0.05 v6.3.0, 0.12 v6.2.0, 0.14 v6.1.0, 0.06 v6.0.0, 0.10 v5.5.0, 0.05 v5.4.0, 0.00 v4.0.1, 0.07 v4.0.0
% Syntax   : Number of clauses     :   16 (  16 unt;   0 nHn;   3 RR)
%            Number of literals    :   16 (  16 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   11 (  11 usr;   6 con; 0-2 aty)
%            Number of variables   :   25 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : tptp2X -f tptp:short -t cnf:otter REL049+1.p
%------------------------------------------------------------------------------
%----Include axioms of relation algebra
include('Axioms/REL001-0.ax').
%------------------------------------------------------------------------------
cnf(goals_14,negated_conjecture,
    join(sk1,sk2) = sk2 ).

cnf(goals_15,negated_conjecture,
    join(sk3,sk2) = sk2 ).

cnf(goals_16,negated_conjecture,
    join(join(sk1,sk3),sk2) != sk2 ).

%------------------------------------------------------------------------------
