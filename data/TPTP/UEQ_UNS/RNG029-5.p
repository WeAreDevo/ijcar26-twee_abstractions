%--------------------------------------------------------------------------
% File     : RNG029-5 : TPTP v9.2.1. Released v1.0.0.
% Domain   : Ring Theory (Alternative)
% Problem  : Middle Moufang identity
% Version  : [Ste87] (equality) axioms.
% English  :

% Refs     : [Ste87] Stevens (1987), Some Experiments in Nonassociative Rin
%          : [Ste88] Stevens (1988), Challenge Problems from Nonassociative
% Source   : [TPTP]
% Names    :

% Status   : Unsatisfiable
% Rating   : 0.96 v9.1.0, 0.95 v8.2.0, 0.96 v8.1.0, 1.00 v7.5.0, 0.96 v7.3.0, 0.95 v7.1.0, 0.94 v7.0.0, 0.95 v6.4.0, 1.00 v6.1.0, 0.94 v6.0.0, 0.95 v5.4.0, 0.87 v5.3.0, 0.83 v5.2.0, 0.86 v5.1.0, 0.87 v5.0.0, 0.86 v4.1.0, 0.82 v4.0.1, 0.86 v4.0.0, 0.85 v3.7.0, 0.78 v3.4.0, 0.75 v3.3.0, 0.86 v3.1.0, 0.89 v2.7.0, 0.91 v2.6.0, 0.83 v2.5.0, 0.75 v2.4.0, 0.67 v2.2.1, 1.00 v2.0.0
% Syntax   : Number of clauses     :   16 (  16 unt;   0 nHn;   1 RR)
%            Number of literals    :   16 (  16 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    9 (   9 usr;   4 con; 0-3 aty)
%            Number of variables   :   27 (   2 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : [Ste88] presents a slightly different set of axioms for proving
%            this theorem. The axioms are so similar to those in RNG004.ax
%            that a separate problems has not been created.
%--------------------------------------------------------------------------
%----Include nonassociative ring axioms
include('Axioms/RNG003-0.ax').
%--------------------------------------------------------------------------
cnf(prove_middle_law,negated_conjecture,
    multiply(multiply(cx,cy),multiply(cz,cx)) != multiply(cx,multiply(multiply(cy,cz),cx)) ).

%--------------------------------------------------------------------------
