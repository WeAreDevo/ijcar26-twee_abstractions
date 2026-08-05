%------------------------------------------------------------------------------
% File     : REL027-3 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Relation Algebra
% Problem  : Complements of vectors and subidentities
% Version  : [Mad95] (equational) axioms : Augmented.
% English  : The relative complement of subidentity x w.r.t. 1 can also be
%            obtained by projecting the complement of the corresponding vector
%            x;TOP to a subidentity.

% Refs     : [Mad95] Maddux (1995), Relation-Algebraic Semantics
%          : [Hoe08] Hoefner (2008), Email to G. Sutcliffe
% Source   : [Hoe08]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.43 v9.1.0, 0.50 v8.2.0, 0.58 v8.1.0, 0.65 v7.5.0, 0.54 v7.4.0, 0.52 v7.3.0, 0.53 v7.1.0, 0.44 v7.0.0, 0.47 v6.3.0, 0.53 v6.2.0, 0.57 v6.1.0, 0.56 v6.0.0, 0.71 v5.5.0, 0.68 v5.4.0, 0.60 v5.3.0, 0.58 v5.2.0, 0.57 v5.1.0, 0.60 v5.0.0, 0.57 v4.1.0, 0.55 v4.0.1, 0.57 v4.0.0
% Syntax   : Number of clauses     :   18 (  18 unt;   0 nHn;   2 RR)
%            Number of literals    :   18 (  18 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    7 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    9 (   9 usr;   4 con; 0-2 aty)
%            Number of variables   :   34 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : tptp2X -f tptp:short -t cnf:otter REL027+3.p
%------------------------------------------------------------------------------
%----Include axioms of relation algebra
include('Axioms/REL001-0.ax').
%----Include Dedekind and modular laws
include('Axioms/REL001-1.ax').
%------------------------------------------------------------------------------
cnf(goals_17,negated_conjecture,
    join(sk1,one) = one ).

cnf(goals_18,negated_conjecture,
    meet(complement(composition(sk1,top)),one) != meet(complement(sk1),one) ).

%------------------------------------------------------------------------------
