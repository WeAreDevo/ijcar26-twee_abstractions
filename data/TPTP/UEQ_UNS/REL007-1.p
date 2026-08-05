%------------------------------------------------------------------------------
% File     : REL007-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Relation Algebra
% Problem  : For empty meet the converse slides over meet
% Version  : [Mad95] (equational) axioms.
% English  :

% Refs     : [Mad95] Maddux (1995), Relation-Algebraic Semantics
%          : [Hoe08] Hoefner (2008), Email to G. Sutcliffe
% Source   : [Hoe08]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.13 v9.1.0, 0.18 v8.2.0, 0.29 v8.1.0, 0.35 v7.5.0, 0.25 v7.4.0, 0.35 v7.3.0, 0.21 v7.1.0, 0.11 v7.0.0, 0.21 v6.4.0, 0.26 v6.3.0, 0.24 v6.2.0, 0.21 v6.1.0, 0.31 v6.0.0, 0.43 v5.5.0, 0.42 v5.4.0, 0.27 v5.3.0, 0.17 v5.2.0, 0.21 v5.1.0, 0.33 v5.0.0, 0.36 v4.1.0, 0.27 v4.0.1, 0.21 v4.0.0
% Syntax   : Number of clauses     :   15 (  15 unt;   0 nHn;   2 RR)
%            Number of literals    :   15 (  15 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   10 (  10 usr;   5 con; 0-2 aty)
%            Number of variables   :   25 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : tptp2X -f tptp:short -t cnf:otter REL007+1.p
%------------------------------------------------------------------------------
%----Include axioms of relation algebra
include('Axioms/REL001-0.ax').
%------------------------------------------------------------------------------
cnf(goals_14,negated_conjecture,
    meet(sk1,converse(sk2)) = zero ).

cnf(goals_15,negated_conjecture,
    meet(converse(sk1),sk2) != zero ).

%------------------------------------------------------------------------------
