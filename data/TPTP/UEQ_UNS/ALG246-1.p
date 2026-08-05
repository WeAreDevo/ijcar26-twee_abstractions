%------------------------------------------------------------------------------
% File     : ALG246-1 : TPTP v9.2.1. Released v4.0.0.
% Domain   : Group Theory (Quasigroups)
% Problem  : Axioms of SBL algebras are not independent
% Version  : Especial.
% English  :

% Refs     : [PS08]  Phillips & Stanovsky (2008), Automated Theorem Proving
%          : [Sta08] Stanovsky (2008), Email to G. Sutcliffe
% Source   : [Sta08]
% Names    : Sxx_1 [Sta08]

% Status   : Unsatisfiable
% Rating   : 0.65 v9.1.0, 0.73 v9.0.0, 0.68 v8.2.0, 0.71 v8.1.0, 0.80 v7.5.0, 0.79 v7.4.0, 0.87 v7.3.0, 0.79 v7.1.0, 0.78 v7.0.0, 0.74 v6.4.0, 0.79 v6.3.0, 0.82 v6.2.0, 0.86 v6.1.0, 0.88 v6.0.0, 0.90 v5.5.0, 0.84 v5.4.0, 0.80 v5.3.0, 0.75 v5.2.0, 0.79 v5.1.0, 0.80 v5.0.0, 0.79 v4.1.0, 0.73 v4.0.1, 0.79 v4.0.0
% Syntax   : Number of clauses     :   14 (  14 unt;   0 nHn;   1 RR)
%            Number of literals    :   14 (  14 equ;   1 neg)
%            Maximal clause size   :    1 (   1 avg)
%            Maximal term depth    :    5 (   2 avg)
%            Number of predicates  :    1 (   0 usr;   0 prp; 2-2 aty)
%            Number of functors    :   11 (  11 usr;   4 con; 0-2 aty)
%            Number of variables   :   23 (   1 sgn)
% SPC      : CNF_UNS_RFO_PEQ_UEQ

% Comments : The LADR formulas contain function or predicate symbols that are
%            not legal TPTP symbols, and we have replaced those symbols with
%            new symbols. Here is the list of the bad symbols and the
%            corresponding replacements.
%                (arity 2)        / -> tptp0
%                (arity 2)        * -> tptp1
%                (arity 1)        - -> tptp2
%                (arity 0)        0 -> tptp3
%                (arity 2)        ^ -> tptp4
%                (arity 0)        1 -> tptp5
%------------------------------------------------------------------------------
cnf(c01,axiom,
    tptp1(A,B) = tptp1(B,A) ).

cnf(c02,axiom,
    tptp1(tptp5,A) = A ).

cnf(c03,axiom,
    tptp1(A,tptp0(A,B)) = tptp1(B,tptp0(B,A)) ).

cnf(c04,axiom,
    tptp0(tptp1(A,B),C) = tptp0(A,tptp0(B,C)) ).

cnf(c05,axiom,
    tptp0(tptp3,A) = tptp5 ).

cnf(c06,axiom,
    tptp0(tptp0(tptp0(A,B),C),tptp0(tptp0(tptp0(B,A),C),C)) = tptp5 ).

cnf(c07,axiom,
    tptp4(A,B) = tptp1(A,tptp0(A,B)) ).

cnf(c08,axiom,
    v(A,B) = tptp4(tptp0(tptp0(A,B),B),tptp0(tptp0(B,A),A)) ).

cnf(c09,axiom,
    tptp0(tptp1(A,B),tptp3) = v(tptp0(A,tptp3),tptp0(B,tptp3)) ).

cnf(c10,axiom,
    m(A) = tptp0(A,tptp3) ).

cnf(c11,axiom,
    n(A) = m(tptp2(A)) ).

cnf(c12,axiom,
    tptp2(tptp2(A)) = A ).

cnf(c13,axiom,
    n(tptp0(A,B)) = n(tptp0(tptp2(B),tptp2(A))) ).

cnf(goals,negated_conjecture,
    v(tptp1(n(a),n(tptp0(a,b))),n(b)) != n(b) ).

%------------------------------------------------------------------------------
