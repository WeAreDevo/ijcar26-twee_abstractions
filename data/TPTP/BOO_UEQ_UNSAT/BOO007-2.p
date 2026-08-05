%--------------------------------------------------------------------------
% File     : BOO007-2 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Boolean Algebra
% Problem  : Product is associative ( (X * Y) * Z = X * (Y * Z) )
% Version  : [ANL] (equality) axioms.
% English  :

% Refs     : [Ver92] Veroff (1992), Email to G. Sutcliffe
% Source   : [Ver92]
% Names    : associativity [Ver92]

% Status   : Unsatisfiable
% Rating   : 0.09 v9.1.0, 0.18 v9.0.0, 0.14 v8.2.0, 0.21 v8.1.0, 0.30 v7.5.0, 0.25 v7.4.0, 0.35 v7.3.0, 0.26 v7.1.0, 0.17 v7.0.0, 0.16 v6.4.0, 0.21 v6.3.0, 0.24 v6.2.0, 0.29 v6.1.0, 0.38 v6.0.0, 0.52 v5.5.0, 0.47 v5.4.0, 0.33 v5.3.0, 0.25 v5.2.0, 0.29 v5.1.0, 0.27 v5.0.0, 0.21 v4.1.0, 0.27 v4.0.1, 0.21 v4.0.0, 0.15 v3.7.0, 0.22 v3.4.0, 0.25 v3.3.0, 0.21 v3.2.0, 0.14 v3.1.0, 0.00 v2.7.0, 0.18 v2.6.0, 0.17 v2.5.0, 0.00 v2.2.1, 0.44 v2.2.0, 0.57 v2.1.0, 0.75 v2.0.0
% Syntax   : Number of clauses     :   15 (  15 unt;   0 nHn;   1 RR)
%            Number of literals    :   15 (  15 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    3 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    8 (   8 usr;   5 con; 0-2 aty)
%            Number of variables   :   24 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Include boolean algebra axioms for equality formulation
include('Axioms/BOO003-0.ax').
%--------------------------------------------------------------------------
cnf(prove_associativity,negated_conjecture,
    multiply(a,multiply(b,c)) != multiply(multiply(a,b),c) ).

%--------------------------------------------------------------------------
