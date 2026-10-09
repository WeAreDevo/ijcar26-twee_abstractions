# GAPT cut-introduction on Veroff's AIM proof (`aa2 ⇒ aa3`)

Applying the lemma-generation algorithm of Ebner–Hetzl–Leitsch–Reis–Weller,
*On the Generation of Quantified Lemmas* (JAR 63:95–126, 2019), as implemented
in GAPT 2.19.0, to `data/AIM/aa2_to_aa3.pf`. Run 2026-09-17.

Companion to `PROGRESS_herbrand.md` (tool characterisation). Raw results:
`data/AIM/gapt/{ladder_probe,cutintro_results}.json`. Code:
`src/gapt/aim_subproofs.py`, tests `src/gapt/test_aim_subproofs.py`.

## State at a glance

| | |
|---|---|
| Whole proof | **Cannot be used.** GAPT never finishes *importing* it — 10 GB heap, 25 min, no output. The wall is proof import, before any decomposition. |
| Fragments | **Work.** Sub-proofs of the same proof, re-emitted as standalone refutations, are inside the method's range and yield lemmas. |
| Lemmas found | 11 successes over 80 runs (16 fragments × 5 grammar methods), all with 1 cut, 1–3 quantifiers. |
| Headline | Every lemma generated is a **partial generalisation of a formula the input proof already contains** — an axiom, or an early derived step (clauses 88 and 91). Nothing new was invented. |
| Proof shortening | **Mostly no.** Against a cut-free LK proof of the same Herbrand sequent: 4 of 11 runs shorter, median ratio 1.11, best −15 %, worst +67 %. Beautification is the main cost. See Result 4. |
| Revision to prior work | The "usable band is term set 5–21" in `PROGRESS_herbrand.md` is too pessimistic *for these fragments*: term sets 31, 40 and 56 all produced lemmas here, at 2 GB, in 9–109 s. |

## The input

`data/AIM/` holds one Prover9 problem and its proof, from Veroff's AIM work
(the `.pf` header records `prover9 -f aa2_to_aa3.in`, run by `veroff` on
2020-01-04 with Prover9 2017-09A).

- Signature `* \ / 1` plus the AIM derived operations `a` (associator),
  `K` (commutator) and the inner mappings `L`, `R`, `T` — all **defined by
  axioms in the problem**, so this is a *definition-ful* problem in the sense of
  `PROGRESS_concept_recovery.md`.
- Hypothesis `aa2`: `a(x, a(y,z,u), w) = 1` — an associator in the *middle*
  argument makes the associator trivial.
