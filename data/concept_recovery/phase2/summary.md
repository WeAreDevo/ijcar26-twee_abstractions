# Phase 2: definition-erasure recovery

`sym@rank` = hidden definition recovered as whole abstraction body (alpha-equivalent) at that rank; `*` = recovered only as a subterm of a larger abstraction.

| corpus | terms | stitch recovered | babble recovered |
|---|---:|---|---|
| first_sketch__Ka | 3926 | K@3, L@2, R@5, T@4, a@1 | not run |
| first_sketch__aK1 | 1290 | K@6, L@1, R@2, T@4, a@3 | K@2, L@5, R@4, T@1, a@3 |
| first_sketch__aK2 | 1290 | K@6, L@1, R@2, T@4, a@3 | K@2, L@1, R@4, T@5, a@3 |
| first_sketch__aK3 | 2610 | K@5, L@2, R@4, T@3, a@1 | failed: RuntimeError |
| first_sketch__aa1 | 4014 | K@3, L@2, R@5, T@4, a@1 | not run |
| first_sketch__aa2 | 4014 | K@3, L@2, R@5, T@4, a@1 | not run |
| first_sketch__aa3 | 4014 | K@3, L@2, R@5, T@4, a@1 | not run |
| first_sketch_expanded__Ka | 11200 | K@4, L@2, R@5, T@3, a@1 | not run |
| first_sketch_expanded__aK1 | 3416 | K@6, L@1, R@3, T@5, a@2 | not run |
| first_sketch_expanded__aK2 | 3416 | K@6, L@1, R@3, T@5, a@2 | not run |
| first_sketch_expanded__aK3 | 7040 | K@4, L@2, R@5, T@3, a@1 | not run |
| first_sketch_expanded__aa1 | 11388 | K@4, L@2, R@5, T@3, a@1 | not run |
| first_sketch_expanded__aa2 | 11388 | K@4, L@2, R@5, T@3, a@1 | not run |
| first_sketch_expanded__aa3 | 11388 | K@4, L@2, R@5, T@3, a@1 | not run |
| second_sketch__Ka | 3378 | K@3, L@2, R@5, T@4, a@1 | not run |
| second_sketch__aK1 | 852 | K@7, L@1, R@2, T@5, a@3 | L@4, R@2, T@5, a@3 |
| second_sketch__aK2 | 854 | K@7, L@1, R@2, T@5, a@3 | L@2, R@5, T@3, a@1 |
| second_sketch__aK3 | 982 | K@7, L@1, R@3, T@5, a@2 | L@4, R@5, T@1, a@2 |
| second_sketch__aa1 | 3424 | K@3, L@2, R@5, T@4, a@1 | not run |
| second_sketch__aa2 | 3426 | K@3, L@2, R@5, T@4, a@1 | not run |
| second_sketch__aa3 | 3426 | K@3, L@2, R@5, T@4, a@1 | not run |
| second_sketch_expanded__Ka | 4244 | K@3, L@2, R@5, T@4, a@1 | not run |
| second_sketch_expanded__aK1 | 1086 | K@8, L@1, R@2, T@5, a@3 | not run |
| second_sketch_expanded__aK2 | 1090 | K@8, L@1, R@2, T@5, a@3 | not run |
| second_sketch_expanded__aK3 | 1256 | K@8, L@1, R@3, T@5, a@2 | not run |
| second_sketch_expanded__aa1 | 4302 | K@3, L@2, R@5, T@4, a@1 | not run |
| second_sketch_expanded__aa2 | 4306 | K@3, L@2, R@5, T@4, a@1 | not run |
| second_sketch_expanded__aa3 | 4306 | K@3, L@2, R@5, T@4, a@1 | not run |
