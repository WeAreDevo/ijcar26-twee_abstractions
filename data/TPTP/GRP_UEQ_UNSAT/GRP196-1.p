%--------------------------------------------------------------------------
% File     : GRP196-1 : TPTP v9.2.1. Released v2.2.0.
% Domain   : Group Theory (Semigroups)
% Problem  : In semigroups, xyyy=yyyx -> (uy)^9 = u^9v^9.
% Version  : [MP96] (equality) axioms.
% English  :

% Refs     : [McC98] McCune (1998), Email to G. Sutcliffe
%          : [MP96]  McCune & Padmanabhan (1996), Automated Deduction in Eq
%          : [McC95] McCune (1995), Four Challenge Problems in Equational L
% Source   : [McC98]
% Names    : CS-3 [MP96]
%          : Problem B [McC95]

% Status   : Unsatisfiable
% Rating   : 0.87 v9.1.0, 0.91 v9.0.0, 0.86 v8.2.0, 0.92 v8.1.0, 0.80 v7.5.0, 0.88 v7.4.0, 0.91 v7.3.0, 0.89 v7.0.0, 0.95 v6.4.0, 1.00 v4.0.1, 0.93 v4.0.0, 0.92 v3.7.0, 0.89 v3.4.0, 1.00 v3.3.0, 0.93 v3.1.0, 1.00 v2.2.1
% Syntax   : Number of clauses     :    3 (   3 unt;   0 nHn;   1 RR)
%            Number of literals    :    3 (   3 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :   18 (   4 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    3 (   3 usr;   2 con; 0-2 aty)
%            Number of variables   :    5 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : The problem was originally posed for cancellative semigroups,
%            Otter does this with a nonstandard representation [MP96].
%--------------------------------------------------------------------------
%----Include semigroups axioms
include('Axioms/GRP008-0.ax').
%--------------------------------------------------------------------------
%----Hypothesis:
cnf(condition,hypothesis,
    multiply(X,multiply(Y,multiply(Y,Y))) = multiply(Y,multiply(Y,multiply(Y,X))) ).

%----Denial of conclusion:
cnf(prove_this,negated_conjecture,
    multiply(a,multiply(b,multiply(a,multiply(b,multiply(a,multiply(b,multiply(a,multiply(b,multiply(a,multiply(b,multiply(a,multiply(b,multiply(a,multiply(b,multiply(a,multiply(b,multiply(a,b))))))))))))))))) != multiply(a,multiply(a,multiply(a,multiply(a,multiply(a,multiply(a,multiply(a,multiply(a,multiply(a,multiply(b,multiply(b,multiply(b,multiply(b,multiply(b,multiply(b,multiply(b,multiply(b,b))))))))))))))))) ).

%--------------------------------------------------------------------------