- Goal `aa3`: `a(x, y, a(z,u,w)) = 1` — the same for the *third* argument.
- The `.in` also carries **13,569 hints** (a previous proof's steps), which is
  how the search was made to terminate.

The proof itself, per its own header: **length 10,221**, level 344, maximum
clause weight 82, found after 1930 s with 10,293 given clauses. Parsed as a DAG
it has 10,221 clauses, 10,083 of them unit equations, no dangling
justifications, and every clause is an ancestor of `$F` — no orphan steps. Only
nine justification kinds appear: `assumption`, `goal`, `clausify`, `copy`,
`flip`, `para`, `hyper`, `resolve`, `deny` — `para` alone accounts for 9,579 of
them.

`data/AIM/aa2_to_aa3.tstp` is the same refutation in TSTP CNF. GAPT can import
generic TSTP by replaying every step with its built-in prover Escargot; at
10,221 steps that is obviously worse than the native Prover9 path, and it was
not attempted.

## Attempt 1: the whole proof, as asked

`prooftrans` is not the problem: `prooftrans expand -f` digests the 10,221-step
`.pf` in **2.0 s**. (The file is itself prooftrans output; GAPT re-runs
prooftrans on it, and that round-trip is fine.)

GAPT is the problem, and it fails *earlier than expected* — not in the
delta-table, but while building the expansion proof:

| heap | outcome |
|---|---|
| 4 GB | GC-bound. RSS pinned at the cap, 270–650 % CPU, no progress; killed at ~6 min. |
| 10 GB | Killed at the harness's 1500 s outer timeout. **No output at all** — `TERMSET_SIZE` never printed. |

So for this proof there is no term-set measurement to report: the pipeline dies
in `Prover9Importer.robinsonProof` / `InstanceTermEncoding`, upstream of
`computeDecomposition`. This is a different failure from the one recorded in
`PROGRESS_herbrand.md`, where our proofs "import cleanly and the failure is
entirely in the decomposition step". At 10,221 steps even the import is out of
reach.

## Making the proof reachable: carving sub-proofs

Every intermediate clause of a resolution proof has its own derivation — its
ancestor subgraph — and those span every size from 2 steps up to the whole
proof. `src/gapt/aim_subproofs.py` turns any such subgraph back into a
self-contained Prover9 refutation, so cut-introduction can be applied to
genuine *fragments of Veroff's proof* rather than to re-proofs of its lemmas.

For a target clause `n` whose clause is a unit equation `s = t`:

```
<ancestor clauses of n, verbatim, original ids and justifications>
90001  s = t                    # label(non_clause) # label(goal).  [goal].
90002  s[c̄/x̄] != t[c̄/x̄]                                     [deny(90001)].
90003  $F                                             [resolve(n,a,90002,a)].
```

### Control: does a successful import mean anything?

It does, because GAPT's Prover9 importer shells out to `prooftrans ivy`, which
re-checks every inference. Pinned in `test_aim_subproofs.py`:

| input | result |
|---|---|
| carved sub-proof of clause 62 | imports, background theory `Equality` |
| same, with step 62 changed to a **false** equation | `IOException: prooftrans ivy exited with value 1` |
| same, with premise 22 **deleted** | `IOException: prooftrans ivy exited with value 1` |

So the detector fires on a true positive and rejects two kinds of false one. A
fragment that imports is a checked derivation, not merely well-formed text.
Those are 3 of the suite's 19 tests; the other 16 pin the justification
grammar (`para(11(a,1),…)` positions are *not* clause ids;
`hyper(17,a,16,a(flip),b,88,a)` alternates ids with literal labels) and the
Skolem-constant naming — under Prover9's convention a constant
named `x1` would be read back as a *variable* and silently make the denial
vacuous.

## Result 1: term set against sub-proof length

A ladder of 37 sub-lemmas, one per target sub-proof size. Term sets measured
with the import-only probe at 2 GB.

| clause | steps | term set | distinct roots | max depth | avg depth | trivial |
|---:|---:|---:|---:|---:|---:|:--|
| 22 | 2 | 2 | 2 | 2 | 1.5 | yes |
| 47 | 3 | 3 | 3 | 2 | 1.7 | yes |
| 62 | 4 | 3 | 3 | 4 | 2.3 | yes |
| 95 | 5 | 4 | 3 | 3 | 2.0 | no |
| 94 | 6 | 4 | 4 | 2 | 1.8 | yes |
| 101 | 8 | 5 | 5 | 2 | 1.8 | yes |
| 125 | 10 | 6 | 5 | 3 | 2.2 | no |
| 147 | 13 | 8 | 6 | 4 | 2.5 | no |
| 129 | 16 | 9 | 8 | 5 | 3.9 | no |
| 133 | 20 | 12 | 8 | 5 | 3.6 | no |
| 617 | 25 | 16 | 9 | 6 | 4.3 | no |
| 359 | 32 | 19 | 12 | 6 | 4.2 | no |
| 636 | 40 | 20 | 15 | 6 | 3.5 | no |
| 539 | 50 | 31 | 14 | 6 | 4.3 | no |
| 547 | 64 | 40 | 17 | 6 | 4.2 | no |
| 650 | 80 | 56 | 19 | 7 | 4.7 | no |
| 1764 | 100 | 129 | 19 | 10 | 5.2 | no |
| 1901 | 128 | 176 | 19 | 11 | 6.1 | no |
| 2275 | 160 | 223 | 21 | 12 | 6.5 | no |
| 1036 | 200 | 252 | 23 | 9 | 5.0 | no |
| 2161 | 256 | 346 | 25 | 11 | 5.2 | no |
| 2232 | 320 | 832 | 25 | 15 | 7.1 | no |
| 2557 | 400 | 2,615 | 27 | 17 | 8.2 | no |
| 3525 | 500 | 4,029 | 27 | 19 | 9.2 | no |
| 3527 | 639 | 17,384 | 27 | 24 | 11.6 | no |
| 5852 | 800 | 9,309 | 28 | 27 | 14.3 | no |
| 5044 … 11419 | 1,000 – 9,828 | import OOM at 2 GB (11 entries, 40–600 s) | | | | |

Three things to take from this.

**The growth is superlinear and the knee is sharp.** Up to ~100 steps the term
set is roughly proportional to the step count and stays inside the method's
range. Between 320 and 639 steps it explodes by a factor of ~20 (832 → 17,384)
while the step count barely triples. It is also **not monotone**: the 639-step
fragment has 17,384 terms, the 800-step one only 9,309 — the shape of the
sub-proof matters more than its length.

**Term depth climbs with it.** Max depth goes 6 → 7 → 10 → … → 27 across the
ladder, and average depth roughly triples. This supports the suspicion recorded
in `PROGRESS_herbrand.md` that depth, not count alone, drives the cost: the
fragments that decompose here all have max depth ≤ 7.

**Distinct roots saturate at 28.** Distinct roots count the end-sequent
formulas that get instantiated at all, so they are bounded by the problem's
axiom count and cannot grow with the fragment. Triviality is therefore only a
concern at the very bottom of the ladder — 5 of the 9 smallest fragments are
trivial in the paper's sense (every term a distinct root symbol, nothing to
compress).

