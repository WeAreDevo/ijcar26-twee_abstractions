%------------------------------------------------------------------------------
% File     : LAT268-10 : TPTP v9.2.1. Released v7.5.0.
% Domain   : Puzzles
% Problem  : Problem about Tarski's fixed point theorem
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.09 v9.1.0, 0.14 v8.2.0, 0.12 v8.1.0, 0.10 v7.5.0
% Syntax   : Number of clauses     :   12 (  12 unt;   0 nHn;   7 RR)
%            Number of literals    :   12 (  12 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    8 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   22 (  22 usr;  10 con; 0-4 aty)
%            Number of variables   :   16 (   1 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Converted from LAT268-2 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(ifeq_axiom,axiom,
    ifeq(A,A,B,C) = B ).

cnf(cls_conjecture_0,negated_conjecture,
    c_lessequals(v_S,v_A,tc_set(t_a)) = true ).

cnf(cls_conjecture_1,negated_conjecture,
    c_in(v_x,v_S,t_a) = true ).

cnf(cls_conjecture_2,negated_conjecture,
    c_in(c_Pair(c_Tarski_Oglb(v_S,v_cl,t_a),v_x,t_a,t_a),v_r,tc_prod(t_a,t_a)) != true ).

cnf(cls_Tarski_OA_A_61_61_Apset_Acl_0,axiom,
    v_A = c_Tarski_Opotype_Opset(v_cl,t_a,tc_Product__Type_Ounit) ).

cnf(cls_Tarski_OCL_Olub__upper_0,axiom,
    ifeq(c_lessequals(V_S,c_Tarski_Opotype_Opset(V_cl,T_a,tc_Product__Type_Ounit),tc_set(T_a)),true,ifeq(c_in(V_cl,c_Tarski_OCompleteLattice,tc_Tarski_Opotype_Opotype__ext__type(T_a,tc_Product__Type_Ounit)),true,ifeq(c_in(V_cl,c_Tarski_OPartialOrder,tc_Tarski_Opotype_Opotype__ext__type(T_a,tc_Product__Type_Ounit)),true,ifeq(c_in(V_x,V_S,T_a),true,c_in(c_Pair(V_x,c_Tarski_Olub(V_S,V_cl,T_a),T_a,T_a),c_Tarski_Opotype_Oorder(V_cl,T_a,tc_Product__Type_Ounit),tc_prod(T_a,T_a)),true),true),true),true) = true ).

cnf(cls_Tarski_O_Ix1_M_Ay1_J_A_58_Aorder_A_Idual_Acl_J_A_61_61_A_Iy1_M_Ax1_J_A_58_Aorder_Acl_0,axiom,
    ifeq(c_in(c_Pair(V_x,V_y,T_a,T_a),c_Tarski_Opotype_Oorder(c_Tarski_Odual(V_cl,T_a),T_a,tc_Product__Type_Ounit),tc_prod(T_a,T_a)),true,c_in(c_Pair(V_y,V_x,T_a,T_a),c_Tarski_Opotype_Oorder(V_cl,T_a,tc_Product__Type_Ounit),tc_prod(T_a,T_a)),true) = true ).

cnf(cls_Tarski_Odual_Acl_A_58_ACompleteLattice_0,axiom,
    c_in(c_Tarski_Odual(v_cl,t_a),c_Tarski_OCompleteLattice,tc_Tarski_Opotype_Opotype__ext__type(t_a,tc_Product__Type_Ounit)) = true ).

cnf(cls_Tarski_Odual_Acl_A_58_APartialOrder_0,axiom,
    c_in(c_Tarski_Odual(v_cl,t_a),c_Tarski_OPartialOrder,tc_Tarski_Opotype_Opotype__ext__type(t_a,tc_Product__Type_Ounit)) = true ).

cnf(cls_Tarski_Oglb__dual__lub_0,axiom,
    c_Tarski_Oglb(V_S,V_cl,T_a) = c_Tarski_Olub(V_S,c_Tarski_Odual(V_cl,T_a),T_a) ).

cnf(cls_Tarski_Opset_A_Idual_Acl_J_A_61_61_Apset_Acl_0,axiom,
    c_Tarski_Opotype_Opset(c_Tarski_Odual(V_cl,T_a),T_a,tc_Product__Type_Ounit) = c_Tarski_Opotype_Opset(V_cl,T_a,tc_Product__Type_Ounit) ).

cnf(cls_Tarski_Or_A_61_61_Aorder_Acl_0,axiom,
    v_r = c_Tarski_Opotype_Oorder(v_cl,t_a,tc_Product__Type_Ounit) ).

%------------------------------------------------------------------------------
