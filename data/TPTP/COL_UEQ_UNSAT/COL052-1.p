%--------------------------------------------------------------------------
% File     : COL052-1 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Combinatory Logic
% Problem  : A Question on Agreeable Birds
% Version  : Especial.
%            Theorem formulation : Implicit definition of agreeable.
% English  : For all birds x and y, there exists a bird z that composes
%            x with y for all birds w. Prove that if C is agreeable then
%            A is agreeable.

% Refs     : [Smu85] Smullyan (1978), To Mock a Mocking Bird and Other Logi
% Source   : [ANL]
% Names    : bird4.ver1.in [ANL]

% Status   : Unsatisfiable
% Rating   : 0.04 v9.1.0, 0.14 v9.0.0, 0.09 v8.2.0, 0.17 v8.1.0, 0.20 v7.5.0, 0.21 v7.4.0, 0.26 v7.3.0, 0.16 v7.1.0, 0.06 v7.0.0, 0.05 v6.4.0, 0.16 v6.3.0, 0.06 v6.2.0, 0.00 v6.0.0, 0.10 v5.5.0, 0.05 v5.4.0, 0.00 v5.1.0, 0.07 v5.0.0, 0.00 v4.0.1, 0.07 v4.0.0, 0.08 v3.7.0, 0.00 v2.0.0
% Syntax   : Number of clauses     :    4 (   4 unt;   0 nHn;   2 RR)
%            Number of literals    :    4 (   4 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   4 con; 0-2 aty)
%            Number of variables   :    5 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----For all birds x and y, there exists a bird z that composes x with
%----y for all birds w.
%----   FAx FAy TEz FAw [response(z,w) = response(x,response(y,w))].
%----   response(comp(x,y),w) = response(x,response(y,w)).
cnf(composer_exists,axiom,
    response(compose(X,Y),W) = response(X,response(Y,W)) ).

%----Hypothesis: If C is agreeable then A is agreeable.
%----   -[ If FAx TEy (response(C,y) = response(x,y)),
%----      then FAw TEv (response(A,v) = response(w,v)) ].
%----   -[ TEx FAy -(response(C,y) = response(x,y)) |
%----      FAw TEv (response(A,v) = response(w,v)) ].
%----   FAx TEy (response(C,y) = response(x,y)) and
%----      TEw FAv -(response(A,v) = response(w,v).
%----   response(C,commom_bird(x)) = response(x,common_bird(x)) and
%----      -(response(A,v) = response(odd_bird,v)).
cnf(agreeable1,hypothesis,
    response(c,common_bird(X)) = response(X,common_bird(X)) ).

cnf(prove_a_is_agreeable,negated_conjecture,
    response(a,V) != response(odd_bird,V) ).

%----C composes A with B. WHY is this here?
cnf(c_composes_a_with_b,hypothesis,
    c = compose(a,b) ).

%--------------------------------------------------------------------------
