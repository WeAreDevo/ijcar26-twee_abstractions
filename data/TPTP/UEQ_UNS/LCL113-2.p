%--------------------------------------------------------------------------
% File     : LCL113-2 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Logic Calculi (Many valued sentential)
% Problem  : MV-33 depends on the Meredith system
% Version  : [TPTP] axioms.
%            Theorem formulation : Wajsberg algebra formulation
% English  : An axiomatisation of the many valued sentential calculus
%            is {MV-1,MV-2,MV-3,MV-5} by Meredith. Wajsberg presented
%            an equality axiomatisation. Show that MV-33 depends on the
%            Wajsberg axiomatisation.

% Refs     : [FRT84] Font et al. (1984), Wajsberg Algebras
%          : [MW92]  McCune & Wos (1992), Experiments in Automated Deductio
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.09 v9.1.0, 0.14 v8.2.0, 0.17 v8.1.0, 0.20 v7.5.0, 0.12 v7.4.0, 0.26 v7.3.0, 0.21 v7.1.0, 0.11 v6.4.0, 0.16 v6.3.0, 0.18 v6.2.0, 0.14 v6.1.0, 0.06 v6.0.0, 0.29 v5.5.0, 0.26 v5.4.0, 0.07 v5.3.0, 0.00 v5.2.0, 0.07 v5.0.0, 0.00 v2.2.1, 0.22 v2.2.0, 0.29 v2.1.0, 0.25 v2.0.0
% Syntax   : Number of clauses     :    5 (   5 unt;   0 nHn;   1 RR)
%            Number of literals    :    5 (   5 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    4 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   3 con; 0-2 aty)
%            Number of variables   :    8 (   0 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Include Wajsberg algebra axioms
include('Axioms/LCL001-0.ax').
%--------------------------------------------------------------------------
cnf(prove_mv_33,negated_conjecture,
    implies(implies(not(x),y),implies(not(y),x)) != truth ).

%--------------------------------------------------------------------------
