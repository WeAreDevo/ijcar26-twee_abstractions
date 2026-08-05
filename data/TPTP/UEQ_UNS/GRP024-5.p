%--------------------------------------------------------------------------
% File     : GRP024-5 : TPTP v9.2.1. Released v2.2.0.
% Domain   : Group Theory
% Problem  : Levi commutator problem.
% Version  : [McC98] (equality) axioms.
% English  : In group theory, if the commutator [x,y] is associative,
%            then x*[y,z] = [y,z]*x.

% Refs     : [McC98] McCune (1998), Email to G. Sutcliffe
%          : [ML92]  McCune & Lusk (1992), A Challenging Theorem of Levi
%          : [Kur56] Kurosh (1956), The Theory of Groups
% Source   : [McC98]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.61 v9.1.0, 0.59 v8.2.0, 0.58 v8.1.0, 0.75 v7.5.0, 0.79 v7.4.0, 0.87 v7.3.0, 0.79 v7.1.0, 0.83 v7.0.0, 0.84 v6.4.0, 0.89 v6.3.0, 0.88 v6.2.0, 0.79 v6.1.0, 0.81 v6.0.0, 0.86 v5.5.0, 0.84 v5.4.0, 0.80 v5.3.0, 0.83 v5.2.0, 0.79 v5.1.0, 0.73 v5.0.0, 0.79 v4.1.0, 0.64 v4.0.0, 0.62 v3.7.0, 0.33 v3.4.0, 0.38 v3.3.0, 0.57 v3.2.0, 0.50 v3.1.0, 0.44 v2.7.0, 0.64 v2.6.0, 0.33 v2.5.0, 0.00 v2.4.0, 0.33 v2.3.0, 0.67 v2.2.1
% Syntax   : Number of clauses     :    6 (   6 unt;   0 nHn;   1 RR)
%            Number of literals    :    6 (   6 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   4 con; 0-2 aty)
%            Number of variables   :   10 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Include group theory axioms
include('Axioms/GRP004-0.ax').
%--------------------------------------------------------------------------
%----Definition of commutator:
cnf(name,axiom,
    commutator(X,Y) = multiply(inverse(X),multiply(inverse(Y),multiply(X,Y))) ).

%----Theorem: commutator is associative implies x*[y,z] = [y,z]*x.
%----Hypothesis:
cnf(associativity_of_commutator,hypothesis,
    commutator(commutator(X,Y),Z) = commutator(X,commutator(Y,Z)) ).

%----Denial of conclusion:
cnf(prove_center,negated_conjecture,
    multiply(a,commutator(b,c)) != multiply(commutator(b,c),a) ).

%--------------------------------------------------------------------------
