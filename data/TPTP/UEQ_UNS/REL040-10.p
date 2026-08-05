%------------------------------------------------------------------------------
% File     : REL040-10 : TPTP v9.2.1. Released v7.5.0.
% Domain   : Puzzles
% Problem  : Partial functions distribute over meet under sequential comp'n
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.96 v9.1.0, 0.91 v8.2.0, 0.92 v8.1.0, 0.95 v7.5.0
% Syntax   : Number of clauses     :   18 (  18 unt;   0 nHn;   2 RR)
%            Number of literals    :   18 (  18 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    7 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   12 (  12 usr;   6 con; 0-2 aty)
%            Number of variables   :   34 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from REL040-4 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(maddux1_join_commutativity_1,axiom,
    join(A,B) = join(B,A) ).

cnf(maddux2_join_associativity_2,axiom,
    join(A,join(B,C)) = join(join(A,B),C) ).

cnf(maddux3_a_kind_of_de_Morgan_3,axiom,
    A = join(complement(join(complement(A),complement(B))),complement(join(complement(A),B))) ).

cnf(maddux4_definiton_of_meet_4,axiom,
    meet(A,B) = complement(join(complement(A),complement(B))) ).

cnf(composition_associativity_5,axiom,
    composition(A,composition(B,C)) = composition(composition(A,B),C) ).

cnf(composition_identity_6,axiom,
    composition(A,one) = A ).

cnf(composition_distributivity_7,axiom,
    composition(join(A,B),C) = join(composition(A,C),composition(B,C)) ).

cnf(converse_idempotence_8,axiom,
    converse(converse(A)) = A ).

cnf(converse_additivity_9,axiom,
    converse(join(A,B)) = join(converse(A),converse(B)) ).

cnf(converse_multiplicativity_10,axiom,
    converse(composition(A,B)) = composition(converse(B),converse(A)) ).

cnf(converse_cancellativity_11,axiom,
    join(composition(converse(A),complement(composition(A,B))),complement(B)) = complement(B) ).

cnf(def_top_12,axiom,
    top = join(A,complement(A)) ).

cnf(def_zero_13,axiom,
    zero = meet(A,complement(A)) ).

cnf(dedekind_law_14,axiom,
    join(meet(composition(A,B),C),composition(meet(A,composition(C,converse(B))),meet(B,composition(converse(A),C)))) = composition(meet(A,composition(C,converse(B))),meet(B,composition(converse(A),C))) ).

cnf(modular_law_1_15,axiom,
    join(meet(composition(A,B),C),meet(composition(A,meet(B,composition(converse(A),C))),C)) = meet(composition(A,meet(B,composition(converse(A),C))),C) ).

cnf(modular_law_2_16,axiom,
    join(meet(composition(A,B),C),meet(composition(meet(A,composition(C,converse(B))),B),C)) = meet(composition(meet(A,composition(C,converse(B))),B),C) ).

cnf(goals_17,negated_conjecture,
    join(composition(converse(sk1),sk1),one) = one ).

cnf(goals_18,negated_conjecture,
    tuple(join(meet(composition(sk1,sk2),composition(sk1,sk3)),composition(sk1,meet(sk2,sk3))),join(composition(sk1,meet(sk2,sk3)),meet(composition(sk1,sk2),composition(sk1,sk3)))) != tuple(composition(sk1,meet(sk2,sk3)),meet(composition(sk1,sk2),composition(sk1,sk3))) ).

%------------------------------------------------------------------------------
