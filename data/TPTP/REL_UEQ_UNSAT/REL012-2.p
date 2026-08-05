%------------------------------------------------------------------------------
% File     : REL012-2 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Relation Algebra
% Problem  : Cancelativity of converse
% Version  : [Mad95] (equational) axioms : Augmented.
% English  :

% Refs     : [Mad95] Maddux (1995), Relation-Algebraic Semantics
%          : [Hoe08] Hoefner (2008), Email to G. Sutcliffe
% Source   : [Hoe08]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.35 v9.1.0, 0.41 v8.2.0, 0.46 v8.1.0, 0.50 v7.5.0, 0.62 v7.4.0, 0.61 v7.3.0, 0.58 v7.1.0, 0.50 v7.0.0, 0.47 v6.4.0, 0.53 v6.2.0, 0.57 v6.1.0, 0.62 v6.0.0, 0.71 v5.5.0, 0.68 v5.4.0, 0.60 v5.3.0, 0.58 v5.2.0, 0.57 v5.1.0, 0.53 v5.0.0, 0.50 v4.1.0, 0.45 v4.0.1, 0.57 v4.0.0
% Syntax   : Number of clauses     :   17 (  17 unt;   0 nHn;   1 RR)
%            Number of literals    :   17 (  17 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    7 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   10 (  10 usr;   5 con; 0-2 aty)
%            Number of variables   :   34 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : tptp2X -f tptp:short -t cnf:otter REL012+2.p
%------------------------------------------------------------------------------
%----Include axioms of relation algebra
include('Axioms/REL001-0.ax').
%----Include Dedekind and modular laws
include('Axioms/REL001-1.ax').
%------------------------------------------------------------------------------
cnf(goals_17,negated_conjecture,
    join(composition(complement(composition(sk1,sk2)),converse(sk2)),complement(sk1)) != complement(sk1) ).

%------------------------------------------------------------------------------
