%--------------------------------------------------------------------------
% File     : COL059-1 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Combinatory Logic
% Problem  : L3 ((lark lark) lark) is not egocentric.
% Version  : Especial.
% English  :

% Refs     : [Smu85] Smullyan (1978), To Mock a Mocking Bird and Other Logi
%          : [GO86]  Glickfield & Overbeek (1986), A Foray into Combinatory
% Source   : [GO86]
% Names    : - [GO86]

% Status   : Unsatisfiable
% Rating   : 0.00 v7.4.0, 0.13 v7.3.0, 0.00 v7.0.0, 0.05 v6.3.0, 0.06 v6.2.0, 0.07 v6.1.0, 0.06 v6.0.0, 0.19 v5.5.0, 0.16 v5.4.0, 0.00 v5.2.0, 0.07 v5.1.0, 0.00 v4.0.1, 0.07 v4.0.0, 0.08 v3.7.0, 0.00 v2.2.1, 0.22 v2.2.0, 0.29 v2.1.0, 0.25 v2.0.0
% Syntax   : Number of clauses     :    8 (   8 unt;   0 nHn;   4 RR)
%            Number of literals    :    8 (   8 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   5 con; 0-2 aty)
%            Number of variables   :    8 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%---- There exists a kestrel
cnf(kestrel_exists,axiom,
    response(response(kestrel,X1),X2) = X1 ).

%---- There exists a lark
cnf(lark_exists,axiom,
    response(response(lark,X1),X2) = response(X1,response(X2,X2)) ).

cnf(lark_lemma1,axiom,
    response(response(response(lark,lark),X1),X2) = response(response(X1,X1),response(X2,X2)) ).

cnf(lark_lemma2,axiom,
    response(response(response(response(lark,lark),lark),X1),X2) = response(response(response(X1,X1),response(X1,X1)),response(x2,x2)) ).

cnf(lark_not_egocentric,axiom,
    response(l2,l2) != l2 ).

cnf(l2_definition,axiom,
    response(lark,lark) = l2 ).

cnf(l3_definition,axiom,
    response(l2,lark) = l3 ).

cnf(prove_l3_not_egocentric,negated_conjecture,
    response(l3,l3) = l3 ).

%--------------------------------------------------------------------------
