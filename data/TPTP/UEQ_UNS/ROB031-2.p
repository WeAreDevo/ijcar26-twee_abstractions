%------------------------------------------------------------------------------
% File     : ROB031-2 : TPTP v9.2.1. Released v4.1.0.
% Domain   : Robbins Algebra
% Problem  : Robbins => Exists absorbed within negation element
% Version  : Especial.
% English  :

% Refs     : [Sta09] Stanovsky (2009), Email to Geoff Sutcliffe
% Source   : [Sta09]
% Names    : robbins [Sta09]

% Status   : Unsatisfiable
% Rating   : 0.96 v9.1.0, 0.95 v8.2.0, 0.96 v8.1.0, 1.00 v7.5.0, 0.96 v7.3.0, 0.95 v7.1.0, 0.94 v7.0.0, 0.95 v6.3.0, 0.94 v6.2.0, 0.93 v6.1.0, 0.94 v6.0.0, 0.95 v5.4.0, 0.93 v5.3.0, 0.92 v5.2.0, 0.93 v4.1.0
% Syntax   : Number of clauses     :    6 (   6 unt;   0 nHn;   1 RR)
%            Number of literals    :    6 (   6 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    4 (   4 usr;   0 con; 1-2 aty)
%            Number of variables   :   11 (   1 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : With auxilliary definitions.
%------------------------------------------------------------------------------
%----Include axioms for Robbins algebra
include('Axioms/ROB001-0.ax').
%------------------------------------------------------------------------------
%----Definition of g
cnf(sos04,axiom,
    g(A) = negate(add(A,negate(A))) ).

%----Definition of h
cnf(sos05,axiom,
    h(A) = add(A,add(A,add(A,g(A)))) ).

%----Winker2a
cnf(goals,negated_conjecture,
    negate(add(X6,X7)) != negate(X6) ).

%------------------------------------------------------------------------------
