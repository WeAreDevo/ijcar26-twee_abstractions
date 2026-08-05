%--------------------------------------------------------------------------
% File     : LAT076-1 : TPTP v9.2.1. Released v2.6.0.
% Domain   : Lattice Theory (Ortholattices)
% Problem  : Given single axiom MOL-27B1, prove associativity
% Version  : [MRV03] (equality) axioms.
% English  : Given a single axiom candidate MOL-27B1 for modular ortholattices
%            (MOL) in terms of the Sheffer Stroke, prove a Sheffer stroke form
%            of associativity.

% Refs     : [MRV03] McCune et al. (2003), Sheffer Stroke Bases for Ortholatt
% Source   : [MRV03]
% Names    : MOL-27B1-associativity [MRV03]

% Status   : Unsatisfiable
% Rating   : 0.91 v8.2.0, 0.92 v8.1.0, 0.90 v7.5.0, 0.92 v7.4.0, 0.96 v7.3.0, 0.89 v6.4.0, 0.95 v6.3.0, 0.94 v6.2.0, 0.93 v6.1.0, 0.94 v6.0.0, 0.95 v5.4.0, 1.00 v2.6.0
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
%----Single axiom MOL-27B1
cnf(mol_27B1,axiom,
    f(f(f(f(B,A),f(C,A)),D),f(A,f(f(f(f(f(f(B,B),A),C),C),A),B))) = A ).

%----Denial of Sheffer stroke associativity
cnf(associativity,negated_conjecture,
    f(a,f(f(b,c),f(b,c))) != f(c,f(f(b,a),f(b,a))) ).

%--------------------------------------------------------------------------
