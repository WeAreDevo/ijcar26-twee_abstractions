%------------------------------------------------------------------------------
% File     : GRP753-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : A new basis for trimedial quasigroups: part 2a
% Version  : Especial.
% English  :

% Refs     : [KP04]  Kinyon & Phillips (2004), Axioms for Trimedial Quasigr
%          : [Sta08] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08]
% Names    : KP04b_2a [Sta08]

% Status   : Unsatisfiable
% Rating   : 0.74 v9.1.0, 0.77 v9.0.0, 0.82 v8.2.0, 0.71 v8.1.0, 0.80 v7.5.0, 0.83 v7.3.0, 0.89 v7.1.0, 0.83 v7.0.0, 0.84 v6.3.0, 0.82 v6.2.0, 0.79 v6.1.0, 0.88 v6.0.0, 0.86 v5.5.0, 0.89 v5.4.0, 0.80 v5.3.0, 0.75 v5.2.0, 0.79 v5.1.0, 0.80 v5.0.0, 0.79 v4.1.0, 0.73 v4.0.1, 0.79 v4.0.0
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
    mult(A,mult(B,C)) = mult(mult(rd(A,A),B),mult(A,C)) ).

cnf(f06,axiom,
    mult(mult(A,B),C) = mult(mult(A,C),mult(B,ld(C,C))) ).

cnf(goals,negated_conjecture,
    mult(mult(a,mult(a,a)),mult(b,c)) != mult(mult(a,b),mult(mult(a,a),c)) ).

%------------------------------------------------------------------------------
