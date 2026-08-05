%--------------------------------------------------------------------------
% File     : COL075-2 : TPTP v9.2.1. Released v1.2.0.
% Domain   : Combinatory Logic
% Problem  : Lemma 1 for showing the unsatisfiable variant of TRC
% Version  : [Jec95] (equality) axioms : Reduced > Incomplete.
% English  : Searching for a diagonal combinator F with the property
%            f X Y = X X.

% Refs     : [Jec95] Jech (1995), Otter Experiments in a System of Combinat
% Source   : [Jec95]
% Names    : - [Jec95]

% Status   : Unsatisfiable
% Rating   : 0.09 v9.1.0, 0.14 v8.2.0, 0.21 v8.1.0, 0.25 v7.5.0, 0.21 v7.4.0, 0.26 v7.3.0, 0.21 v7.1.0, 0.11 v6.4.0, 0.16 v6.3.0, 0.18 v6.2.0, 0.14 v6.1.0, 0.00 v6.0.0, 0.14 v5.5.0, 0.05 v5.4.0, 0.00 v5.1.0, 0.13 v5.0.0, 0.14 v4.1.0, 0.18 v4.0.1, 0.14 v4.0.0, 0.15 v3.7.0, 0.11 v3.4.0, 0.12 v3.3.0, 0.00 v2.0.0
% Syntax   : Number of clauses     :    3 (   3 unt;   0 nHn;   1 RR)
%            Number of literals    :    3 (   3 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   2 con; 0-2 aty)
%            Number of variables   :    6 (   1 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Don't include axioms of Type-respecting combinators
%include('Axioms/COL001-0.ax').
%--------------------------------------------------------------------------
%----Replace k function by k combinator
%input_clause(k_definition,axiom,
%    [++equal(apply(k(X),Y),X)]).
cnf(k_definition,axiom,
    apply(apply(k,X),Y) = X ).

%----Replace k function by k combinator
%input_clause(abstraction,axiom,
%    [++equal(apply(apply(apply(abstraction,X),Y),Z),apply(apply(X,k(Z)),
%apply(Y,Z)))]).
cnf(abstraction,axiom,
    apply(apply(apply(abstraction,X),Y),Z) = apply(apply(X,apply(k,Z)),apply(Y,Z)) ).

%----Subsitution axioms
cnf(prove_diagonal_combinator,negated_conjecture,
    apply(apply(Y,b(Y)),c(Y)) != apply(b(Y),b(Y)) ).

%--------------------------------------------------------------------------
