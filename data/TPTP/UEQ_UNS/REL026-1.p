%------------------------------------------------------------------------------
% File     : REL026-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Relation Algebra
% Problem  : Splitting rule for x;y if x is a subidentity
% Version  : [Mad95] (equational) axioms.
% English  : If x is a subidentity then the composition of x and y can be
%            split into a meet.

% Refs     : [Mad95] Maddux (1995), Relation-Algebraic Semantics
%          : [Hoe08] Hoefner (2008), Email to G. Sutcliffe
% Source   : [Hoe08]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.52 v9.1.0, 0.59 v8.2.0, 0.67 v8.1.0, 0.70 v7.5.0, 0.62 v7.4.0, 0.65 v7.3.0, 0.63 v7.1.0, 0.56 v7.0.0, 0.58 v6.4.0, 0.74 v6.3.0, 0.71 v6.1.0, 0.75 v6.0.0, 0.81 v5.5.0, 0.79 v5.4.0, 0.73 v5.3.0, 0.67 v5.2.0, 0.71 v5.1.0, 0.73 v5.0.0, 0.71 v4.1.0, 0.64 v4.0.0
% Syntax   : Number of clauses     :   15 (  15 unt;   0 nHn;   2 RR)
%            Number of literals    :   15 (  15 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   10 (  10 usr;   5 con; 0-2 aty)
%            Number of variables   :   25 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : tptp2X -f tptp:short -t cnf:otter REL026+1.p
%------------------------------------------------------------------------------
%----Include axioms of relation algebra
include('Axioms/REL001-0.ax').
%------------------------------------------------------------------------------
cnf(goals_14,negated_conjecture,
    join(sk1,one) = one ).

cnf(goals_15,negated_conjecture,
    meet(composition(sk1,top),sk2) != composition(sk1,sk2) ).

%------------------------------------------------------------------------------
