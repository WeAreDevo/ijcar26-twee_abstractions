%------------------------------------------------------------------------------
% File     : ALG240-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Algebra (Non-associative)
% Problem  : Selfdistributive groupoids are symmetric-by-medial - part 4
% Version  : Especial.
% English  :

% Refs     : [PS08]  Phillips & Stanovsky (2008), Using Automated Theorem P
%          : [Sta08a] Stanovsky (2008), Distributive Groupoids are Symmetri
%          : [Sta08b] Stanovsky (2008), Email to G. Sutcliffe
%          : [Sta08c] Stanovsky (2008), Distributive Groupoids are Symmetric
% Source   : [Sta08b]
% Names    : S08_4 [Sta08b]

% Status   : Unsatisfiable
% Rating   : 0.35 v9.1.0, 0.32 v9.0.0, 0.36 v8.2.0, 0.42 v8.1.0, 0.40 v7.5.0, 0.50 v7.4.0, 0.48 v7.3.0, 0.42 v7.1.0, 0.44 v7.0.0, 0.47 v6.4.0, 0.53 v6.2.0, 0.50 v6.1.0, 0.56 v6.0.0, 0.67 v5.5.0, 0.68 v5.4.0, 0.60 v5.3.0, 0.58 v5.2.0, 0.57 v5.1.0, 0.60 v5.0.0, 0.57 v4.1.0, 0.45 v4.0.1, 0.64 v4.0.0
% Syntax   : Number of clauses     :    5 (   5 unt;   0 nHn;   1 RR)
%            Number of literals    :    5 (   5 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   4 con; 0-2 aty)
%            Number of variables   :   14 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%------------------------------------------------------------------------------
cnf(c01,axiom,
    mult(A,mult(B,C)) = mult(mult(A,B),mult(A,C)) ).

cnf(c02,axiom,
    mult(mult(A,B),C) = mult(mult(A,C),mult(B,C)) ).

cnf(c03,axiom,
    mult(mult(mult(A,B),mult(C,D)),mult(mult(mult(A,B),mult(C,D)),mult(mult(A,C),mult(B,D)))) = mult(mult(A,C),mult(B,D)) ).

cnf(c04,axiom,
    mult(mult(mult(mult(A,B),mult(C,D)),mult(mult(A,C),mult(B,D))),mult(mult(A,C),mult(B,D))) = mult(mult(A,B),mult(C,D)) ).

cnf(goals,negated_conjecture,
    mult(mult(mult(a,b),mult(c,d)),mult(mult(a,c),mult(b,d))) != mult(mult(mult(a,c),mult(b,d)),mult(mult(a,b),mult(c,d))) ).

%------------------------------------------------------------------------------
