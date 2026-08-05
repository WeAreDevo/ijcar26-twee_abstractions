%--------------------------------------------------------------------------
% File     : ROB032-1 : TPTP v9.2.1. Released v3.1.0.
% Domain   : Robbins Algebra
% Problem  : Robbins => Exists absorbed element
% Version  : [Win90] (equality) axioms.
%            Theorem formulation : Denies Huntington's axiom.
% English  : If there are elements c and d such that c+d=d, then the
%            algebra is Boolean.

% Refs     : [Win90] Winker (1990), Robbins Algebra: Conditions that make a
%          : [Wos92] Wos (1992), An Opportunity to Test Your Skills, and th
%          : [Loe04] Loechner (2004), Email to Geoff Sutcliffe
% Source   : [Loe04]
% Names    :

% Status   : Unsatisfiable
% Rating   : 1.00 v3.1.0
% Syntax   : Number of clauses     :    4 (   4 unt;   0 nHn;   1 RR)
%            Number of literals    :    4 (   4 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    6 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    2 (   2 usr;   0 con; 1-2 aty)
%            Number of variables   :    9 (   1 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments :
%--------------------------------------------------------------------------
%----Include axioms for Robbins algebra
include('Axioms/ROB001-0.ax').
%--------------------------------------------------------------------------
cnf(prove_absorbtion,negated_conjecture,
    add(C,D) != D ).

%--------------------------------------------------------------------------
