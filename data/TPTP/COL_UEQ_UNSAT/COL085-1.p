%--------------------------------------------------------------------------
% File     : COL085-1 : TPTP v9.2.1. Released v2.6.0.
% Domain   : Combinatory Logic
% Problem  : Happy Birds, part 1
% Version  : Especial.
% English  :

% Refs     : [Smu85] Smullyan (1978), To Mock a Mocking Bird and Other Logi
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.00 v7.4.0, 0.04 v7.3.0, 0.00 v6.0.0, 0.05 v5.5.0, 0.00 v5.1.0, 0.07 v4.1.0, 0.09 v4.0.1, 0.07 v4.0.0, 0.08 v3.7.0, 0.00 v2.6.0
% Syntax   : Number of clauses     :    2 (   2 unt;   0 nHn;   2 RR)
%            Number of literals    :    2 (   2 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    2 (   1 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    3 (   3 usr;   2 con; 0-2 aty)
%            Number of variables   :    2 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : A UEQ part of COL055-1
%--------------------------------------------------------------------------
cnf(fond_bird_exists,hypothesis,
    response(a,b) = b ).

cnf(prove_happiness_1,negated_conjecture,
    response(a,A) != B ).

%--------------------------------------------------------------------------