**How much of the proof is reachable.** Counting all 10,221 clauses by
sub-proof size: 387 have ≤ 12 steps (trivial or near-trivial, judging by the
ladder), **1,343 fall in the 13–80-step window** that maps to term sets 8–56,
1,731 are in 81–500 steps, and 6,760 are above 500 steps. So roughly **13 % of
the proof's steps sit in a fragment that cut-introduction can process at all.**

## Result 2: cut-introduction on the in-band fragments

All 16 fragments with term set ≤ 56, each with all five grammar-finding methods
that need no external binary; 60 s inner timeout, 2 GB heap. `g=` is
decomposition (grammar) size.

| clause | term set | `many_dtable` | `1_dtable_ss` | `1_maxsat` | `1_2_maxsat` | `reforest` |
|---:|---:|---|---|---|---|---|
| 22 | 2 | ERROR | ERROR | ERROR | ERROR | ERROR |
| 47 | 3 | – | – | – | – | – |
| 62 | 3 | – | – | – | – | – |
| 95 | 4 | – | – | – | – | – |
| 94 | 4 | – | – | – | – | – |
| 101 | 5 | – | – | – | – | – |
| 125 | 6 | – | – | – | – | – |
| 147 | 8 | – | – | – | – | – |
| 129 | 9 | – | – | – | – | – |
| 133 | 12 | – | – | – | – | – |
| 617 | 16 | – | – | **OK** g=16 | – (226 s) | – |
| 359 | 19 | **OK** g=20 | **OK** g=20 | – | timeout | – |
| 636 | 20 | – | – | – | – | – |
| 539 | 31 | **OK** g=30 | **OK** g=30 | **OK** g=29 | timeout | – |
| 547 | 40 | **OK** g=42 | **OK** g=42 | **OK** g=84 | timeout | – |
| 650 | 56 | **OK** g=114 | **OK** g=114 | timeout | timeout | – |

`–` is `NO_LEMMA`. Successes took 5–109 s.

- **Nothing below term set 16, and one gap above it.** The failures at term
  sets ≤ 9 are mostly the paper's *trivial* case (nothing to compress), but the
  fragments at 12 and at 20 are non-trivial and still yield nothing — the
  paper's *incompressible* category. Success is not a simple threshold in term
  set size.
- **Method choice is decisive and not consistent.** Clause 617 yields a lemma
  *only* under `1_maxsat`; clause 359 *only* under the two delta-table methods.
  Prior work saw the mirror image of this (only `reforest` worked on
  `hint01_d3`); here **`reforest` never succeeds**, on any of the 16. There is
  no single best method, which matches the paper's Fig. 1 — its "virtual best"
  portfolio beats every individual algorithm because they succeed on classes of
  proofs with little overlap.
- **`1_2_maxsat` is unusable here.** Two-quantifier MaxSAT was killed by the
  outer bound on four of the five fragments above term set 19 (the exception,
  clause 636, returned `NO_LEMMA` in 35 s), and the paper itself notes
  decompositions with *k* > 2 are "hardly feasible".
- **Grammar size tracks term set, not quality.** g grows 16 → 114 as the term
  set grows 16 → 56, and the lemmas get correspondingly worse (below).

