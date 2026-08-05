%--------------------------------------------------------------------------
% File     : LAT079-1 : TPTP v9.2.1. Released v2.6.0.
% Domain   : Lattice Theory (Ortholattices)
% Problem  : Given single axiom MOL-27B2, prove modularity
% Version  : [MRV03] (equality) axioms.
% English  : Given a single axiom candidate MOL-27B2 for modular ortholattices
%            (MOL) in terms of the Sheffer Stroke, prove a Sheffer stroke form
%            of modularity.

% Refs     : [MRV03] McCune et al. (2003), Sheffer Stroke Bases for Ortholatt
% Source   : [MRV03]
% Names    : MOL-27B2-modularity [MRV03]

% Status   : Unsatisfiable
% Rating   : 0.96 v9.1.0, 0.91 v9.0.0, 0.95 v8.2.0, 0.96 v8.1.0, 1.00 v6.4.0, 0.95 v6.3.0, 0.94 v6.2.0, 0.93 v6.1.0, 1.00 v2.6.0
% Syntax   : Number of clauses     :    2 (   2 unt;   0 nHn;   1 RR)
%            Number of literals    :    2 (   2 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    9 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    4 (   4 usr;   3 con; 0-2 aty)
%            Number of variables   :    4 (   1 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Single axiom MOL-27B2
cnf(mol_27B2,axiom,
    f(f(f(f(B,A),f(A,C)),D),f(A,f(f(f(B,f(B,f(f(C,C),A))),A),C))) = A ).

%----Denial of Sheffer stroke modularity
cnf(modularity,negated_conjecture,
    f(a,f(b,f(a,f(c,c)))) != f(a,f(c,f(a,f(b,b)))) ).

%--------------------------------------------------------------------------
