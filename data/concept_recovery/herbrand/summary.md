# GAPT cut-introduction: where it works on our domain

Question: are there proofs in the AIM / Bol-Moufang loop domain for which GAPT
does *not* time out? **Yes — but only well below the size of the proofs we
actually care about.**

## The workable band on our signature

Cut-introduction's cost is gated by the **term set** (the multiset of quantifier
instantiations), and the delta-table decomposition is exponential in it.
Measured on a family of loop problems built for the purpose (below):

| term set | outcome |
|---|---|
| ≤ 4 | completes, but **trivial or too small** — no lemma exists |
| 5 – 21 | **works**, seconds per proof, real lemmas |
| 25 – 51 | OutOfMemory at 4 GB; still times out at 12 GB |
| 55+ | timeout |

So the usable band is roughly **5–21 terms**, narrower than the 10–50 the paper
reports for TSTP. Every proof in our existing corpora is above it.

## Our real proofs are all far above the band

Term sets measured by `src/gapt/survey_termsets.py` (import only, no
decomposition — cheap):

| corpus | proof | term set | max depth | cut-intro |
|---|---|---:|---:|---|
| definition-free bml_aim | 3_goal_4 | 55 | 7 | timeout |
| definition-free bml_aim | 3_goal_1 | 60,071 | 26 | hopeless |
| definition-free aim_lc | first_sketch_goal_1 | 9,645 | — | timeout |
| definition-free aim_lc_hints | hint01_d3 | 6 | 4 | completes, no lemma |
| definition-free aim_lc_hints | hint07_d4 | 218 | 9 | timeout |
| definition-free aim_lc_hints | hint08_d4 | 12,078 | 15 | hopeless |
| **definition-ful** bml_aim | 3_goal_1 | **440** | **7** | OOM / timeout |

Only proofs Prover9 actually found can be imported at all: the `IMPORT_FAIL`
entries in the JSON surveys are exactly the goals where the search failed, since
`prooftrans` has no proof to convert.

## Erasing definitions is what blows up the term set

The same goal, `bml_aim 3_goal_1`, with the derived operations `a,K,L,R,T`
defined versus unfolded into the primitive signature:

| | term set | max depth |
|---|---:|---:|
| definitions intact | 440 | 7 |
| definitions unfolded (phase 3.5) | 60,071 | 26 |

**136x more terms and nearly 4x the depth.** Unfolding is what makes these
proofs unreachable for GAPT — worth knowing, because the definition-free
problems are precisely the ones the concept-recovery experiment cares about.

## The proofs that do work

Two families were built in the loop signature (`1, *, \, /` with the six loop
axioms) to probe the boundary. Both are "in our domain" in signature, though
they are constructed probes, not naturally-occurring goals.

**`data/loop_chain/`** — iterated cancellation over *distinct* constants,
`c1 \ (c1 * (c2 \ (c2 * ... y)))= y`. Term sets 3–15, only 2 distinct roots, so
highly repetitive — yet **every one gives NO_LEMMA**. The instances share no
structure to generalise: repetition alone is not enough.

**`data/loop_tower/`** — the loop analogue of GAPT's own `LinearExampleProof`.
`T_0 = c`, `T_{k+1} = T_k * a`; the goal peels `T_n` back down with `/a`, so the
axiom `(x*y)/y = x` is instantiated along a *tower* of increasing depth. This is
the shape that compresses:

| proof | term set | grammar | lemma |
|---|---:|---:|---|
| tower04 | 5 | 5 | `∀x1 x1 * a * a / a / a = x1` |
| tower06 | 7 | 6 | `∀x1 x1 * a * a / a / a = x1` |
| tower08 | 9 | 7 | `∀x1 x1 * a * a / a / a = x1` |
| tower09 | 10 | 7 | `∀x1 x1 * a * a * a / a / a / a = x1` |
| tower10 | 11 | 8 | `∀x1 x1 * a * a / a / a = x1` |
| tower11 | 12 | 12 | `∀x1 x1 * a * a * a / a / a = x1 * a` |
| tower12 | 13 | 8 | `∀x1 x1 * a * a * a / a / a / a = x1` |
| tower14 | 15 | 14 | `∀x1 x1 * a * a * a / a / a = x1 * a` |
| tower16 | 17 | 9 | `∀x1 x1 * a^4 / a^4 = x1` |
| tower18 | 19 | 10 | `∀x1 x1 * a * a * a / a / a / a = x1` |
| tower20 | 21 | 10 | `∀x1 x1 * a^4 / a^4 = x1` |

7 of 11 small towers and all four of 16/18/20 produce lemmas; `tower03/05/07`
give NO_LEMMA (an odd tower admits no even repeating block). The lemmas are
genuine loop statements — "multiplying by `a` k times and dividing k times is
the identity" — and GAPT picks the block size itself.

## Reproducing

```bash
python src/gapt/survey_termsets.py <dir of *prover9*.out>   # cheap: import only
python src/gapt/run_gapt.py <proof.out> --timeout 60        # full cut-introduction
```

Problem generators and Prover9 inputs are in `data/loop_tower/`,
`data/loop_chain/`, `data/small_loop/`, `data/definition_ful/bml_aim/`.
