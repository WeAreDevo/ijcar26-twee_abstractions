%------------------------------------------------------------------------------
% File     : REL042-2 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Relation Algebra
% Problem  : Equivalence of different definitions of partial functions
% Version  : [Mad95] (equational) axioms : Augmented.
% English  : x is a partial function if x^;x is a subidentity ([SS93]). x is
%            a partial function if for all y x;y meet x;overline{y} = 0.
%            These definitions are equivalent.

% Refs     : [Mad95] Maddux (1995), Relation-Algebraic Semantics
%          : [Hoe08] Hoefner (2008), Email to G. Sutcliffe
% Source   : [Hoe08]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.30 v9.1.0, 0.41 v9.0.0, 0.36 v8.2.0, 0.42 v8.1.0, 0.40 v7.5.0, 0.38 v7.4.0, 0.35 v7.3.0, 0.37 v7.1.0, 0.28 v7.0.0, 0.32 v6.4.0, 0.37 v6.3.0, 0.35 v6.2.0, 0.36 v6.1.0, 0.44 v6.0.0, 0.62 v5.5.0, 0.58 v5.4.0, 0.47 v5.3.0, 0.42 v5.2.0, 0.43 v5.1.0, 0.53 v5.0.0, 0.50 v4.1.0, 0.36 v4.0.1, 0.50 v4.0.0
% Syntax   : Number of clauses     :   18 (  18 unt;   0 nHn;   1 RR)
%            Number of literals    :   18 (  18 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    7 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    9 (   9 usr;   4 con; 0-2 aty)
%            Number of variables   :   35 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : tptp2X -f tptp:short -t cnf:otter REL042+2.p
%------------------------------------------------------------------------------
%----Include axioms of relation algebra
include('Axioms/REL001-0.ax').
%----Include Dedekind and modular laws
include('Axioms/REL001-1.ax').
%------------------------------------------------------------------------------
cnf(goals_17,negated_conjecture,
    meet(composition(sk1,A),composition(sk1,complement(A))) = zero ).

cnf(goals_18,negated_conjecture,
    join(composition(converse(sk1),sk1),one) != one ).

%------------------------------------------------------------------------------
