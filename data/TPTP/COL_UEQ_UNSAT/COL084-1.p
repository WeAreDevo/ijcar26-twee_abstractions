%--------------------------------------------------------------------------
% File     : COL084-1 : TPTP v9.2.1. Released v2.6.0.
% Domain   : Combinatory Logic
% Problem  : Compatible Birds, part 2
% Version  : Especial.
% English  :

% Refs     : [Smu85] Smullyan (1978), To Mock a Mocking Bird and Other Logi
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.00 v7.4.0, 0.04 v7.3.0, 0.00 v6.3.0, 0.06 v6.2.0, 0.07 v6.1.0, 0.00 v6.0.0, 0.05 v5.5.0, 0.00 v5.1.0, 0.07 v4.1.0, 0.09 v4.0.1, 0.07 v4.0.0, 0.08 v3.7.0, 0.00 v2.6.0
% Syntax   : Number of clauses     :    3 (   3 unt;   0 nHn;   1 RR)
%            Number of literals    :    3 (   3 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   1 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    4 (   4 usr;   2 con; 0-2 aty)
%            Number of variables   :    6 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : A UEQ part of COL054-1
%--------------------------------------------------------------------------
cnf(mocking_bird_exists,axiom,
    response(mocking_bird,A) = response(A,A) ).

cnf(composer_exists,hypothesis,
    response(compose(A,B),C) = response(A,response(B,C)) ).

cnf(prove_birds_are_compatible_2,negated_conjecture,
    response(b,B) != A ).

%--------------------------------------------------------------------------
