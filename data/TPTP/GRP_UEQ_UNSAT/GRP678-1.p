%------------------------------------------------------------------------------
% File     : GRP678-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : In CC-loops, associators are in the center of the nucleus - 2
% Version  : Especial.
% English  :

% Refs     : [KKP04] Kinyon et al. (2004), Diassociativity in Conjugacy Clo
%          : [PS08]  Phillips & Stanovsky (2008), Automated Theorem Proving
%          : [Sta08] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08]
% Names    : KKP04 [PS08]

% Status   : Unsatisfiable
% Rating   : 0.91 v9.1.0, 0.95 v8.2.0, 0.92 v8.1.0, 0.95 v7.5.0, 0.88 v7.4.0, 0.96 v7.3.0, 0.95 v7.2.0, 0.89 v7.1.0, 0.94 v7.0.0, 0.95 v6.3.0, 0.94 v6.2.0, 0.86 v6.1.0, 1.00 v4.0.0
% Syntax   : Number of clauses     :   13 (  13 unt;   0 nHn;   1 RR)
%            Number of literals    :   13 (  13 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    9 (   9 usr;   5 con; 0-3 aty)
%            Number of variables   :   25 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%------------------------------------------------------------------------------
cnf(c01,axiom,
    mult(A,ld(A,B)) = B ).

cnf(c02,axiom,
    ld(A,mult(A,B)) = B ).

cnf(c03,axiom,
    mult(rd(A,B),B) = A ).

cnf(c04,axiom,
    rd(mult(A,B),B) = A ).

cnf(c05,axiom,
    mult(A,unit) = A ).

cnf(c06,axiom,
    mult(unit,A) = A ).

cnf(c07,axiom,
    mult(A,mult(B,C)) = mult(rd(mult(A,B),A),mult(A,C)) ).

cnf(c08,axiom,
    mult(mult(A,B),C) = mult(mult(A,C),ld(C,mult(B,C))) ).

cnf(c09,axiom,
    asoc(A,B,C) = ld(mult(A,mult(B,C)),mult(mult(A,B),C)) ).

cnf(c10,axiom,
    mult(op_c,mult(A,B)) = mult(mult(op_c,A),B) ).

cnf(c11,axiom,
    mult(A,mult(op_c,B)) = mult(mult(A,op_c),B) ).

cnf(c12,axiom,
    mult(A,mult(B,op_c)) = mult(mult(A,B),op_c) ).

cnf(goals,negated_conjecture,
    mult(asoc(a,b,c),op_c) != mult(op_c,asoc(a,b,c)) ).

%------------------------------------------------------------------------------
