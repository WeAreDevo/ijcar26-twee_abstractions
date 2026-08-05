%--------------------------------------------------------------------------
% File     : BOO076-1 : TPTP v9.2.1. Released v2.6.0.
% Domain   : Boolean Algebra
% Problem  : Sh-1 is a single axiom for Boolean algebra, part 2
% Version  : [EF+02] axioms.
% English  :

% Refs     : [EF+02] Ernst et al. (2002), More First-order Test Problems in
%          : [MV+02] McCune et al. (2002), Short Single Axioms for Boolean
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.78 v9.1.0, 0.73 v9.0.0, 0.77 v8.2.0, 0.71 v8.1.0, 0.80 v7.5.0, 0.75 v7.4.0, 0.78 v7.3.0, 0.74 v7.1.0, 0.67 v7.0.0, 0.68 v6.4.0, 0.74 v6.3.0, 0.71 v6.1.0, 0.75 v6.0.0, 0.81 v5.5.0, 0.84 v5.4.0, 0.87 v5.3.0, 0.83 v5.2.0, 0.86 v5.1.0, 0.87 v5.0.0, 0.86 v4.1.0, 0.91 v4.0.1, 0.79 v4.0.0, 0.77 v3.7.0, 0.67 v3.4.0, 0.88 v3.3.0, 0.71 v3.1.0, 0.78 v2.7.0, 0.91 v2.6.0
% Syntax   : Number of clauses     :    2 (   2 unt;   0 nHn;   1 RR)
%            Number of literals    :    2 (   2 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    4 (   4 usr;   3 con; 0-2 aty)
%            Number of variables   :    3 (   1 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : A UEQ part of BOO039-1
%--------------------------------------------------------------------------
cnf(sh_1,axiom,
    nand(nand(A,nand(nand(B,A),A)),nand(B,nand(C,A))) = B ).

cnf(prove_meredith_2_basis_2,negated_conjecture,
    nand(a,nand(b,nand(a,c))) != nand(nand(nand(c,b),b),a) ).

%--------------------------------------------------------------------------
