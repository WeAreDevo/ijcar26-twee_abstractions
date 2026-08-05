%------------------------------------------------------------------------------
% File     : GRP720-2 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : In commutative A-loops, squares form a subloop
% Version  : Especial.
% English  :

% Refs     : [Sta08] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08]
% Names    : JKVxx_1alt1 [Sta08]

% Status   : Unsatisfiable
% Rating   : 0.74 v9.1.0, 0.73 v9.0.0, 0.77 v8.2.0, 0.83 v8.1.0, 0.85 v7.5.0, 0.88 v7.4.0, 0.83 v7.3.0, 0.84 v7.2.0, 0.79 v7.1.0, 0.78 v7.0.0, 0.79 v6.3.0, 0.71 v6.2.0, 0.64 v6.1.0, 0.88 v6.0.0, 0.90 v5.5.0, 0.89 v5.4.0, 0.87 v5.3.0, 0.83 v5.2.0, 0.79 v5.1.0, 0.80 v5.0.0, 0.86 v4.1.0, 0.82 v4.0.1, 0.86 v4.0.0
% Syntax   : Number of clauses     :    8 (   8 unt;   0 nHn;   1 RR)
%            Number of literals    :    8 (   8 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   3 con; 0-2 aty)
%            Number of variables   :   16 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%------------------------------------------------------------------------------
cnf(c01,axiom,
    mult(A,unit) = A ).

cnf(c02,axiom,
    mult(unit,A) = A ).

cnf(c03,axiom,
    mult(A,ld(A,B)) = B ).

cnf(c04,axiom,
    ld(A,mult(A,B)) = B ).

cnf(c05,axiom,
    mult(A,B) = mult(B,A) ).

cnf(c06,axiom,
    ld(mult(A,B),mult(A,mult(B,mult(C,D)))) = mult(ld(mult(A,B),mult(A,mult(B,C))),ld(mult(A,B),mult(A,mult(B,D)))) ).

cnf(c07,axiom,
    ld(A,mult(mult(B,C),A)) = mult(ld(A,mult(B,A)),ld(A,mult(C,A))) ).

cnf(c08,axiom,
    mult(mult(op_a,op_a),mult(op_b,op_b)) != mult(A,A) ).

%------------------------------------------------------------------------------
