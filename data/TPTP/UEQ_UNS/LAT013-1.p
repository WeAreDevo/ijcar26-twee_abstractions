%--------------------------------------------------------------------------
% File     : LAT013-1 : TPTP v9.2.1. Released v2.2.0.
% Domain   : Lattice Theory
% Problem  : McKenzie's 4-basis for lattice theory, part 2 (of 3)
% Version  : [MP96] (equality) axioms.
% English  : This is part of a proof that McKenzie's 4-basis axiomatizes
%            lattice theory.  We prove half of the standard basis.
%            The other half follows by duality.  In this part we prove
%            associativity of meet.

% Refs     : [McC98] McCune (1998), Email to G. Sutcliffe
%          : [MP96]  McCune & Padmanabhan (1996), Automated Deduction in Eq
% Source   : [McC98]
% Names    : LT-9-b [MP96]

% Status   : Unsatisfiable
% Rating   : 0.09 v8.2.0, 0.17 v8.1.0, 0.20 v7.5.0, 0.17 v7.4.0, 0.35 v7.3.0, 0.26 v7.1.0, 0.17 v7.0.0, 0.26 v6.4.0, 0.32 v6.3.0, 0.18 v6.2.0, 0.21 v6.1.0, 0.38 v6.0.0, 0.48 v5.5.0, 0.53 v5.4.0, 0.40 v5.3.0, 0.33 v5.2.0, 0.36 v5.1.0, 0.33 v5.0.0, 0.21 v4.1.0, 0.18 v4.0.1, 0.21 v4.0.0, 0.08 v3.7.0, 0.00 v3.3.0, 0.21 v3.2.0, 0.14 v3.1.0, 0.22 v2.7.0, 0.18 v2.6.0, 0.17 v2.5.0, 0.00 v2.2.1
% Syntax   : Number of clauses     :    5 (   5 unt;   0 nHn;   1 RR)
%            Number of literals    :    5 (   5 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   3 con; 0-2 aty)
%            Number of variables   :   12 (   8 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----McKenzie's self-dual (independent) absorptive 4-basis for lattice theory.
cnf(mckenzie1,axiom,
    join(X,meet(Y,meet(X,Z))) = X ).

cnf(mckenzie2,axiom,
    meet(X,join(Y,join(X,Z))) = X ).

cnf(mckenzie3,axiom,
    join(join(meet(X,Y),meet(Y,Z)),Y) = Y ).

cnf(mckenzie4,axiom,
    meet(meet(join(X,Y),join(Y,Z)),Y) = Y ).

%----Denial of conclusion:
cnf(prove_associativity_of_meet,negated_conjecture,
    meet(meet(a,b),c) != meet(a,meet(b,c)) ).

%--------------------------------------------------------------------------
