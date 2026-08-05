%------------------------------------------------------------------------------
% File     : ALG213-10 : TPTP v9.2.1. Released v8.1.0.
% Domain   : General Algebra (Median Algebra)
% Problem  : Distributivity, short version
% Version  : [VMURL] axioms.
% English  :

% Refs     : [VMURL] Veroff & McCune (URL), First-order Proof of a Median A
%          : [Sma21] Smallbone (2021), Email to Geoff Sutcliffe
% Source   : [Sma21]
% Names    : 

% Status   : Unsatisfiable
% Rating   : 0.96 v9.1.0, 0.95 v9.0.0, 1.00 v8.2.0, 0.96 v8.1.0, 1.00 v3.2.0
% Syntax   : Number of clauses     :    5 (   5 unt;   0 nHn;   1 RR)
%            Number of literals    :    5 (   5 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   1 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   5 con; 0-3 aty)
%            Number of variables   :   12 (   1 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : UEQ version, converted from ALG213+1.p
%------------------------------------------------------------------------------
%----Include median algebra axioms
include('Axioms/ALG002-0.ax').
%------------------------------------------------------------------------------
cnf(dist_long,negated_conjecture,
    f(f(x,y,z),u,w) != f(x,f(y,u,w),f(z,u,w)) ).

%------------------------------------------------------------------------------
