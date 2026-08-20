# Phase 3 fallback: what was found instead

## Why the standard constructions were not recovered

Occurrences as a subterm across all 18 primitive corpora (2109 term occurrences):

| construction | occurrences |
|---|---:|
| a | 0 |
| K | 0 |
| L | 1 |
| R | 0 |
| T | 3 |

A compressor cannot abstract a pattern the proofs never build.

## Local identity (`x\x`, `x/x`) — the concept these proofs *are* about

| corpus | statement | terms | local-id occurrences | best rank |
|---|---|---:|---:|---|
| thm1__otter | Let Q be a quasigroup satisfying D14. Then it satisfies F14. | 126 | 40 | babble@1, stitch@2 |
| thm1__twee | Let Q be a quasigroup satisfying D14. Then it satisfies F14. | 99 | 3 | babble@3, stitch@3 |
| thm2__otter | Let Q be a quasigroup satisfying F14. Then it satisfies D14. | 86 | 22 | babble@2, stitch@4 |
| thm2__twee | Let Q be a quasigroup satisfying F14. Then it satisfies D14. | 175 | 27 | - |
| thm3__otter | Every LG2 quasigroup is a right loop. | 92 | 8 | - |
| thm3__twee | Every LG2 quasigroup is a right loop. | 23 | 17 | babble@1, stitch@1 |
| thm4__otter | Every LC3 quasigroup is a left loop. | 68 | 13 | stitch@4 |
| thm4__twee | Every LC3 quasigroup is a left loop. | 47 | 43 | stitch@1 |
| thm5__otter | An LG1 quasigroup is an LG3 quasigroup. | 86 | 22 | babble@1, stitch@4 |
| thm5__twee | An LG1 quasigroup is an LG3 quasigroup. | 175 | 27 | - |
| thm6__otter | An LG1 quasigroup is an LC4 quasigroup. | 140 | 45 | babble@3, stitch@3 |
| thm6__twee | An LG1 quasigroup is an LC4 quasigroup. | 348 | 43 | stitch@9 |
| thm7__otter | An LC4 quasigroup is an LC2 quasigroup. | 50 | 1 | - |
| thm7__twee | An LC4 quasigroup is an LC2 quasigroup. | 66 | 9 | - |
| thm8__otter | An LC1 quasigroup is an LBQ quasigroup. | 86 | 22 | babble@3, stitch@4 |
| thm8__twee | An LC1 quasigroup is an LBQ quasigroup. | 178 | 27 | - |
| thm9__otter | An LC1 quasigroup is an LC4 quasigroup. | 86 | 22 | babble@1, stitch@4 |
| thm9__twee | An LC1 quasigroup is an LC4 quasigroup. | 178 | 27 | - |

## Most common top-5 abstraction bodies (all runs)

| count | body |
|---:|---|
| 13 | `op(A, A)` |
| 8 | `ldiv(A, A)` |
| 8 | `rdiv(ldiv(A, A), B)` |
| 7 | `rdiv(A, op(B, A))` |
| 6 | `op(op(C, B), A)` |
| 5 | `op(rdiv(B, op(A, A)), A)` |
| 5 | `op(B, A)` |
| 5 | `op(rdiv(A, op(B, B)), B)` |
| 5 | `op(rdiv(B, A), C)` |
| 5 | `op(rdiv(A, B), C)` |
| 4 | `op(rdiv(B, A), op(A, A))` |
| 4 | `op(rdiv(A, B), op(B, B))` |
| 4 | `rdiv(C, ldiv(B, A))` |
| 4 | `ldiv(C, op(C, op(rdiv(D, B), A)))` |
| 4 | `rdiv(B, ldiv(A, ldiv(rdiv(ldiv(D, D), C), C)))` |
