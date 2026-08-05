%------------------------------------------------------------------------------
% File     : GRP750-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : Simplifying a basis for trimedial quasigroups: part 2
% Version  : Especial.
% English  :

% Refs     : [KP02]  Kinyon & Phillips (2002), A Note on Trimedial Quasigro
%          : [Sta08] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08]
% Names    : KP02_2 [Sta08]

% Status   : Unsatisfiable
% Rating   : 0.26 v9.1.0, 0.27 v9.0.0, 0.32 v8.2.0, 0.29 v8.1.0, 0.30 v7.5.0, 0.46 v7.4.0, 0.57 v7.3.0, 0.53 v7.1.0, 0.44 v7.0.0, 0.37 v6.4.0, 0.47 v6.2.0, 0.36 v6.1.0, 0.44 v6.0.0, 0.48 v5.5.0, 0.58 v5.4.0, 0.47 v5.3.0, 0.42 v5.2.0, 0.43 v5.1.0, 0.47 v5.0.0, 0.50 v4.1.0, 0.55 v4.0.1, 0.57 v4.0.0
% Syntax   : Number of clauses     :    7 (   7 unt;   0 nHn;   1 RR)
%            Number of literals    :    7 (   7 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   3 con; 0-2 aty)
%            Number of variables   :   14 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%------------------------------------------------------------------------------
cnf(f01,axiom,
    mult(A,ld(A,B)) = B ).

cnf(f02,axiom,
    ld(A,mult(A,B)) = B ).

cnf(f03,axiom,
    mult(rd(A,B),B) = A ).

cnf(f04,axiom,
    rd(mult(A,B),B) = A ).

cnf(f05,axiom,
    mult(mult(A,mult(A,A)),mult(B,C)) = mult(mult(A,B),mult(mult(A,A),C)) ).

cnf(f06,axiom,
    mult(mult(A,B),mult(C,C)) = mult(mult(A,C),mult(B,C)) ).

cnf(goals,negated_conjecture,
    mult(mult(a,a),mult(b,c)) != mult(mult(a,b),mult(a,c)) ).

%------------------------------------------------------------------------------
