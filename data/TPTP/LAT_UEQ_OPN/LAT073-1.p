%--------------------------------------------------------------------------
% File     : LAT073-1 : TPTP v9.2.1. Released v2.6.0.
% Domain   : Lattice Theory (Ortholattices)
% Problem  : Given single axiom MOL-23C, prove modularity
% Version  : [MRV03] (equality) axioms.
% English  : Given a single axiom candidate MOL-23C for modular ortholattices
%            (MOL) in terms of the Sheffer Stroke, prove a Sheffer stroke form
%            of modularity.

% Refs     : [MRV03] McCune et al. (2003), Sheffer Stroke Bases for Ortholatt
% Source   : [MRV03]
% Names    : MOL-23C-modularity [MRV03]

% Status   : Open
% Rating   : 1.00 v2.6.0
% Syntax   : Number of clauses     :    2 (   2 unt;   0 nHn;   1 RR)
%            Number of literals    :    2 (   2 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    7 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    4 (   4 usr;   3 con; 0-2 aty)
%            Number of variables   :    4 (   1 sgn)
% SPC      : CNF_OPN_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Single axiom MOL-23C
cnf(mol_23C,axiom,
    f(f(f(B,f(A,B)),B),f(A,f(C,f(f(A,B),f(f(C,C),D))))) = A ).

%----Denial of Sheffer stroke modularity
cnf(modularity,negated_conjecture,
    f(a,f(b,f(a,f(c,c)))) != f(a,f(c,f(a,f(b,b)))) ).

%--------------------------------------------------------------------------
