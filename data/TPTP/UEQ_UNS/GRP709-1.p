%------------------------------------------------------------------------------
% File     : GRP709-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : Bol loop commutant element squared in left and right nucleus - 2
% Version  : Especial.
% English  :

% Refs     : [KPV08] Kinyon et al. (2008), When is the Commutant of a Bol L
%          : [PS08]  Phillips & Stanovsky (2008), Automated Theorem Proving
%          : [Sta08] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08]
% Names    : KPV08 [PS08]

% Status   : Unsatisfiable
% Rating   : 0.04 v9.1.0, 0.14 v9.0.0, 0.09 v8.2.0, 0.12 v8.1.0, 0.20 v7.5.0, 0.21 v7.4.0, 0.30 v7.3.0, 0.21 v7.1.0, 0.11 v7.0.0, 0.21 v6.4.0, 0.32 v6.3.0, 0.29 v6.2.0, 0.36 v6.1.0, 0.25 v6.0.0, 0.43 v5.5.0, 0.37 v5.4.0, 0.13 v5.3.0, 0.17 v5.2.0, 0.21 v5.1.0, 0.27 v5.0.0, 0.14 v4.1.0, 0.09 v4.0.1, 0.50 v4.0.0
% Syntax   : Number of clauses     :   10 (  10 unt;   0 nHn;   1 RR)
%            Number of literals    :   10 (  10 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   4 con; 0-2 aty)
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
    mult(A,unit) = A ).

cnf(c06,axiom,
    mult(unit,A) = A ).

cnf(c07,axiom,
    mult(A,mult(B,mult(A,C))) = mult(mult(A,mult(B,A)),C) ).

cnf(c08,axiom,
    mult(op_c,A) = mult(A,op_c) ).

cnf(c09,axiom,
    mult(A,mult(B,op_c)) = mult(mult(A,B),op_c) ).

cnf(goals,negated_conjecture,
    mult(mult(op_c,op_c),mult(a,b)) != mult(mult(mult(op_c,op_c),a),b) ).

%------------------------------------------------------------------------------
