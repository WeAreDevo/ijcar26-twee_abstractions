%--------------------------------------------------------------------------
% File     : LAT020-1 : TPTP v9.2.1. Released v2.2.0.
% Domain   : Lattice Theory (Quasilattices)
% Problem  : Self-dual distributivity for quasilattices.
% Version  : [MP96] (equality) axioms.
% English  :

% Refs     : [McC98] McCune (1998), Email to G. Sutcliffe
%          : [MP96]  McCune & Padmanabhan (1996), Automated Deduction in Eq
% Source   : [McC98]
% Names    : QLT-3 [MP96]

% Status   : Unsatisfiable
% Rating   : 0.48 v9.1.0, 0.55 v9.0.0, 0.45 v8.2.0, 0.54 v8.1.0, 0.55 v7.5.0, 0.62 v7.4.0, 0.65 v7.3.0, 0.58 v7.1.0, 0.50 v7.0.0, 0.58 v6.3.0, 0.53 v6.2.0, 0.57 v6.1.0, 0.62 v6.0.0, 0.67 v5.5.0, 0.74 v5.4.0, 0.60 v5.3.0, 0.58 v5.2.0, 0.57 v5.1.0, 0.67 v5.0.0, 0.64 v4.0.0, 0.62 v3.7.0, 0.44 v3.4.0, 0.50 v3.1.0, 0.44 v2.7.0, 0.55 v2.6.0, 0.33 v2.5.0, 0.25 v2.4.0, 0.33 v2.3.0, 0.67 v2.2.1
% Syntax   : Number of clauses     :   10 (  10 unt;   0 nHn;   1 RR)
%            Number of literals    :   10 (  10 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   3 con; 0-2 aty)
%            Number of variables   :   21 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Include Quasilattice theory (equality) axioms
include('Axioms/LAT004-0.ax').
%--------------------------------------------------------------------------
%----Self-dual distributivity:
cnf(self_dual_distributivity,hypothesis,
    join(meet(join(meet(X,Y),Z),Y),meet(Z,X)) = meet(join(meet(join(X,Y),Z),Y),join(Z,X)) ).

%----Denial of ordinary distributivity:
cnf(prove_distributivity,negated_conjecture,
    meet(a,join(b,c)) != join(meet(a,b),meet(a,c)) ).

%--------------------------------------------------------------------------
