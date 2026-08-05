%--------------------------------------------------------------------------
% File     : LAT017-1 : TPTP v9.2.1. Bugfixed v2.2.1.
% Domain   : Lattice Theory (Ortholattices)
% Problem  : E2 holds in Ortholattices.
% Version  : [McC98b] (equality) axioms.
% English  : Prove that from ortholattice axioms, one can derive equation E2.

% Refs     : [McC98a] McCune (1998), Automatic Proofs and Counterexamples f
%          : [McC98b] McCune (1998), Email to G. Sutcliffe
% Source   : [McC98b]
% Names    : OL-2 [McC98b]

% Status   : Unsatisfiable
% Rating   : 0.52 v9.1.0, 0.59 v9.0.0, 0.68 v8.2.0, 0.58 v8.1.0, 0.60 v7.5.0, 0.54 v7.4.0, 0.61 v7.3.0, 0.63 v7.1.0, 0.56 v7.0.0, 0.47 v6.4.0, 0.58 v6.3.0, 0.59 v6.2.0, 0.71 v6.1.0, 0.88 v6.0.0, 0.86 v5.5.0, 0.89 v5.4.0, 0.80 v5.3.0, 0.75 v5.2.0, 0.79 v5.1.0, 0.73 v5.0.0, 0.64 v4.1.0, 0.55 v4.0.1, 0.64 v4.0.0, 0.54 v3.7.0, 0.44 v3.4.0, 0.50 v3.3.0, 0.64 v3.2.0, 0.71 v3.1.0, 0.56 v2.7.0, 0.73 v2.6.0, 0.33 v2.5.0, 0.25 v2.4.0, 0.67 v2.2.1
% Syntax   : Number of clauses     :   11 (  11 unt;   0 nHn;   1 RR)
%            Number of literals    :   11 (  11 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    7 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    7 (   7 usr;   4 con; 0-2 aty)
%            Number of variables   :   19 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : Ortholattice lemmas are included in McCunes original, but have
%            been removed here.
% Bugfixes : v2.2.1 - Bugfix in LAT003-0.ax.
%--------------------------------------------------------------------------
%----Include ortholattice axioms
include('Axioms/LAT003-0.ax').
%--------------------------------------------------------------------------
%----Denial of equation E2
cnf(prove_e2,negated_conjecture,
    join(a,join(meet(complement(a),meet(join(a,complement(b)),join(a,b))),meet(complement(a),join(meet(complement(a),b),meet(complement(a),complement(b)))))) != n1 ).

%--------------------------------------------------------------------------
