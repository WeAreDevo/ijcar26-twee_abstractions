%------------------------------------------------------------------------------
% File     : BOO046-10 : TPTP v9.2.1. Released v7.5.0.
% Domain   : Puzzles
% Problem  : Single axiom C7 for Boolean algebra in the Sheffer stroke
% Version  : Especial.
% English  :

% Refs     : [CS18]  Claessen & Smallbone (2018), Efficient Encodings of Fi
%          : [Sma18] Smallbone (2018), Email to Geoff Sutcliffe
% Source   : [Sma18]
% Names    :

% Status   : Open
% Rating   : 1.00 v7.5.0
% Syntax   : Number of clauses     :    2 (   2 unt;   0 nHn;   1 RR)
%            Number of literals    :    2 (   2 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :    5 (   5 usr;   3 con; 0-2 aty)
%            Number of variables   :    3 (   1 sgn)
% SPC      : CNF_OPN_RFO_PEQ_UEQ

% Comments : Converted from BOO046-1 to UEQ using [CS18].
%------------------------------------------------------------------------------
cnf(c7,axiom,
    nand(nand(A,nand(A,nand(B,B))),nand(B,nand(C,A))) = B ).

cnf(prove_meredith_2_basis,negated_conjecture,
    tuple(nand(a,nand(b,nand(a,c))),nand(nand(a,a),nand(b,a))) != tuple(nand(nand(nand(c,b),b),a),a) ).

%------------------------------------------------------------------------------
