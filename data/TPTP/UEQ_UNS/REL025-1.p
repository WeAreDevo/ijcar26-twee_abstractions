%------------------------------------------------------------------------------
% File     : REL025-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Relation Algebra
% Problem  : For subidentities converse is redundant
% Version  : [Mad95] (equational) axioms.
% English  : If x is a subidentity then the converse of x equals x.

% Refs     : [Mad95] Maddux (1995), Relation-Algebraic Semantics
%          : [Hoe08] Hoefner (2008), Email to G. Sutcliffe
% Source   : [Hoe08]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.43 v9.1.0, 0.45 v8.2.0, 0.54 v8.1.0, 0.65 v7.5.0, 0.50 v7.4.0, 0.52 v7.3.0, 0.53 v7.1.0, 0.44 v7.0.0, 0.47 v6.4.0, 0.58 v6.3.0, 0.53 v6.2.0, 0.50 v6.1.0, 0.62 v6.0.0, 0.71 v5.5.0, 0.74 v5.4.0, 0.60 v5.3.0, 0.58 v5.2.0, 0.64 v5.1.0, 0.67 v5.0.0, 0.57 v4.1.0, 0.55 v4.0.1, 0.64 v4.0.0
% Syntax   : Number of clauses     :   15 (  15 unt;   0 nHn;   2 RR)
%            Number of literals    :   15 (  15 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    9 (   9 usr;   4 con; 0-2 aty)
%            Number of variables   :   25 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : tptp2X -f tptp:short -t cnf:otter REL025+1.p
%------------------------------------------------------------------------------
%----Include axioms of relation algebra
include('Axioms/REL001-0.ax').
%------------------------------------------------------------------------------
cnf(goals_14,negated_conjecture,
    join(sk1,one) = one ).

cnf(goals_15,negated_conjecture,
    converse(sk1) != sk1 ).

%------------------------------------------------------------------------------
