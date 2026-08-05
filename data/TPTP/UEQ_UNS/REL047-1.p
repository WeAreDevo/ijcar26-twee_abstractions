%------------------------------------------------------------------------------
% File     : REL047-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Relation Algebra
% Problem  : Meet splitting
% Version  : [Mad95] (equational) axioms.
% English  : Meet can be split into 2 inequations iff the meet is on the
%            right hand side of an inequation.

% Refs     : [Mad95] Maddux (1995), Relation-Algebraic Semantics
%          : [Hoe08] Hoefner (2008), Email to G. Sutcliffe
% Source   : [Hoe08]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.39 v9.1.0, 0.36 v9.0.0, 0.41 v8.2.0, 0.50 v8.1.0, 0.65 v7.5.0, 0.62 v7.4.0, 0.70 v7.3.0, 0.63 v7.1.0, 0.56 v7.0.0, 0.58 v6.4.0, 0.63 v6.3.0, 0.71 v6.1.0, 0.69 v6.0.0, 0.76 v5.5.0, 0.79 v5.4.0, 0.73 v5.3.0, 0.67 v5.2.0, 0.79 v5.1.0, 0.67 v5.0.0, 0.57 v4.1.0, 0.64 v4.0.0
% Syntax   : Number of clauses     :   16 (  16 unt;   0 nHn;   3 RR)
%            Number of literals    :   16 (  16 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   11 (  11 usr;   6 con; 0-2 aty)
%            Number of variables   :   25 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : tptp2X -f tptp:short -t cnf:otter REL047+1.p
%------------------------------------------------------------------------------
%----Include axioms of relation algebra
include('Axioms/REL001-0.ax').
%------------------------------------------------------------------------------
cnf(goals_14,negated_conjecture,
    join(sk1,sk2) = sk2 ).

cnf(goals_15,negated_conjecture,
    join(sk1,sk3) = sk3 ).

cnf(goals_16,negated_conjecture,
    join(sk1,meet(sk2,sk3)) != meet(sk2,sk3) ).

%------------------------------------------------------------------------------
