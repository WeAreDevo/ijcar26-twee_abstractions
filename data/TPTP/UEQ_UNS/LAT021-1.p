%--------------------------------------------------------------------------
% File     : LAT021-1 : TPTP v9.2.1. Released v2.2.0.
% Domain   : Lattice Theory (Quasilattices)
% Problem  : Bowden's inequality gives distributivity in lattice theory.
% Version  : [MP96] (equality) axioms.
% English  :

% Refs     : [McC98] McCune (1998), Email to G. Sutcliffe
%          : [MP96]  McCune & Padmanabhan (1996), Automated Deduction in Eq
% Source   : [McC98]
% Names    : QLT-4 [MP96]

% Status   : Unsatisfiable
% Rating   : 0.04 v9.1.0, 0.09 v8.2.0, 0.17 v8.1.0, 0.10 v7.5.0, 0.12 v7.4.0, 0.22 v7.3.0, 0.00 v7.0.0, 0.11 v6.4.0, 0.16 v6.3.0, 0.18 v6.2.0, 0.29 v6.1.0, 0.19 v6.0.0, 0.33 v5.5.0, 0.32 v5.4.0, 0.20 v5.3.0, 0.08 v5.2.0, 0.14 v5.1.0, 0.07 v5.0.0, 0.14 v4.1.0, 0.18 v4.0.1, 0.21 v4.0.0, 0.23 v3.7.0, 0.11 v3.4.0, 0.12 v3.3.0, 0.00 v2.5.0, 0.25 v2.4.0, 0.00 v2.2.1
% Syntax   : Number of clauses     :   10 (  10 unt;   0 nHn;   1 RR)
%            Number of literals    :   10 (  10 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   3 con; 0-2 aty)
%            Number of variables   :   21 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Bowden's inequality is written as an equation.
%--------------------------------------------------------------------------
%----Include Quasilattice theory (equality) axioms
include('Axioms/LAT004-0.ax').
%--------------------------------------------------------------------------
%----Bowden's inequality (as an equation):
cnf(bowden,hypothesis,
    join(join(X,meet(Y,Z)),meet(join(X,Y),Z)) = join(X,meet(Y,Z)) ).

%----Denial of distributivity:
cnf(prove_distributivity,negated_conjecture,
    meet(a,join(b,c)) != join(meet(a,b),meet(a,c)) ).

%--------------------------------------------------------------------------