## Result 3: what the lemmas actually say

Eleven successes, all with exactly **1 cut**. The two clean ones first.

**Clause 617** (25 steps, term set 16, `1_maxsat`, g=16) — goal
`R(T(x*y,(x\1)*x), x\1, x) = ((x\1)*x) \ (x*R(y,x,x\1))`:

```
∀x₁  c₁₀₀ * T(x₁, c₁₀₀) = x₁ * c₁₀₀
```

This is the defining property of the inner mapping `T`: from the axiom
`x \ (u*x) = T(u,x)` and `x*(x\y) = y` one gets `x * T(u,x) = u * x`. GAPT
produced it with the second argument fixed to the fragment's Skolem constant and
the first universally quantified.

**Clause 359** (32 steps, term set 19, both delta-table methods, g=20) — goal
`(a(x,y,z)\1)\u = a(x,y,z)*u`:

```
∀x₁ ∀x₂  L(x₂, a(c₁₀₁, c₁₀₂, c₁₀₃), x₁) = x₂
```

Mathematically this is the `L`-form of the problem's own hypothesis `aa2`: from
`a(x,a(y,z,u),w) = 1` and the compatibility axiom `a(x,y,z)=1 → L(z,y,x)=z`, an
associator in the middle slot makes `L` act as the identity. A real universally
quantified statement about the inner mapping group, recovered from a fragment
whose goal mentions neither `L` nor `aa2` in that form.

**The crucial qualification: both of these are already in the proof.** Checking
the carved fragments against Veroff's own clause list:

| generated lemma | already present as |
|---|---|
| `c₁₀₀ * T(x₁,c₁₀₀) = x₁ * c₁₀₀` | **clause 88**, `x * T(y,x) = y * x`, `[para(30(a,2),14(a,1,2))]` |
| `L(x₂, a(c₁₀₁,c₁₀₂,c₁₀₃), x₁) = x₂` | **clause 91**, `L(x,a(y,z,u),w) = x`, `[hyper(31,a,45,a)]` |

Both clauses lie *inside* the fragment GAPT was given. So cut-introduction did
not invent these lemmas; it recovered a step the prover had already formed, and
recovered it in a *weaker* form — one or two variables kept universal, the rest
replaced by the fragment's Skolem constants. Clause 88 is a fully general
identity; the generated version fixes one of its two arguments.

**The larger fragments degrade into definitional restatement.** At term sets
31–56 the cut formula becomes a conjunction of definition instances rather than
a statement:

- clause 539 (term set 31): a two-way conjunction unfolding `R(c₁₀₀, 1/c₁₀₁, x₁)`
  and `a(c₁₀₀, 1/c₁₀₁, x₁)` to their defining right-hand sides — modulo
  cancelling `*1` / `/1` noise that beautification did not remove;
- clause 547 (term set 40): `R`-definition ∧ *clause 91 again* (it recurs
  independently on a different fragment) under `many_dtable`, or
  `y/1 = y` ∧ a padded `T`-definition under `1_maxsat`;
- clause 650 (term set 56): a **three-way** conjunction of `R`-, `K`- and
  `y/1 = y` instances, g=114.

Each conjunct is an instance of an axiom, or of an early derived equation,
already present in the fragment — the defining axioms of `a`, `K`, `R`, `T`
(clauses 21/22, 23/24, 27/28, 29/30) and `x / 1 = x` (clause 50). And in the
clause-539 and clause-650 lemmas `∀x₂` is **vacuous** — a cosmetic grammar
artefact, the same one recorded in `PROGRESS_herbrand.md`. The clause-359 and
clause-547 lemmas use all their quantifiers.

So across the whole band the pattern is uniform: **every lemma generated is a
partial generalisation of a formula the input fragment already contains.** On
this proof the method reproduces existing structure; it does not name a new
concept. Note that `a`, `K`, `L`, `R`, `T` were all in the signature already, so
this run says nothing about whether the method could *invent* them — that would
need the definition-free encoding, which was not tried here.

## Result 4: does this shorten proofs? (2026-09-18)

"Shorten" has three different readings, and they do not agree.

**(a) Against the input Prover9 proof: not comparable.** The paper is explicit
about this — "we cannot fairly compare the size of the input proofs in the TSTP
to the proofs with cut, simply because they are proofs in different calculi."
Our inputs are 25–80-step Prover9 refutations; the outputs are LK proofs of
48–265 inferences. The comparison is meaningless.

