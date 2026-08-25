# Phase 3.5: concepts removed from the prover's input

The five defining equations are deleted and every axiom and goal is
unfolded into the primitive loop signature, so the prover never sees
`a`, `K`, `L`, `R` or `T`. Each prover gets 60s; a failed search still
contributes its partial proof (twee's lemmas, Prover9's `kept:` clauses).

`sym@rank` = alpha-equivalent match, `*` = subterm, `~` = provably equal
under the problem's axioms. **!** marks a run whose terms are mostly
input axioms rather than derived content.

**derived** is the share of terms the prover actually derived. Prover9's
`kept:` clauses include the input axioms, and unfolding leaves the
construction bodies *inside* those axioms -- so a run that derived almost
nothing can appear to "recover" constructions it was simply handed.
Recovery is only evidence of discovery where the derived share is high.

**pattern a/K/L/R/T** counts occurrences of each construction's shape
with arbitrary subterms in argument positions -- what a compressor can
actually abstract.

| corpus | problem | prover | outcome | terms (derived) | pattern a/K/L/R/T | stitch | babble |
|---|---|---|---|---|---|---|---|
| aim_lc | first_sketch_goal_1 | prover9 | proved | 262 (246 derived) | 2/7/4/0/1 | - | not run |
| aim_lc | first_sketch_goal_1 | twee | proved | 407 (407 derived) | 2/116/0/3/40 | K@1, T@4 | not run |
| aim_lc | first_sketch_goal_2 | prover9 | proved | 302 (284 derived) | 2/14/3/0/8 | - | not run |
| aim_lc | first_sketch_goal_2 | twee | proved | 390 (390 derived) | 2/107/0/3/43 | K@1 | not run |
| aim_lc | first_sketch_goal_3 | prover9 | proved | 374 (356 derived) | 2/4/3/0/8 | - | not run |
| aim_lc | first_sketch_goal_3 | twee | proved | 198 (198 derived) | 2/42/0/3/31 | K@1, T@2 | not run |
| aim_lc | first_sketch_goal_4 | prover9 | search_failed | 248 (248 derived) | 0/0/0/0/0 | - | not run |
| aim_lc | first_sketch_goal_4 | twee | gave_up | 550 (550 derived) | 0/1/0/0/11 | - | not run |
| aim_lc | first_sketch_goal_5 | prover9 | search_failed | 162 (162 derived) | 0/0/0/0/0 | - | not run |
| aim_lc | first_sketch_goal_5 | twee | gave_up | 671 (671 derived) | 2/0/0/0/9 | - | not run |
| aim_lc | first_sketch_goal_6 | prover9 | search_failed | 296 (296 derived) | 0/0/0/0/0 | - | not run |
| aim_lc | first_sketch_goal_6 | twee | gave_up | 693 (693 derived) | 8/0/2/0/10 | - | not run |
| aim_lc | first_sketch_goal_7 | prover9 | search_failed | 470 (470 derived) | 0/0/0/0/0 | - | not run |
| aim_lc | first_sketch_goal_7 | twee | gave_up | 681 (681 derived) | 7/0/0/0/17 | - | not run |
| aim_lc_hints | hint01_d3 | prover9 | proved | 14 (8 derived) | 0/0/0/0/0 | - | not run |
| aim_lc_hints | hint01_d3 | twee | proved | 5 (5 derived) | 0/0/0/0/0 | - | not run |
| aim_lc_hints | hint02_d3 | prover9 | search_failed | 732 (732 derived) | 0/0/0/0/0 | - | not run |
| aim_lc_hints | hint02_d3 | twee | gave_up | 461 (461 derived) | 0/0/0/0/11 | - | not run |
| aim_lc_hints | hint03_d3 | prover9 | search_failed | 322 (322 derived) | 0/0/0/0/0 | - | not run |
| aim_lc_hints | hint03_d3 | twee | gave_up | 387 (387 derived) | 0/0/0/0/7 | - | not run |
| aim_lc_hints | hint04_d3 | prover9 | proved | 162 (146 derived) | 0/0/2/0/1 | - | not run |
| aim_lc_hints | hint04_d3 | twee | proved | 34 (34 derived) | 0/0/0/0/0 | - | not run |
| aim_lc_hints | hint05_d3 | prover9 | search_failed | 382 (382 derived) | 0/0/0/0/0 | K@5~ | not run |
| aim_lc_hints | hint05_d3 | twee | gave_up | 883 (883 derived) | 1/0/4/0/29 | - | not run |
| aim_lc_hints | hint06_d4 | prover9 | search_failed | 1160 (1160 derived) | 0/0/0/0/0 | - | not run |
| aim_lc_hints | hint06_d4 | twee | gave_up | 498 (498 derived) | 0/0/0/0/11 | - | not run |
| aim_lc_hints | hint07_d4 | prover9 | proved | 94 (78 derived) | 0/0/2/0/1 | - | not run |
| aim_lc_hints | hint07_d4 | twee | proved | 100 (100 derived) | 0/0/0/0/0 | - | not run |
| aim_lc_hints | hint08_d4 | prover9 | proved | 426 (408 derived) | 0/0/2/0/8 | - | not run |
| aim_lc_hints | hint08_d4 | twee | proved | 296 (296 derived) | 0/0/1/2/11 | - | not run |
| aim_lc_hints | hint09_d5 | prover9 | proved | 332 (314 derived) | 0/0/3/0/11 | T@5~ | not run |
| aim_lc_hints | hint09_d5 | twee | proved | 240 (240 derived) | 0/0/0/0/13 | - | not run |
| aim_lc_hints | hint10_d6 | prover9 | proved | 156 (140 derived) | 0/0/2/0/1 | - | not run |
| aim_lc_hints | hint10_d6 | twee | proved | 27 (27 derived) | 0/0/0/0/0 | - | not run |
| bml_aim | 3_goal_1 | prover9 | proved | 672 (646 derived) | 26/40/1/0/361 | K@9, T@1, a@5 | not run |
| bml_aim | 3_goal_1 | twee | proved | 1191 (1191 derived) | 9/43/0/0/2056 | K@3~, T@1 | not run |
| bml_aim | 3_goal_2 | prover9 | search_failed | 204 (204 derived) | 0/0/3/0/74 | T@2 | not run |
| bml_aim | 3_goal_2 | twee | gave_up | 516 (516 derived) | 0/0/0/0/67 | T@4 | not run |
| bml_aim | 3_goal_3 | prover9 | search_failed | 398 (398 derived) | 0/0/8/0/201 | T@1 | not run |
| bml_aim | 3_goal_3 | twee | gave_up | 426 (426 derived) | 0/0/0/0/74 | - | not run |
| bml_aim | 3_goal_4 | prover9 | proved | 48 (28 derived) | 26/4/0/9/0 | K@3, R@2, a@1 | not run |
| bml_aim | 3_goal_4 | twee | gave_up | 338 (338 derived) | 0/0/0/0/7 | - | not run |
| bml_aim | 3_goal_5 | prover9 | search_failed | 234 (234 derived) | 0/0/6/0/117 | T@1 | not run |
| bml_aim | 3_goal_5 | twee | gave_up | 362 (362 derived) | 0/1/0/0/37 | T@1* | not run |
| bml_aim | 3_goal_6 | prover9 | search_failed | 394 (394 derived) | 0/0/1/0/129 | T@2 | not run |
| bml_aim | 3_goal_6 | twee | gave_up | 325 (325 derived) | 0/1/0/0/16 | - | not run |
