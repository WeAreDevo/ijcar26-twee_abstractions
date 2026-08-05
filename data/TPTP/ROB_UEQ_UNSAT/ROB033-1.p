%------------------------------------------------------------------------------
% File     : ROB033-1 : TPTP v9.2.1. Released v4.1.0.
% Domain   : Robbins Algebra
% Problem  : Robbins problem with auxilliary definitions
% Version  : Especial.
% English  :

% Refs     : [Sta09] Stanovsky (2009), Email to Geoff Sutcliffe
% Source   : [Sta09]
% Names    : robbins [Sta09]

% Status   : Unsatisfiable
% Rating   : 1.00 v4.1.0
% Syntax   : Number of clauses     :    6 (   6 unt;   0 nHn;   1 RR)
%            Number of literals    :    6 (   6 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   2 con; 0-2 aty)
%            Number of variables   :    9 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
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

%----Huntington
cnf(goals,negated_conjecture,
    add(negate(add(x0,negate(x1))),negate(add(negate(x0),negate(x1)))) != x1 ).

%------------------------------------------------------------------------------