**(b) Against a cut-free LK proof of the same Herbrand sequent: mostly no.**
This is the comparison the paper makes, and GAPT reports both numbers itself —
`hs_lkinf` (cut-free) and `ehs_lkinf` (with the introduced cut). Re-running the
11 successes with metrics retained (`data/AIM/gapt/metrics_results.json`):

| run | \|T\| | \|D\| | \|D\| after beautify | cut-free LK | with cut | ratio |
|---|---:|---:|---:|---:|---:|---:|
| 617 `1_maxsat` | 16 | 16 | 16 | 55 | **54** | 0.98 |
| 359 `many_dtable` | 19 | 18 | 20 | 48 | 58 | 1.21 |
| 359 `1_dtable_ss` | 19 | 18 | 20 | 48 | 58 | 1.21 |
| 539 `many_dtable` | 31 | 26 | 30 | 133 | 148 | 1.11 |
| 539 `1_dtable_ss` | 31 | 26 | 30 | 133 | 148 | 1.11 |
| 539 `1_maxsat` | 31 | 27 | 29 | 133 | **113** | **0.85** |
| 547 `many_dtable` | 40 | 34 | 42 | 189 | **185** | 0.98 |
| 547 `1_dtable_ss` | 40 | 34 | 42 | 189 | **185** | 0.98 |
| 547 `1_maxsat` | 40 | 36 | 84 | 189 | 191 | 1.01 |
| 650 `many_dtable` | 56 | 43 | 114 | 265 | 443 | 1.67 |
| 650 `1_dtable_ss` | 56 | 43 | 114 | 265 | 443 | 1.67 |

4 of 11 runs produce a **shorter** proof; the median ratio is **1.11** (longer),
the range 0.85–1.67. Only one case is a real win — clause 539 under `1_maxsat`,
133 → 113 inferences, −15 %. So the direction matches the paper's TSTP finding
("the proofs with cut are typically 1.5 times longer than the cut-free ones"),
though we are less bad than that on average.

**Method choice decides whether you win or lose, on the same fragment.** Clause
539, same input proof and same term set: `many_dtable` gives 148 inferences
(1.11×, worse), `1_maxsat` gives 113 (0.85×, better). Nothing about the fragment
predicts this.

**(c) Against the Herbrand term set — the measure the algorithm actually
optimises: yes, but only modestly.** |D|/|T| is **0.77–1.00, median 0.85**,
against the ≈0.5 the paper reports as typical on TSTP (Fig. 5). Our
decompositions compress barely at all.

One tempting number to avoid: |D| / `quant_input` is 0.37–0.47, which looks like
a 2.5× compression of quantifier complexity. But `quant_input` counts instances
*with multiplicity* (34, 43, 62, 84, 115) while |T| is the deduplicated set
(16, 19, 31, 40, 56). Almost all of that 2.5× is deduplication, which costs
nothing and is not the algorithm's doing. The algorithm's own contribution is
|T| → |D|, and that is the 0.85 above.

**Beautification is what destroys the proof-size result.** It is applied after
minimisation to make the lemma legible, and the paper already notes it raised
the lattice case study's decomposition from 28 to 44. Here it is worse: clause
650 goes |D| 43 → **114** (2.7×) and clause 547 under `1_maxsat` goes 36 → 84
(2.3×) — and clause 650 is exactly the run whose LK proof blows up 265 → 443.
Every run where the cut version is shorter is one where beautification cost
little or nothing (16→16, 27→29, 34→42). So there is a real lever here: keeping
the *minimised* rather than beautified solution should help proof size, at the
price of the legibility the paper was optimising for. Untested.

**(d) The reading this repo actually cares about — does the lemma, fed back as a
hint, shorten the prover's re-proof? — is still untested.** That is a different
experiment (twee/Prover9 with hints, measuring search time and proof length),
and it is the one worth running, because a lemma can be worthless as
proof-theoretic compression and still be valuable as search guidance. Note the
discouraging prior: the two clean lemmas here *are* clauses 88 and 91 of the
input proof, which the original search already derived within its first
hundred steps — so as hints they would be re-supplying something cheap.

## Landmines (new ones, on top of `PROGRESS_herbrand.md`)

