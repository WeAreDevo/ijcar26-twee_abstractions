%------------------------------------------------------------------------------
% File     : ALG243-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Algebra (Non-associative)
% Problem  : Idempotent selfdistributive groupoids are symmetric-by-medial - 2
% Version  : Especial.
% English  :

% Refs     : [PS08]  Phillips & Stanovsky (2008), Using Automated Theorem P
%          : [Sta08a] Stanovsky (2008), Distributive Groupoids are Symmetri
%          : [Sta08b] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08b]
% Names    : S08_7 [Sta08b]

% Status   : Unsatisfiable
% Rating   : 1.00 v4.0.0
% Syntax   : Number of clauses     :    4 (   4 unt;   0 nHn;   1 RR)
%            Number of literals    :    4 (   4 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   4 con; 0-2 aty)
%            Number of variables   :    7 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%------------------------------------------------------------------------------
cnf(c01,axiom,
    mult(A,mult(B,C)) = mult(mult(A,B),mult(A,C)) ).

cnf(c02,axiom,
    mult(mult(A,B),C) = mult(mult(A,C),mult(B,C)) ).

cnf(c03,axiom,
    mult(A,A) = A ).

cnf(goals,negated_conjecture,
    mult(mult(mult(a,b),mult(c,d)),mult(mult(mult(a,b),mult(c,d)),mult(mult(a,c),mult(b,d)))) != mult(mult(a,c),mult(b,d)) ).

%------------------------------------------------------------------------------
