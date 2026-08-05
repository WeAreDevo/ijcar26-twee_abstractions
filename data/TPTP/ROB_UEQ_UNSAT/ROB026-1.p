%--------------------------------------------------------------------------
% File     : ROB026-1 : TPTP v9.2.1. Released v1.2.0.
% Domain   : Robbins Algebra
% Problem  : c + d = c => Boolean
% Version  : [Win90] (equality) axioms.
%            Theorem formulation : Denies Huntington's axiom.
% English  : If there are elements c and d such that c+d=d, then the
%            algebra is Boolean.

% Refs     : [HMT71] Henkin et al. (1971), Cylindrical Algebras
%          : [Win90] Winker (1990), Robbins Algebra: Conditions that make a
%          : [Wos94] Wos (1994), Two Challenge Problems
% Source   : [Wos94]
% Names    : - [Wos94]

% Status   : Unsatisfiable
% Rating   : 0.96 v9.1.0, 0.95 v9.0.0, 0.91 v8.2.0, 0.83 v8.1.0, 0.90 v7.5.0, 0.88 v7.4.0, 0.91 v7.3.0, 0.89 v6.4.0, 0.95 v6.3.0, 0.94 v6.2.0, 0.93 v6.1.0, 0.94 v6.0.0, 0.95 v5.4.0, 0.87 v5.3.0, 0.83 v5.2.0, 0.86 v5.1.0, 0.87 v5.0.0, 0.86 v4.1.0, 0.82 v4.0.1, 0.86 v4.0.0, 0.85 v3.7.0, 0.78 v3.4.0, 0.88 v3.3.0, 0.86 v3.1.0, 0.89 v2.7.0, 0.91 v2.6.0, 0.83 v2.5.0, 0.75 v2.4.0, 0.67 v2.3.0, 1.00 v2.0.0
% Syntax   : Number of clauses     :    5 (   5 unt;   0 nHn;   2 RR)
%            Number of literals    :    5 (   5 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    6 (   6 usr;   4 con; 0-2 aty)
%            Number of variables   :    7 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Commutativity, associativity, and Huntington's axiom
%            axiomatize Boolean algebra.
%--------------------------------------------------------------------------
%----Include axioms for Robbins algebra
include('Axioms/ROB001-0.ax').
%--------------------------------------------------------------------------
cnf(identity_constant,hypothesis,
    add(c,d) = c ).

cnf(prove_huntingtons_axiom,negated_conjecture,
    add(negate(add(a,negate(b))),negate(add(negate(a),negate(b)))) != b ).

%--------------------------------------------------------------------------