1. **`BackgroundTheory` is guessed per proof, and the guess can be wrong.**
   Clause 22's fragment (`a(x,y,z) = (x*(y*z))\((x*y)*z)`, derived by
   `copy(21),flip(a)`) is guessed **`PureFOL`**, alone among all 37 fragments.
   Its Herbrand sequent is then `A = B ⊢ B = A` — symmetry of equality — and
   every method dies with
   `CutIntroduction$UnprovableException: Cannot prove Herbrand sequent`.
   A fragment whose only equality *reasoning* is a `flip` gives the guesser
   nothing to go on. This is landmine #4 of `PROGRESS_herbrand.md` biting from a
   direction the note did not anticipate: the `guess`-based factory is not
   sufficient, and an `ERROR` here means "wrong background theory", not
   "no lemma".
2. **GAPT's inner `withTimeout` really does not bound the decomposition** —
   now with numbers. With a 60 s inner limit, `1_2_maxsat` on clause 617 ran
   **226 s** and then returned `NO_LEMMA`, and on clauses 359/539/547/650 it had
   to be killed by the wrapper's 240 s outer bound. The outer timeout is
   load-bearing, as the note says; these are the first measurements of by how
   much.
3. **Import failure and decomposition failure are different walls, and the
   first one arrives first on large proofs.** The survey tooling reports both as
   trouble, but `IMPORT_FAIL` at 2 GB (11 of 37 fragments) is a heap artefact of
   the probe setting, whereas the 10 GB / 25 min failure on the whole proof is a
   real limit. Do not read the former as a statement about the method.
4. **`prooftrans` needs `-f <file>`**; fed on stdin it exits 1 with
   `Fatal error: file name missing`.

## Reproducing

`$LOG_DIR` lives in `.env`, which only Python reads, so export a directory for
the carved fragments first:

```bash
OUT=$(grep '^LOG_DIR=' .env | cut -d= -f2)/aim_sub

# the ladder of sub-lemmas, and their term sets (resumable)
python src/gapt/aim_subproofs.py ladder data/AIM/aa2_to_aa3.pf
python src/gapt/aim_subproofs.py probe  data/AIM/aa2_to_aa3.pf "$OUT" \
    --json data/AIM/gapt/ladder_probe.json --skip-existing

# carve specific fragments, then run cut-introduction on one
python src/gapt/aim_subproofs.py carve data/AIM/aa2_to_aa3.pf "$OUT" 359
python src/gapt/run_gapt.py "$OUT"/sub359.pf --method many_dtable --timeout 60

# the controls, and the parsing/convention tests
python src/gapt/test_aim_subproofs.py
```

The `probe` step is ~35 min: the eleven fragments above 1,000 steps each burn
40–600 s before running out of heap. Each fragment file is a few kB, so `$OUT`
stays small.

Three result JSONs are committed under `data/AIM/gapt/`: `ladder_probe.json`
(term-set survey), `cutintro_results.json` (all 80 runs, metrics stripped) and
`metrics_results.json` (the 11 successes re-run with GAPT's ~38 metrics kept —
that is where the proof-size numbers in Result 4 come from; `run_gapt.py` puts
them under `metrics`, and the wrapper drops them unless you ask).

## Open questions

- **Does a generated lemma shorten a re-proof when used as a hint?** The
  proof-theoretic side is now measured (Result 4) and is a wash at best. The
  hint side is not: feeding clause 88 or 91 back into twee/Prover9 and measuring
  search time and proof length on the fragment goals is the obvious next step,
  and is the measure this repo actually cares about.
- **Does dropping beautification recover proof-size compression?** Result 4
  shows beautification inflating |D| by up to 2.7× and tracking the one bad LK
  blow-up. Re-running against the *minimised* solution would separate the
  legibility cost from the compression.
- **Would the definition-free encoding force invention?** Every lemma here
  restates something already available. Deleting the `a/K/L/R/T` definitions
  from the fragment inputs is what would test invention — but
  `PROGRESS_herbrand.md` records that unfolding blows the term set up by 136×
  on a goal stated in the derived signature, so most fragments would leave the
  band.
- **Can the import be made to scale?** The 10 GB failure is in expansion-proof
  construction, not the delta-table. Unknown whether that is inherent or an
  implementation limit; a fragment-at-a-time strategy like the one here
  sidesteps it but gives up any global view of the proof.
