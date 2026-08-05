%--------------------------------------------------------------------------
% File     : BOO034-1 : TPTP v9.2.1. Released v2.2.0.
% Domain   : Boolean Algebra (Ternary)
% Problem  : Ternary Boolean Algebra Single axiom is sound.
% Version  : [MP96] (equality) axioms.
% English  : We show that that an equation (which turns out to be a single
%            axiom for TBA) can be derived from the axioms of TBA.

% Refs     : [McC98] McCune (1998), Email to G. Sutcliffe
%          : [MP96]  McCune & Padmanabhan (1996), Automated Deduction in Eq
% Source   : [McC98]
% Names    : TBA-1-a [MP96]

% Status   : Unsatisfiable
% Rating   : 0.17 v9.1.0, 0.23 v8.2.0, 0.29 v8.1.0, 0.30 v7.5.0, 0.29 v7.4.0, 0.39 v7.3.0, 0.32 v7.1.0, 0.22 v7.0.0, 0.26 v6.4.0, 0.32 v6.3.0, 0.29 v6.1.0, 0.25 v6.0.0, 0.43 v5.5.0, 0.42 v5.4.0, 0.27 v5.3.0, 0.17 v5.2.0, 0.21 v5.1.0, 0.20 v5.0.0, 0.21 v4.1.0, 0.27 v4.0.1, 0.21 v4.0.0, 0.23 v3.7.0, 0.44 v3.4.0, 0.50 v3.3.0, 0.29 v3.2.0, 0.21 v3.1.0, 0.11 v2.7.0, 0.27 v2.6.0, 0.33 v2.5.0, 0.00 v2.2.1
% Syntax   : Number of clauses     :    6 (   6 unt;   0 nHn;   1 RR)
%            Number of literals    :    6 (   6 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    9 (   9 usr;   7 con; 0-3 aty)
%            Number of variables   :   13 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Include ternary Boolean algebra axioms
include('Axioms/BOO001-0.ax').
%--------------------------------------------------------------------------
%----Denial of single axiom:
cnf(prove_single_axiom,negated_conjecture,
    multiply(multiply(a,inverse(a),b),inverse(multiply(multiply(c,d,e),f,multiply(c,d,g))),multiply(d,multiply(g,f,e),c)) != b ).

%--------------------------------------------------------------------------
