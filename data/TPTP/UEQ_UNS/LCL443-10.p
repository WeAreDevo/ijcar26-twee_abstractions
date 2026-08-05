%------------------------------------------------------------------------------
% File     : LCL443-10 : TPTP v9.2.1. Released v7.3.0.
% Domain   : Puzzles
% Problem  : Problem about propositional logic
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.09 v9.1.0, 0.14 v8.2.0, 0.17 v8.1.0, 0.15 v7.5.0, 0.21 v7.4.0, 0.17 v7.3.0
% Syntax   : Number of clauses     :    9 (   9 unt;   0 nHn;   3 RR)
%            Number of literals    :    9 (   9 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   12 (  12 usr;   6 con; 0-4 aty)
%            Number of variables   :   21 (   3 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from LCL443-2 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(ifeq_axiom,axiom,
    ifeq(A,A,B,C) = B ).

cnf(cls_PropLog_Othms_OMP_0,axiom,
    ifeq(c_in(c_PropLog_Opl_Oop_A_N_62(V_p,V_q,T_a),c_PropLog_Othms(V_H,T_a),tc_PropLog_Opl(T_a)),true,ifeq(c_in(V_p,c_PropLog_Othms(V_H,T_a),tc_PropLog_Opl(T_a)),true,c_in(V_q,c_PropLog_Othms(V_H,T_a),tc_PropLog_Opl(T_a)),true),true) = true ).

cnf(cls_PropLog_Odeduction_0,axiom,
    ifeq(c_in(V_q,c_PropLog_Othms(c_insert(V_p,V_H,tc_PropLog_Opl(T_a)),T_a),tc_PropLog_Opl(T_a)),true,c_in(c_PropLog_Opl_Oop_A_N_62(V_p,V_q,T_a),c_PropLog_Othms(V_H,T_a),tc_PropLog_Opl(T_a)),true) = true ).

cnf(cls_PropLog_Othms_OH_0,axiom,
    ifeq(c_in(V_p,V_H,tc_PropLog_Opl(T_a)),true,c_in(V_p,c_PropLog_Othms(V_H,T_a),tc_PropLog_Opl(T_a)),true) = true ).

cnf(cls_PropLog_Oweaken__left__insert_0,axiom,
    ifeq(c_in(V_p,c_PropLog_Othms(V_G,T_a),tc_PropLog_Opl(T_a)),true,c_in(V_p,c_PropLog_Othms(c_insert(V_a,V_G,tc_PropLog_Opl(T_a)),T_a),tc_PropLog_Opl(T_a)),true) = true ).

cnf(cls_Set_OinsertCI_1,axiom,
    c_in(V_x,c_insert(V_x,V_B,T_a),T_a) = true ).

cnf(cls_conjecture_0,negated_conjecture,
    c_in(v_p,c_PropLog_Othms(v_H,t_a),tc_PropLog_Opl(t_a)) = true ).

cnf(cls_conjecture_1,negated_conjecture,
    c_in(c_PropLog_Opl_Oop_A_N_62(v_q,c_PropLog_Opl_Ofalse,t_a),c_PropLog_Othms(v_H,t_a),tc_PropLog_Opl(t_a)) = true ).

cnf(cls_conjecture_2,negated_conjecture,
    c_in(c_PropLog_Opl_Oop_A_N_62(c_PropLog_Opl_Oop_A_N_62(v_p,v_q,t_a),c_PropLog_Opl_Ofalse,t_a),c_PropLog_Othms(v_H,t_a),tc_PropLog_Opl(t_a)) != true ).

%------------------------------------------------------------------------------
