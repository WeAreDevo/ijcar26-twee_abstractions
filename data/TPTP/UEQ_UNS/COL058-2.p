%--------------------------------------------------------------------------
% File     : COL058-2 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Combinatory Logic
% Problem  : If there's a lark, then there's an egocentric bird.
% Version  : Especial.
%            Theorem formulation : The egocentric bird is provided and
%            checked.
% English  : Suppose we are given a forest that contains a lark, and
%            we are not given any other information. Prove that at least
%            one bird in the forest must be egocentric.

% Refs     : [Smu85] Smullyan (1978), To Mock a Mocking Bird and Other Logi
%          : [GO86]  Glickfield & Overbeek (1986), A Foray into Combinatory
% Source   : [GO86]
% Names    : - [GO86]

% Status   : Unsatisfiable
% Rating   : 0.00 v8.1.0, 0.05 v7.5.0, 0.04 v7.4.0, 0.09 v7.3.0, 0.05 v7.1.0, 0.00 v6.3.0, 0.06 v6.2.0, 0.07 v6.1.0, 0.06 v6.0.0, 0.10 v5.5.0, 0.05 v5.4.0, 0.07 v5.3.0, 0.00 v2.2.1, 0.11 v2.2.0, 0.14 v2.1.0, 0.00 v2.0.0
% Syntax   : Number of clauses     :    2 (   2 unt;   0 nHn;   1 RR)
%            Number of literals    :    2 (   2 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    7 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    2 (   2 usr;   1 con; 0-2 aty)
%            Number of variables   :    2 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%---- There exists a lark
cnf(lark_exists,axiom,
    response(response(lark,X1),X2) = response(X1,response(X2,X2)) ).

%---- Hypothesis: This bird is egocentric
cnf(prove_the_bird_exists,negated_conjecture,
    response(response(response(lark,response(response(lark,response(lark,lark)),response(lark,response(lark,lark)))),response(lark,response(lark,lark))),response(response(lark,response(response(lark,response(lark,lark)),response(lark,response(lark,lark)))),response(lark,response(lark,lark)))) != response(response(lark,response(response(lark,response(lark,lark)),response(lark,response(lark,lark)))),response(lark,response(lark,lark))) ).

%--------------------------------------------------------------------------
