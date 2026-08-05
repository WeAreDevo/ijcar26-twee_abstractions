%--------------------------------------------------------------------------
% File     : COL050-1 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Combinatory Logic
% Problem  : The Significance of the Mockingbird
% Version  : Especial.
% English  : There exists a mocking bird. For all birds x and y, there
%            exists a bird z that composes x with y for all birds w. Prove
%            that every bird is fond of at least one other bird.

% Refs     : [Smu85] Smullyan (1978), To Mock a Mocking Bird and Other Logi
% Source   : [ANL]
% Names    : bird1.ver1.in [ANL]

% Status   : Unsatisfiable
% Rating   : 0.04 v9.1.0, 0.09 v8.2.0, 0.08 v8.1.0, 0.10 v7.5.0, 0.08 v7.4.0, 0.13 v7.3.0, 0.11 v7.1.0, 0.06 v7.0.0, 0.00 v6.4.0, 0.05 v6.3.0, 0.06 v6.2.0, 0.07 v6.1.0, 0.00 v6.0.0, 0.10 v5.5.0, 0.05 v5.4.0, 0.00 v5.1.0, 0.07 v5.0.0, 0.00 v2.0.0
% Syntax   : Number of clauses     :    3 (   3 unt;   0 nHn;   1 RR)
%            Number of literals    :    3 (   3 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   1 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    4 (   4 usr;   2 con; 0-2 aty)
%            Number of variables   :    5 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%---- There exists a mocking bird (Mock).
%----    TEx FAy [response(x,y) = response(y,y)].
%----    response(Mock,y) = response(y,y).
cnf(mocking_bird_exists,axiom,
    response(mocking_bird,Y) = response(Y,Y) ).

%---- For all birds x and y, there exists a bird z that composes
%---- x with y for all birds w.
%----    FAx FAy TEz FAw [response(z,w) = response(x,response(y,w))]
%----    response(comp(x,y),w) = response(x,response(y,w)).
cnf(composer_exists,hypothesis,
    response(compose(X,Y),W) = response(X,response(Y,W)) ).

%---- Hypothesis: Every bird is fond of at least one other bird.
%----    -FAx TEy [response(x,y) = y].
%----    TEx FAy -[response(x,y) = y].
%----    Letting A = x,
%----    -[response(A,y) = y].
cnf(prove_all_fond_of_another,negated_conjecture,
    response(a,Y) != Y ).

%--------------------------------------------------------------------------
