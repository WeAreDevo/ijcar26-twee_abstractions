%--------------------------------------------------------------------------
% File     : LAT026-1 : TPTP v9.2.1. Released v2.2.0.
% Domain   : Lattice Theory (Weakly Associative Lattices)
% Problem  : WAL + absorption gives LT, part 1.
% Version  : [MP96] (equality) axioms.
% English  : A Weakly associative lattice (WAL) satisfying an absorption
%            law is associative, and therefore a full lattice, part 1.

% Refs     : [McC98] McCune (1998), Email to G. Sutcliffe
%          : [MP96]  McCune & Padmanabhan (1996), Automated Deduction in Eq
% Source   : [McC98]
% Names    : WAL-1-a [MP96]

% Status   : Unsatisfiable
% Rating   : 0.17 v9.1.0, 0.23 v9.0.0, 0.27 v8.2.0, 0.25 v7.5.0, 0.29 v7.4.0, 0.39 v7.3.0, 0.37 v7.1.0, 0.33 v7.0.0, 0.37 v6.3.0, 0.35 v6.2.0, 0.36 v6.1.0, 0.44 v6.0.0, 0.52 v5.5.0, 0.58 v5.4.0, 0.40 v5.3.0, 0.33 v5.2.0, 0.36 v5.1.0, 0.40 v5.0.0, 0.36 v4.1.0, 0.27 v4.0.1, 0.29 v4.0.0, 0.23 v3.7.0, 0.00 v3.3.0, 0.14 v3.1.0, 0.11 v2.7.0, 0.09 v2.6.0, 0.00 v2.4.0, 0.00 v2.2.1
% Syntax   : Number of clauses     :    8 (   8 unt;   0 nHn;   1 RR)
%            Number of literals    :    8 (   8 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   3 con; 0-2 aty)
%            Number of variables   :   15 (   6 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Include Weakly Associative Lattices theory (equality) axioms
include('Axioms/LAT005-0.ax').
%--------------------------------------------------------------------------
%----An absorption law.
cnf(absorbtion,hypothesis,
    meet(X,join(Y,join(X,Z))) = X ).

%----Denial of associativity of meet:
cnf(prove_associativity_of_meet,negated_conjecture,
    meet(meet(a,b),c) != meet(a,meet(b,c)) ).

%--------------------------------------------------------------------------
