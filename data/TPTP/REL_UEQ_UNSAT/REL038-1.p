%------------------------------------------------------------------------------
% File     : REL038-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Relation Algebra
% Problem  : Modular law
% Version  : [Mad95] (equational) axioms.
% English  :

% Refs     : [Mad95] Maddux (1995), Relation-Algebraic Semantics
%          : [Hoe08] Hoefner (2008), Email to G. Sutcliffe
% Source   : [Hoe08]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.91 v9.1.0, 0.95 v8.2.0, 0.96 v8.1.0, 1.00 v4.0.0
% Syntax   : Number of clauses     :   14 (  14 unt;   0 nHn;   1 RR)
%            Number of literals    :   14 (  14 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    7 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   11 (  11 usr;   6 con; 0-2 aty)
%            Number of variables   :   25 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : tptp2X -f tptp:short -t cnf:otter REL038+1.p
%------------------------------------------------------------------------------
%----Include axioms of relation algebra
include('Axioms/REL001-0.ax').
%------------------------------------------------------------------------------
cnf(goals_14,negated_conjecture,
    join(meet(composition(sk1,sk2),sk3),meet(composition(sk1,meet(sk2,composition(converse(sk1),sk3))),sk3)) != meet(composition(sk1,meet(sk2,composition(converse(sk1),sk3))),sk3) ).

%------------------------------------------------------------------------------
