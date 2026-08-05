%------------------------------------------------------------------------------
% File     : GRP706-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : Every F-quasigroup is isotopic to a Moufang loop
% Version  : Especial.
% English  :

% Refs     : [KKP07] Kepka et al. (2007), The Structure of F-Quasigroups
%          : [PS08]  Phillips & Stanovsky (2008), Automated Theorem Proving
%          : [Sta08] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08]
% Names    : KKP07 [PS08]

% Status   : Unsatisfiable
% Rating   : 0.87 v9.1.0, 0.91 v9.0.0, 0.86 v8.2.0, 0.88 v8.1.0, 0.90 v7.5.0, 0.92 v7.4.0, 0.91 v7.3.0, 0.95 v7.1.0, 0.89 v7.0.0, 0.84 v6.3.0, 0.82 v6.2.0, 0.79 v6.1.0, 0.88 v6.0.0, 0.90 v5.5.0, 0.95 v5.4.0, 0.93 v5.3.0, 0.92 v5.2.0, 0.93 v4.1.0, 1.00 v4.0.0
% Syntax   : Number of clauses     :    8 (   8 unt;   0 nHn;   1 RR)
%            Number of literals    :    8 (   8 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   4 con; 0-2 aty)
%            Number of variables   :   16 (   0 sgn)
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
    mult(A,mult(B,C)) = mult(mult(A,B),mult(ld(A,A),C)) ).

cnf(c06,axiom,
    mult(mult(A,B),C) = mult(mult(A,rd(C,C)),mult(B,C)) ).

cnf(c07,axiom,
    f(A,B) = mult(rd(A,op_c),ld(op_c,B)) ).

cnf(goals,negated_conjecture,
    f(a,f(b,f(a,c))) != f(f(f(a,b),a),c) ).

%------------------------------------------------------------------------------
