%------------------------------------------------------------------------------
% File     : REL031-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Relation Algebra
% Problem  : Partial functions are closed under composition
% Version  : [Mad95] (equational) axioms.
% English  : If x and y are partial functions then x;y is also a partial
%            functions.

% Refs     : [Mad95] Maddux (1995), Relation-Algebraic Semantics
%          : [Hoe08] Hoefner (2008), Email to G. Sutcliffe
% Source   : [Hoe08]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.43 v9.1.0, 0.50 v8.2.0, 0.58 v8.1.0, 0.60 v7.5.0, 0.50 v7.4.0, 0.61 v7.3.0, 0.58 v7.1.0, 0.56 v7.0.0, 0.53 v6.4.0, 0.58 v6.3.0, 0.65 v6.2.0, 0.64 v6.1.0, 0.69 v6.0.0, 0.81 v5.5.0, 0.79 v5.4.0, 0.67 v5.2.0, 0.64 v5.1.0, 0.67 v5.0.0, 0.64 v4.1.0, 0.45 v4.0.1, 0.57 v4.0.0
% Syntax   : Number of clauses     :   16 (  16 unt;   0 nHn;   3 RR)
%            Number of literals    :   16 (  16 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   10 (  10 usr;   5 con; 0-2 aty)
%            Number of variables   :   25 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : tptp2X -f tptp:short -t cnf:otter REL031+1.p
%------------------------------------------------------------------------------
%----Include axioms of relation algebra
include('Axioms/REL001-0.ax').
%------------------------------------------------------------------------------
cnf(goals_14,negated_conjecture,
    join(composition(converse(sk1),sk1),one) = one ).

cnf(goals_15,negated_conjecture,
    join(composition(converse(sk2),sk2),one) = one ).

cnf(goals_16,negated_conjecture,
    join(composition(converse(composition(sk1,sk2)),composition(sk1,sk2)),one) != one ).

%------------------------------------------------------------------------------
