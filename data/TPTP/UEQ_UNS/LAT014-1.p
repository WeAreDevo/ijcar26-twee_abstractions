%--------------------------------------------------------------------------
% File     : LAT014-1 : TPTP v9.2.1. Released v2.2.0.
% Domain   : Lattice Theory
% Problem  : McKenzie's 4-basis for lattice theory, part 3 (of 3)
% Version  : [MP96] (equality) axioms.
% English  : This is part of a proof that McKenzie's 4-basis axiomatizes
%            lattice theory.  We prove half of the standard basis.
%            The other half follows by duality. In this part we prove
%            absorbtion of meet.

% Refs     : [McC98] McCune (1998), Email to G. Sutcliffe
%          : [MP96]  McCune & Padmanabhan (1996), Automated Deduction in Eq
% Source   : [McC98]
% Names    : LT-9 [MP96]

% Status   : Unsatisfiable
% Rating   : 0.00 v7.4.0, 0.04 v7.3.0, 0.00 v6.0.0, 0.10 v5.5.0, 0.05 v5.4.0, 0.00 v5.1.0, 0.13 v5.0.0, 0.07 v4.1.0, 0.09 v4.0.1, 0.07 v4.0.0, 0.08 v3.7.0, 0.00 v2.2.1
% Syntax   : Number of clauses     :    5 (   5 unt;   0 nHn;   1 RR)
%            Number of literals    :    5 (   5 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    4 (   4 usr;   2 con; 0-2 aty)
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
cnf(prove_absorbtion,negated_conjecture,
    meet(a,join(a,b)) != a ).

%--------------------------------------------------------------------------
