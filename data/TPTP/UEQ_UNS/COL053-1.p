%--------------------------------------------------------------------------
% File     : COL053-1 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Combinatory Logic
% Problem  : An Exercise in Composition
% Version  : Especial.
% English  : For all birds x and y, there exists a bird z that composes
%            x with y for all birds w. Prove that for all birds x, y, and
%            z, there exists a bird u such that for all w, uw = x(y(zw)).

% Refs     : [Smu85] Smullyan (1978), To Mock a Mocking Bird and Other Logi
% Source   : [ANL]
% Names    : bird5.ver1.in [ANL]

% Status   : Unsatisfiable
% Rating   : 0.04 v9.1.0, 0.14 v9.0.0, 0.09 v8.2.0, 0.08 v8.1.0, 0.15 v7.5.0, 0.08 v7.4.0, 0.13 v7.3.0, 0.11 v7.1.0, 0.00 v6.4.0, 0.05 v6.3.0, 0.06 v6.2.0, 0.07 v6.1.0, 0.00 v6.0.0, 0.05 v5.5.0, 0.00 v2.0.0
% Syntax   : Number of clauses     :    2 (   2 unt;   0 nHn;   1 RR)
%            Number of literals    :    2 (   2 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   3 con; 0-2 aty)
%            Number of variables   :    4 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----For all birds x and y, there exists a bird z that composes x with
%----y for all birds w.
%----   FAx FAy TEz FAw [response(z,w) = response(x,response(y,w))].
%----   response(comp(x,y),w) = response(x,response(y,w)).
cnf(composer_exists,axiom,
    response(compose(X,Y),W) = response(X,response(Y,W)) ).

%----Hypothesis: For all birds x, y, and z, there exists a bird u such
%----that for all w, uw = x(y(zw)).
%----Finding clause (using xy to replace response(x,y)):
%----  - (FAx FAy FAz TEu FAw (uw = x(y(zw)))).
%----  TEx TEy TEz FAu TEw -(uw = x(y(zw))).
%----  Letting w = f(u), x = A, y = B, and z = C,
%----  -[(u)f(u) = A(B((C)f(u)))].
cnf(prove_bird_exists,negated_conjecture,
    response(U,f(U)) != response(a,response(b,response(c,f(U)))) ).

%--------------------------------------------------------------------------
