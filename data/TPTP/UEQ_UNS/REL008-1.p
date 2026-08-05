%------------------------------------------------------------------------------
% File     : REL008-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Relation Algebra
% Problem  : Sequential composition distributes over addition
% Version  : [Mad95] (equational) axioms.
% English  :

% Refs     : [Mad95] Maddux (1995), Relation-Algebraic Semantics
%          : [Hoe08] Hoefner (2008), Email to G. Sutcliffe
% Source   : [Hoe08]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.35 v9.1.0, 0.36 v9.0.0, 0.41 v8.2.0, 0.46 v8.1.0, 0.45 v7.5.0, 0.50 v7.4.0, 0.57 v7.3.0, 0.47 v7.1.0, 0.39 v7.0.0, 0.37 v6.4.0, 0.47 v6.2.0, 0.50 v6.1.0, 0.56 v6.0.0, 0.62 v5.5.0, 0.58 v5.4.0, 0.53 v5.3.0, 0.58 v5.2.0, 0.50 v5.1.0, 0.60 v5.0.0, 0.57 v4.1.0, 0.55 v4.0.1, 0.57 v4.0.0
% Syntax   : Number of clauses     :   14 (  14 unt;   0 nHn;   1 RR)
%            Number of literals    :   14 (  14 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   11 (  11 usr;   6 con; 0-2 aty)
%            Number of variables   :   25 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : tptp2X -f tptp:short -t cnf:otter REL008+1.p
%------------------------------------------------------------------------------
%----Include axioms of relation algebra
include('Axioms/REL001-0.ax').
%------------------------------------------------------------------------------
cnf(goals_14,negated_conjecture,
    composition(sk1,join(sk2,sk3)) != join(composition(sk1,sk2),composition(sk1,sk3)) ).

%------------------------------------------------------------------------------
