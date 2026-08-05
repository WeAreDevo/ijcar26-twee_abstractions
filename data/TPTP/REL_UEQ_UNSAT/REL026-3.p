%------------------------------------------------------------------------------
% File     : REL026-3 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Relation Algebra
% Problem  : Splitting rule for x;y if x is a subidentity
% Version  : [Mad95] (equational) axioms : Augmented.
% English  : If x is a subidentity then the composition of x and y can be
%            split into a meet.

% Refs     : [Mad95] Maddux (1995), Relation-Algebraic Semantics
%          : [Hoe08] Hoefner (2008), Email to G. Sutcliffe
% Source   : [Hoe08]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.52 v9.1.0, 0.55 v8.2.0, 0.62 v8.1.0, 0.65 v7.5.0, 0.67 v7.4.0, 0.70 v7.3.0, 0.68 v7.1.0, 0.61 v7.0.0, 0.63 v6.4.0, 0.68 v6.3.0, 0.71 v6.1.0, 0.69 v6.0.0, 0.76 v5.5.0, 0.79 v5.4.0, 0.67 v5.2.0, 0.71 v5.1.0, 0.73 v5.0.0, 0.64 v4.0.0
% Syntax   : Number of clauses     :   18 (  18 unt;   0 nHn;   2 RR)
%            Number of literals    :   18 (  18 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    7 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   10 (  10 usr;   5 con; 0-2 aty)
%            Number of variables   :   34 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : tptp2X -f tptp:short -t cnf:otter REL026+3.p
%------------------------------------------------------------------------------
%----Include axioms of relation algebra
include('Axioms/REL001-0.ax').
%----Include Dedekind and modular laws
include('Axioms/REL001-1.ax').
%------------------------------------------------------------------------------
cnf(goals_17,negated_conjecture,
    join(sk1,one) = one ).

cnf(goals_18,negated_conjecture,
    meet(composition(sk1,top),sk2) != composition(sk1,sk2) ).

%------------------------------------------------------------------------------
