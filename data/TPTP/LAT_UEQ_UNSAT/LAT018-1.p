%--------------------------------------------------------------------------
% File     : LAT018-1 : TPTP v9.2.1. Bugfixed v2.2.1.
% Domain   : Lattice Theory (Ortholattices)
% Problem  : E3 holds in Ortholattices.
% Version  : [McC98b] (equality) axioms.
% English  : Prove that from ortholattice axioms, one can derive equation E3.

% Refs     : [McC98a] McCune (1998), Automatic Proofs and Counterexamples f
%          : [McC98b] McCune (1998), Email to G. Sutcliffe
% Source   : [McC98b]
% Names    : OL-3 [McC98b]

% Status   : Unsatisfiable
% Rating   : 0.74 v9.1.0, 0.73 v9.0.0, 0.77 v8.2.0, 0.79 v8.1.0, 0.80 v7.5.0, 0.75 v7.4.0, 0.78 v7.3.0, 0.74 v7.1.0, 0.78 v7.0.0, 0.79 v6.4.0, 0.84 v6.3.0, 0.82 v6.2.0, 0.93 v6.1.0, 1.00 v5.4.0, 0.93 v5.3.0, 0.92 v5.2.0, 0.93 v5.0.0, 0.86 v4.1.0, 0.82 v4.0.1, 0.86 v4.0.0, 0.85 v3.7.0, 0.78 v3.4.0, 1.00 v3.3.0, 0.93 v3.1.0, 1.00 v2.2.1
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
%----Denial of equation E3
cnf(prove_e3,negated_conjecture,
    join(complement(join(join(meet(complement(a),b),meet(complement(a),complement(b))),meet(a,join(complement(a),b)))),join(complement(a),b)) != n1 ).

%--------------------------------------------------------------------------
