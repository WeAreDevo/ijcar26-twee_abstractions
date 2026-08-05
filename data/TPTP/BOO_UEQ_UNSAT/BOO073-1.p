%--------------------------------------------------------------------------
% File     : BOO073-1 : TPTP v9.2.1. Released v2.6.0.
% Domain   : Boolean Algebra
% Problem  : DN-1 is a single axiom for Boolean algebra, part 2
% Version  : [EF+02] axioms.
% English  :

% Refs     : [EF+02] Ernst et al. (2002), More First-order Test Problems in
%          : [MV+02] McCune et al. (2002), Short Single Axioms for Boolean
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.39 v9.1.0, 0.41 v9.0.0, 0.36 v8.2.0, 0.46 v8.1.0, 0.55 v7.5.0, 0.50 v7.4.0, 0.57 v7.3.0, 0.53 v7.1.0, 0.50 v7.0.0, 0.58 v6.4.0, 0.53 v6.2.0, 0.57 v6.1.0, 0.56 v6.0.0, 0.67 v5.5.0, 0.63 v5.4.0, 0.53 v5.3.0, 0.50 v5.1.0, 0.47 v5.0.0, 0.43 v4.1.0, 0.36 v4.0.1, 0.43 v4.0.0, 0.38 v3.7.0, 0.22 v3.4.0, 0.25 v3.3.0, 0.36 v3.1.0, 0.33 v2.7.0, 0.36 v2.6.0
% Syntax   : Number of clauses     :    2 (   2 unt;   0 nHn;   1 RR)
%            Number of literals    :    2 (   2 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    9 (   3 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   3 con; 0-2 aty)
%            Number of variables   :    4 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : A UEQ part of BOO038-1
%--------------------------------------------------------------------------
cnf(dn1,axiom,
    inverse(add(inverse(add(inverse(add(A,B)),C)),inverse(add(A,inverse(add(inverse(C),inverse(add(C,D)))))))) = C ).

cnf(huntinton_2,negated_conjecture,
    add(add(a,b),c) != add(a,add(b,c)) ).

%--------------------------------------------------------------------------
