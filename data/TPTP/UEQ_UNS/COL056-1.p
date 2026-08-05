%--------------------------------------------------------------------------
% File     : COL056-1 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Combinatory Logic
% Problem  : Normal Birds
% Version  : Especial.
% English  : For all birds x and y, there exists a bird z that composes
%            x with y for all birds w. Prove that if there exists a happy
%            bird then there exists a normal bird.

% Refs     : [Smu85] Smullyan (1978), To Mock a Mocking Bird and Other Logi
% Source   : [ANL]
% Names    : bird8.ver1.in [ANL]

% Status   : Unsatisfiable
% Rating   : 0.04 v9.1.0, 0.09 v8.2.0, 0.08 v8.1.0, 0.00 v7.5.0, 0.04 v7.4.0, 0.09 v7.3.0, 0.05 v7.1.0, 0.06 v7.0.0, 0.05 v6.3.0, 0.06 v6.2.0, 0.07 v6.1.0, 0.06 v6.0.0, 0.05 v5.4.0, 0.07 v5.3.0, 0.08 v5.2.0, 0.07 v4.1.0, 0.09 v4.0.1, 0.07 v4.0.0, 0.08 v3.7.0, 0.11 v3.4.0, 0.12 v3.3.0, 0.07 v3.1.0, 0.00 v2.7.0, 0.09 v2.6.0, 0.17 v2.5.0, 0.00 v2.0.0
% Syntax   : Number of clauses     :    4 (   4 unt;   0 nHn;   3 RR)
%            Number of literals    :    4 (   4 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   1 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   3 con; 0-2 aty)
%            Number of variables   :    5 (   1 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----For all birds x and y, there exists a bird z that composes x with
%----y for all birds w.
%----   FAx FAy TEz FAw [response(z,w) = response(x,response(y,w))].
%----   response(comp(x,y),w) = response(x,response(y,w)).
cnf(composer_exists,axiom,
    response(compose(X,Y),W) = response(X,response(Y,W)) ).

%----Hypothesis: If there exists a happy bird then there exists a normal
%----bird.
%----Finding clause (using xy to replace response(x,y)):
%----   -[ If TEx TEy TEz (xy = z) and (xz = y)
%----      then TEw TEv (wv = v) ].
%----   -[ FAx FAy FAz -((xy = z) and (xz = y)) | TEw TEv (wv = v) ]
%----   TEx TEy TEz [(xy = z) and (xz = y)] and FAw FAv -(wv = v).
%----   (AB = C) and (AC = B) and -(wv = v).
cnf(a_to_b_responds_c,hypothesis,
    response(a,b) = c ).

cnf(a_to_c_responds_b,hypothesis,
    response(a,c) = b ).

cnf(prove_there_exists_a_happy_bird,negated_conjecture,
    response(W,V) != V ).

%--------------------------------------------------------------------------
