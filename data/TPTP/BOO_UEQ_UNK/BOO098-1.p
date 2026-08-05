%--------------------------------------------------------------------------
% File     : BOO098-1 : TPTP v9.2.1. Released v2.6.0.
% Domain   : Boolean Algebra
% Problem  : Axiom C11 for Boolean algebra in the Sheffer stroke, part 2
% Version  : [EF+02] axioms.
% English  :

% Refs     : [EF+02] Ernst et al. (2002), More First-order Test Problems in
%          : [MV+02] McCune et al. (2002), Short Single Axioms for Boolean
% Source   : [TPTP]
% Names    :

% Status   : Unknown
% Rating   : 1.00 v2.6.0
% Syntax   : Number of clauses     :    2 (   2 unt;   0 nHn;   1 RR)
%            Number of literals    :    2 (   2 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    4 (   4 usr;   3 con; 0-2 aty)
%            Number of variables   :    3 (   0 sgn)
% SPC      : CNF_UNK_RFO_PEQ_UEQ

% Comments : A UEQ part of BOO050-1
%--------------------------------------------------------------------------
cnf(c11,axiom,
    nand(nand(nand(A,nand(B,C)),A),nand(C,nand(A,B))) = C ).

cnf(prove_meredith_2_basis_2,negated_conjecture,
    nand(a,nand(b,nand(a,c))) != nand(nand(nand(c,b),b),a) ).

%--------------------------------------------------------------------------
