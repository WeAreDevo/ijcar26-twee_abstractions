# Progress: Proof-Compression Concept-Recovery Experiment

Tracks work against `proof_compression_concept_recovery_experiment.md`.
Started 2026-08-19.

## State at a glance (2026-08-20)

**Phases 0–3 complete; phase 4 is next.** Everything is uncommitted on branch
`aitp26`.

| | |
|---|---|
| Code | `src/corpus/`: `extraction.py`, `erasure.py`, `equiv.py`, `run_phase2.py`, `run_phase3.py`, `analyze_phase3.py`, `build_corpora.py` + 3 test suites (11 + 6 + 8, all passing) |
| Corpora | `data/corpora/` — 66 files, 209,944 term occurrences (gitignored; rebuild with `build_corpora.py`) |
| Results | `data/concept_recovery/phase2/`, `phase3/` (`summary.md`, `fallback.md`, per-corpus JSON) |
| Raw proofs | `data/aim_lc/` (Prover9, plain + `prooftrans expand`), `data/bol_moufang/` (Otter), `data/bml_aim/`; bulky twee dumps gzipped in `$LOG_DIR/aim_lc_twee/` |

**Two headline results.** Phase 2: on the AIM definition-erasure control,
**Stitch recovers all 5 hidden definitions on all 28 corpora**, and on the
large ones its top five abstractions *are* the five definitions. Phase 3: on
the primitive Bol–Moufang corpora **nothing is recovered — because the target
constructions occur 4 times in 2,109 terms.** They are loop concepts; those
are quasigroup proofs.

**Before starting phase 4**: run it on the **AIM** corpora, not Bol–Moufang
(only AIM has concepts to recover). Babble coverage will be limited — it is
OOM-killed above ~2.6k terms at default beams, while Stitch handles 11k terms
in seconds.

## Phase 0: Acquire proof corpora — status

### AIM / Prover9  — done

Downloaded all 12 files from https://www.cs.unm.edu/~veroff/AIM_LC/ into
`data/aim_lc/`: `{first_sketch,second_sketch,lc}.{in,out,pf,xml}`.

**Parsed** (`data/aim_lc/parse_pf.py` → `data/aim_lc/parsed/*.json`): each
`.pf` holds 7 proofs, one per goal (aK1 aK2 aK3 Ka aa1 aa2 aa3). Every step is
kept with id, text, justification, and a kind classification
(equation / negated / clause / false); step counts reconcile exactly with the
"Length of proof" comments.

| file | proofs | steps | positive unit equations |
|---|---:|---:|---:|
| first_sketch.pf | 7 | 10,700 | 10,614 |
| second_sketch.pf | 7 | 8,278 | 8,206 |
| lc.pf | 7 | 17,501 | 17,389 |

**Expanded proofs** (added 2026-08-19): `prooftrans expand -f <stem>.pf`
(LADR) produces `data/aim_lc/{stem}_expanded.pf`, in which every compound
`para + rewrite`/`back_rewrite`/`hyper`/`ur` justification is broken into
explicit primitive paramodulation steps with letter-suffixed ids
(51A, 51B, ...); the only remaining justifications are
para/copy/resolve/assumption. Parsed alongside the originals into
`parsed/{stem}_expanded.json` (goal alignment and per-proof metadata verified
identical to the originals). Step counts:

| file | steps | expanded steps | note |
|---|---:|---:|---|
| first_sketch | 10,700 | 29,739 | heavy demodulation, ~2.8x |
| second_sketch | 8,278 | 10,402 | demodulation-free, barely expands — consistency check |
| lc | 17,501 | 24,936 | |

**Proof metadata** recorded in `data/aim_lc/metadata.json`
(`build_metadata.py`; 42 records = 21 proofs x {plain, expanded}: corpus,
problem, prover, expanded, proof_length (actual steps), equations,
source_length (the .pf "Length of proof"), level, seconds, given_clauses,
uses_hints, demodulation_free, signature, derived_symbols_present).
Highlights, per goal ranges:

| sketch | length | level | notes |
|---|---|---|---|
| first_sketch | 661–2026 | 46–80 | no input hints; the phase-2 primary corpus |
| second_sketch | 439–1730 | 61–153 | strictly-forward, demodulation-free |
| lc | 2191–2842 | 221–321 | heavily hint-guided; secondary corpus |

**Twee re-run**: `data/aim_lc/translate_aim.py` strips the Prover9 search
directives, feeds the `formulas(...)` blocks through `ladr_to_tptp` (reusing
`data/bml_aim/translate.py`), renames `* \ / 0 1` → `op ldiv rdiv zero unit`,
and splits the 7 goals into `data/aim_lc/tptp/{first,second}_sketch_goal_N.p`
(goal_1..goal_7 = aK1, aK2, aK3, Ka, aa1, aa2, aa3, in input order)
(14 problems; the two sketches differ only in provenance — same 25 formulas —
so the second set is a duplicate kept for symmetry). The implications
(compatibility axioms) survive as `fof` formulas, which twee accepts and
ifeq-encodes itself. `lc.in` was **not** translated: its 140 KB of hints are
search guidance, not theory.

Run via `data/aim_lc/run_twee.py` with the base-stage flags
(`--flatten-goal --all-lemmas --show-peaks --proof-on-saturation`,
max_time 1000s, 7-way parallel): **0/14 proved**. Four runs ended cleanly
with `RESULT: GaveUp` at max-time; the rest were killed at the 1120s
subprocess timeout mid-output. This is the expected outcome, not a setup
failure — these are the AIM-conjecture goals that took Prover9 44–850s *with*
tuned term orders, weight schedules, and (for second_sketch/lc) years of
accumulated hints; twee gets none of that. Consequence for the experiment:
**the AIM compression corpora come from the Prover9 .pf proofs**, not from
twee re-runs. The raw twee dumps (~1.2 GB, ~90 MB per goal from
`--all-lemmas --show-peaks`) are gzipped in `$LOG_DIR/aim_lc_twee/` per the
repo's bulky-artifact convention; `data/aim_lc/twee/summary.json` records
per-goal outcomes. The gave-up traces contain twee's final lemma lists and
could feed a partial-proof-style extraction later if wanted.

### Bol–Moufang / Otter — done

Downloaded the Phillips–Vojtěchovský archive (26 KB, single text file) from
https://cs.du.edu/~petr/data/papers/qbm_otter_proofs.txt into
`data/bol_moufang/`.

**Inventory** (`data/bol_moufang/parse_otter.py` →
`data/bol_moufang/parsed/qbm.json`): 9 Otter proofs over the pure quasigroup
signature `{*, \, /}` — no named derived operations, which is what makes this
the genuine concept-recovery corpus.

| thm | statement | length | level | otter s | twee |
|---:|---|---:|---:|---:|---|
| 1 | quasigroup + D14 ⊢ F14 | 59 | 19 | 0.79 | proved, 0.08s |
| 2 | quasigroup + F14 ⊢ D14 | 39 | 16 | 5.09 | proved, 1.7s |
| 3 | LG2 ⊢ right loop | 42 | 13 | 5.00 | proved, 0.02s |
| 4 | LC3 ⊢ left loop | 30 | 15 | 0.40 | proved, 0.03s |
| 5 | LG1 ⊢ LG3 | 39 | 16 | 4.95 | proved, 1.7s |
| 6 | LG1 ⊢ LC4 | 66 | 20 | 4.97 | proved, 1.3s |
| 7 | LC4 ⊢ LC2 | 21 | 11 | 1.58 | proved, 0.05s |
| 8 | LC1 ⊢ LBQ | 39 | 16 | 5.13 | proved, 2.0s |
| 9 | LC1 ⊢ LC4 | 39 | 16 | 5.13 | proved, 2.0s |

**Representative selection** (short / medium / long): **thm7** (21),
**thm2** (39), **thm6** (66).

**TPTP + twee**: each theorem's TPTP problem is reconstructed from the Otter
proof's own input clauses (axioms + Skolemized denial) into
`data/bol_moufang/tptp/thmN.p`, same `op/ldiv/rdiv` renaming as the other
corpora. **Twee proves all 9** (base flags, ≤2s each); traces retained in
`data/bol_moufang/twee/*.out`, summary in `.../summary.json`. Spot-check:
`extract_terms` pulls 348 proof terms from thm6's trace unchanged — the
existing extraction pipeline works on these traces as-is.

Metadata in `data/bol_moufang/metadata.json` (9 records, includes twee results).

### data/bml_aim — done

The 6 pre-existing TPTP goals (`data/bml_aim/tptp/3_goal_*.p`, from the
class-two AIM problem `3.in`: TT/TR/TL/RR/LL/RL inner-mapping commutation
goals) run with the same base flags, max_time 1000s, serial:
**all 6 proved**. Traces in `data/bml_aim/twee/*.out`.

| goal | statement (inner-mapping commutation) | cpu s | lemmas in proof |
|---|---|---:|---:|
| 3_goal_1 | T(T(u,x),y) = T(T(u,y),x) | 1.2 | 149 |
| 3_goal_2 | T(R(u,x,y),z) = R(T(u,z),x,y) | 15.9 | 218 |
| 3_goal_3 | T(L(u,x,y),z) = L(T(u,z),x,y) | 27.4 | 243 |
| 3_goal_4 | R(R(u,x,y),z,w) = R(R(u,z,w),x,y) | 29.9 | 468 |
| 3_goal_5 | L(L(u,x,y),z,w) = L(L(u,z,w),x,y) | 9.8 | 259 |
| 3_goal_6 | R(L(u,x,y),z,w) = L(R(u,z,w),x,y) | 39.2 | 351 |

## Notes / gotchas hit

- Prover9 `.pf` step lines sometimes start with `d,n` (demodulator id +
  clause id); Otter proof lines likewise. Both parsers handle it.
- The Otter archive misspells one "length of proof" as "legth"; the metadata
  regex tolerates it (thm8).
- twee reports `RESULT: Theorem` for fof-conjecture inputs and
  `RESULT: Unsatisfiable` for cnf denials — a proved-detector must accept
  both (first version of the runners grepped only "Unsat").
- CPU times via `run_twee_on_file` are only accurate when runs don't share a
  process (`RUSAGE_CHILDREN` is process-global); the Bol–Moufang numbers are
  from a serial re-run for that reason.

## Phase 0 checklist vs spec

- [x] AIM: download files
- [x] AIM: parse `.pf` proofs into equations/terms
- [x] AIM: expanded proofs via `prooftrans expand -f` (explicit paramodulation steps), parsed + metadata
- [x] AIM: re-run first_sketch (and second_sketch) with twee — attempted, 0/14 proved in 1000s (see above); .pf proofs remain the AIM corpus
- [x] AIM: record proof metadata
- [x] BM: download the Otter proofs archive
- [x] BM: inventory problems/proofs
- [x] BM: select 3 representative proofs (thm7 / thm2 / thm6)
- [x] BM: run twee, retain traces (9/9 proved)
- [x] bml_aim: run twee, retain traces — 6/6 proved

## Phase 1: Uniform proof-term extraction — done (2026-08-19)

New module `src/corpus/`:

- `extraction.py` — reduces all three proof sources to one record shape
  `{term, step, side, is_input}`:
  - **prover9** (parsed .pf JSONs): a real infix parser (binary `* \ /` with
    explicit parens, prefix applications like `a(x,z,z \ y)`, atoms). Exactly
    one depth-0 operator is permitted per level — more is a parse error, not
    a precedence guess. Variables follow Prover9's actual rule (any symbol
    starting `u`–`z`, which covers the numbered `v5`–`v8` that appear in big
    clauses); `1`→`unit`; each equation contributes lhs and rhs as separate
    records; `is_input` = justification is `assumption`.
  - **otter** (parsed qbm.json): steps already carry a prefix `tptp`
    rendering from phase 0; sides are split and alpha-normalized; denials
    and the final `$F` skipped.
  - **twee** (raw traces): wraps the existing
    `src/utils.py::extract_terms` (proof-chain lines); strips the TPTP
    quoting (`'K'`→`K`) so the signature matches the other sources.
  - Guarantees, per the spec: top-level terms of proof equations only;
    **multiplicity preserved** (one record per occurrence, proof order);
    **alpha-normalization** per term, A,B,C... by first occurrence (both
    sides of an equation normalize independently);
  - `stitch_input` / `babble_input` produce the encoder inputs via the
    existing `fof_to_lambda` / `fof_to_babble`.
- `test_extraction.py` — 11 tests (bare-assert style, like the other suites).
- `build_corpora.py` — walks every phase-0 proof and writes
  `data/corpora/<corpus>/<problem>__<variant>.json` (metadata + records +
  aligned stitch/babble encodings) and `data/corpora/manifest.json`.

Built: **66 corpora, 209,944 term occurrences, 56 MB** (gitignored;
regenerable by the script):

| corpus | files | terms (range) |
|---|---:|---|
| aim_lc plain | 21 | 862–5,652 per proof |
| aim_lc expanded | 21 | 1,096–11,398 per proof |
| bol_moufang otter | 9 | 50–140 |
| bol_moufang twee | 9 | 23–348 |
| bml_aim twee | 6 | 659–2,265 |

Verified end to end: `Stitch_Abstractions` and `Babble_Abstractions` both run
directly on a built corpus (thm7 otter: stitch finds
`fn_0(A, B) = rdiv(A, op(B, A))`, babble ratio 1.199), and the AIM
first_sketch corpora contain the associator definition among their input
records (`ldiv(op(A, op(B, C)), op(op(A, B), C))` and `a(A, B, C)`) — the
prerequisite for phase 2's definition erasure.

## Phase 2: AIM definition-erasure control — stitch done, babble running (2026-08-19)

New: `src/corpus/erasure.py` (+ 6 tests in `test_erasure.py`), driver
`src/corpus/run_phase2.py`, results in `data/concept_recovery/phase2/`.

**Erasure**: every occurrence of `a/K/L/R/T` in every corpus term is unfolded
into its definition (bottom-up, so `L(R(u,x,y),z,w)` unfolds fully; terms are
re-alpha-normalized because unfolding changes first-occurrence order — K swaps
its arguments' roles). The five defining equations' records are then dropped
(after unfolding they would be trivial `t = t` pairs injecting the answer
verbatim). Defining steps are detected structurally (input step with a bare
`sym(distinct vars)` side), not by hard-coded step ids. Erased corpora contain
no occurrence of any derived symbol (asserted in tests against real corpora).

**Recovery criterion**: an engine's abstraction body, alpha-normalized, equals
the hidden definition body ("alpha"), or contains it as a subterm ("subterm").
Rank = position in the engine's own ranked abstraction list.

### Stitch result: 5/5 on all 28 corpora

Stitch (iterations 10, max_arity 3, 0.6–4s per corpus) recovers **all five
hidden definitions as whole abstraction bodies on every corpus** — both
sketches, all 7 goals, plain and expanded. All matches are alpha-equivalent,
all within the top 8. On the larger corpora (Ka/aa*) the **top five
abstractions are exactly the five definitions**, e.g. first_sketch aa1:

    rank 1  fn_0(A,B,C) = ldiv(op(C, op(B, A)), op(op(C, B), A))   = a
    rank 2  fn_1(A,B,C) = ldiv(op(C, B), op(C, op(B, A)))          = L
    rank 3  fn_2(A,B)   = ldiv(op(A, B), op(B, A))                 = K
    rank 4  fn_3(A,B)   = ldiv(A, op(B, A))                        = T
    rank 5  fn_4(A,B,C) = rdiv(op(op(C, B), A), op(B, A))          = R

Rank patterns (full table: `data/concept_recovery/phase2/summary.md`):

- **Corpus size matters more than presentation.** Small corpora (aK1–aK3,
  660–2610 terms): L@1, a@2–3, K last (@5–8). Large corpora (Ka/aa*): a@1,
  L@2, K@3, T@4, R@5 — identical across first_sketch, second_sketch, and
  both expanded variants.
- **Answer to the phase-2 question**: proof presentation (hints vs none,
  demodulation-free vs not, expanded vs compact) barely affects stitch
  recovery — ranks shift by at most 1–2, membership never changes. The
  control behaves exactly as a control should.

### Babble (no theory): scaling limits + partial result

Babble at default beams (400) is infeasible on these corpora: 852 terms did
not finish one round in 600s, and 4014 terms was OOM-killed (exit -9,
macOS SIGKILL). At **beams 25** it becomes feasible: 69s/round on 852 terms,
and its rank-1 abstraction is exactly L's definition. The babble pass
(beams 25, 5 rounds — so at most five abstractions learned — timeout 1200s)
over the six smallest corpora, ~3–7 min each:

| corpus | terms | babble recovered (rank) |
|---|---:|---|
| first_sketch aK1 | 1290 | T@1, K@2, a@3, R@4, L@5 — **5/5** |
| first_sketch aK2 | 1290 | L@1, K@2, a@3, R@4, T@5 — **5/5** |
| first_sketch aK3 | 2610 | failed (killed ~73s; OOM, as on the 4k corpora) |
| second_sketch aK1 | 852 | R@2, a@3, L@4, T@5 — 4/5, K missing |
| second_sketch aK2 | 854 | a@1, L@2, T@3, R@5 — 4/5, K missing |
| second_sketch aK3 | 982 | T@1, a@2, L@4, R@5 — 4/5, K missing |

Where babble completes, it recovers 4–5 of the 5 hidden definitions within
its five slots. The consistent miss is instructive: on every second_sketch
corpus one slot goes to `fn(A,B) = op(A, op(A, B))` — the `x*(x*y)` pattern of
the **LC axiom** — which babble's e-graph-wide utility ranks above the
commutator K (K has only 72–91 occurrences there, vs 110+ in first_sketch,
where K makes the cut at rank 2). So the one visible presentation effect in
phase 2 belongs to babble, not stitch: the demodulation-free presentation
shifts frequency mass from K's body to the LC pattern.

Metrics stored per corpus in `data/concept_recovery/phase2/<name>.json`:
recovery {rank, match}, top-30 abstractions (uninterpreted ones included),
compression ratio (babble), timing, and `target_occurrences` — how often each
hidden body occurs as a subterm in the erased corpus (T up to 3,170; R as low
as 20). The occurrence counts explain the rank patterns: `a` ranks first on
large corpora despite middling frequency because its body is the largest, so
each use compresses more.

## Phase 3: primitive Bol–Moufang recovery — done (2026-08-20)

New: `src/corpus/equiv.py` (+ 8 tests), driver `src/corpus/run_phase3.py`,
recheck `recheck_phase3_equational.py`, analysis `analyze_phase3.py`.
Results in `data/concept_recovery/phase3/` (`summary.md`, `fallback.md`).

No erasure here — these are primitive quasigroup proofs over `{*, \, /}` in
which the loop-theoretic concepts were never named. Both engines were run on
all 18 corpora (9 theorems × Otter + twee), matching in three tiers:

    alpha       body alpha-equivalent to the construction
    subterm     construction occurs inside a larger body
    equational  provably equal under the problem's own axioms

The third tier is the spec's "provably equivalent under the background
equations", automated: each (body, construction) pair becomes a TPTP unit
equality problem discharged by **twee itself**, tried over every permutation
of the construction's variables. Matching runs on `expand_abstractions`-ed
bodies (so a construction assembled from nested `fn_i` still counts) while
ranks stay tied to each engine's own raw list.

### Result: nothing recovered, and the reason is not the compressors

**No standard construction is recovered on any of the 18 corpora, at any tier,
by either engine.** The explanation is in `fallback.md`: across all 18 corpora
and 2,109 term occurrences, the five constructions occur as subterms a total
of **four times** — `T` three times, `L` once, and `a`, `K`, `R` never.

| construction | occurrences in all 18 primitive corpora |
|---|---:|
| a (associator) | 0 |
| K (commutator) | 0 |
| L | 1 |
| R | 0 |
| T | 3 |

A compressor cannot abstract a pattern the proofs never build. The deeper
reason is a corpus-choice issue worth recording: **the associator, commutator
and the L/R/T inner mappings are *loop* concepts, presupposing an identity
element, whereas these are *quasigroup* theorems** — two of them (thm3, thm4)
are literally proving that an identity exists. The Bol–Moufang corpus was
picked for being primitive, but primitiveness cut both ways: it is primitive
*below* the level at which the target concepts are definable.

**This negative result is warranted, not an artifact.** `test_equiv.py`
establishes that the tier-3 checker fires when a construction really is
present: a body equal to `R` the long way round
(`rdiv(op(op(rdiv(op(A,B),B),B),C), op(B,C))`, using `op(rdiv(op(A,B),B),B) =
op(A,B)`) is proved equivalent with its witness returned, a false pair is
rejected, and the whole tier fires end to end through the matcher. A first
pass had a 60s tier-3 budget that was exhausted on 22 of 36 runs, so its "no
match" was only partial; the recheck re-ran those with a 240s budget and a
per-problem memo — **every run now completes the equational tier**, and the
verdict is unchanged.

### Fallback: what *did* emerge

Per the spec's instruction to inspect the highest-ranking repeated
constructions instead, the concept that emerges is the **local identity**
`x\x` / `x/x` — the quasigroup stand-in for the identity element — and it
emerges exactly where the mathematics says it should:

- **rank 1** for both engines on `thm3__twee` ("Every LG2 quasigroup is a
  right loop") and rank 1 for stitch on `thm4__twee` ("Every LC3 quasigroup is
  a left loop") — the two theorems whose entire content is that an identity
  exists. On thm4 stitch's top abstraction is the nested
  `ldiv(rdiv(A, A), rdiv(A, A))`, i.e. `(x/x)\(x/x)`.
- top-4 on 13 of the 18 corpora.

Also recurrent across corpora (7 of 36 runs put it in the top 5) is
`rdiv(A, op(B, A))` — which is `T`'s body with right division substituted for
left, the mirror of the `T` inner mapping adapted to a setting with no
identity. So the engines do find structural analogues of the targets, fitted
to the quasigroup signature, rather than the loop-theoretic originals.

So the answer to the phase-3 question — *do human loop-theoretic concepts
emerge from proofs in which those concepts were never named?* — is: **not
these concepts from these proofs**, because the proofs never construct them;
but the engines do surface the concept each proof is actually about.

### Known limitation

The equational tier only compares bodies with the **same number of
variables** (`test_differing_variable_counts_are_skipped` pins this). An
abstraction equal to a construction but carrying an eliminable extra variable
would be missed. Given the occurrence counts above this cannot account for the
negative result, but it is a real gap if the tier is reused elsewhere.

## Phase 3.5: concepts removed from the prover's *input* — done (2026-08-20)

New: `src/corpus/definition_free.py`, `hint_goals.py`, `run_phase35.py`,
`analyze_phase35.py`. Results in `data/concept_recovery/phase35/`
(`summary.md`, per-run JSON); problems in `data/definition_free/`.

Phase 2 erased the derived operations *after the fact*, from proofs found with
them available. Here they are removed from the input: the five defining
equations are deleted and every axiom and goal is unfolded into the primitive
loop signature, so **the prover never sees `a`, `K`, `L`, `R` or `T`**. Each
prover gets 60s; a failed search still contributes its partial proof (twee's
top-scoring derived lemmas, Prover9's kept clauses). 46 runs: 6 bml_aim goals
+ 7 AIM goals + 10 hint-derived goals, × {twee, prover9}.

### Result: the commutator is rediscovered at rank 1

On every AIM goal twee proved without the definitions, **stitch's top
abstraction is the commutator**:

| goal | twee | terms | K pattern occs | stitch |
|---|---|---:|---:|---|
| aK1 | proved | 407 | 116 | **K@1**, T@4 |
| aK2 | proved | 390 | 107 | **K@1** |
| aK3 | proved | 198 | 42 | **K@1**, T@2 |

On bml_aim goal_1, twee's proof gives **T@1** exactly plus **K@3 via the
equational tier** (a body twee itself proved equal to K's definition), and
prover9's proof of the same goal gives **T@1, a@5, K@9**. On goal_4 prover9
recovers a@1, R@2, K@3.

### twee vs Prover9: a real gap, but smaller than first reported

Prover9 also **proves** aK1-aK3 definition-free, yet stitch recovers nothing
from those proofs while twee's yield K@1. The corrected pattern counts:

| goal | prover | terms | a/K/L/R/T pattern occurrences | recovered |
|---|---|---:|---|---|
| aK1 | twee | 407 | 2 / **116** / 0 / 3 / 40 | K@1, T@4 |
| aK1 | prover9 | 262 | 2 / 7 / 4 / 0 / 1 | – |
| aK2 | twee | 390 | 2 / **107** / 0 / 3 / 43 | K@1 |
| aK2 | prover9 | 302 | 2 / 14 / 3 / 0 / 8 | – |

An earlier version of this section reported 116 vs **2** and concluded that
"the calculus decides". Two of that gap's causes turned out to be mine, and
the corrected figure is 116 vs 7-14. The gap is real but roughly an order of
magnitude smaller than claimed, and on bml_aim the direction is not even
consistent (there Prover9's proof has T x361 and recovers K, T and `a`, while
twee's partial proofs on the same goals recover only T).

**Bug: the goal-refutation chain was being discarded.** The Prover9 extraction
skipped any clause containing `!=` -- which is the whole refutation chain,
Prover9's analogue of twee's goal proof chain, and the twee side *was*
included. That dropped ~20% of an expanded proof and made the comparison
asymmetric by construction. Fixed in `run_phase35.py`.

**Presentation: Prover9 folds rewrite sequences into one step.** See the
minimal example below.

### Minimal example: `data/minimal_example/`

`K = ldiv(op(a,b), op(b,a))` wrapped in five identity multiplications that must
be peeled one at a time. `K` itself is never rewritten -- only its context.
Same problem, same five inferences:

- **twee** prints an equational chain: 6 lines, each the whole term, so `K` is
  re-counted at every step.
- **Prover9** folds all five rewrites into a single justification
  `[copy(8),rewrite([2(20),2(19),2(18),2(17),2(16)])]`.

| source | terms | K occurrences |
|---|---:|---:|
| twee (chain) | 6 | 6 |
| Prover9 (compact) | 6 | 4 |
| Prover9 (`prooftrans expand`) | 16 | **14** |

So on a controlled case the ordering **reverses**: expanded Prover9 proofs are
*richer* in construction occurrences than twee chains. Both the extraction bug
and the folding of rewrite sequences were inflating the apparent gap.

### Why the residual gap? (hypothesis, partly tested)

All figures below re-verified against the regenerated corpora after every fix.

Paramodulation and critical-pair generation are near-equivalent inference
systems, so a 10x difference in construction density needs explaining.

Tested and **rejected**: that `--show-peaks` inflates twee's output. Removing
it gives identical counts (407 terms, K x116).

The evidence points at *what each prover retains and prints*, not what it can
infer:

- twee's 116 occurrences sit in **89 distinct terms**, at most 3 per term, and
  contain **variables** (e.g. `op(ldiv(op(A, B), op(B, A)), op(A, B))`) --
  general lemmas, not one goal chain repeated. **99%** of twee's terms are
  non-ground.
- Prover9's expanded proof spreads its K occurrences over just **5 terms**
  (max 2 each) out of 724, and is **13% ground**. It carries 4x more `ldiv`
  than twee overall, but that mass sits in `ldiv(x, unit)` shapes rather than
  commutator shapes.

Hypothesis: twee completes toward general equational lemmas, and since the
goal *is about* the commutator, many lemmas come out commutator-shaped;
Prover9 refutes a Skolemized goal and works over ground instances that
demodulate into a different normal form. The divergence is in the objects each
calculus accumulates -- general lemmas vs normalised ground consequences --
not in the inferences available to it.

This is consistent with the measurements but not demonstrated. The clean test
is to make both produce the same *kind* of object: run twee refutationally on
the Skolemized goal, or Prover9 in a saturating mode retaining lemmas.

### Four bugs found and fixed (two invalidated published claims)

**1. Prover9 variable convention.** Without `set(prolog_style_variables)`,
Prover9 treats a symbol beginning with u-z as a *variable* and everything
else — including upper case — as a **constant**. The generated `.in` files
carried TPTP's upper-case variables, so every axiom was a ground fact.
Confirmed decisively: `mult(e,A) = A ⊢ mult(e,c) = c` fails while the
lower-case form proves. Variables are now emitted as `v0, v1, …`.

**2. `zero` was also a variable.** It begins with `z`. The identity axioms
became `mult(x,y) = y` and `mult(x,y) = x`, which are jointly
**inconsistent** — Prover9 was "proving" every bml_aim goal in four steps by
first deriving `x = y`. Renamed to `e0`; a consistency probe now confirms the
axioms do not prove `x = y`.

> *These two invalidated the entire first Prover9 pass.* It had reported that
> Prover9 makes essentially no progress on the definition-free AIM problems,
> and that its apparent recoveries were artefacts of unfolded axioms. **That
> claim was a bug in the encoding, not a property of the problems, and is
> withdrawn.** Prover9 in fact proves aK1–aK3 (3/7 AIM goals), bml_aim goal_1
> and goal_4, and 6 of the 10 hint goals.

**3. The goal-refutation chain was discarded.** The Prover9 extraction skipped
any clause containing `!=` — which is the whole refutation chain, Prover9's
analogue of twee's goal proof chain, and the twee side *was* included. It
dropped ~20% of an expanded proof and made the comparison asymmetric by
construction. Fixed in `run_phase35.py`.

> *This invalidated the size of the twee/Prover9 gap.* The section above
> originally reported 116 vs **2** and concluded "the calculus decides";
> corrected, it is 116 vs 7–14, and on bml_aim the direction reverses.

**4. twee's multi-character variables.** twee names variables `X, Y, Z, W, V,
U` and then `X2, Y2, …`; `normalize_fof_term` matched only single letters, so
`X2` was silently treated as a constant in every term using more than six
variables — a false-negative source in matching. Fixed in `src/utils.py`
(regression test in `test_extraction.py`). This was latent for the main
pipeline too, not only this experiment.

A fifth, in the analysis rather than the data: `analyze_phase35.py` counted
patterns over *all* Prover9 kept clauses while the driver compressed the
proof, so its columns described a different corpus than its recovery column —
visible as identical pattern counts across seven different goals.

### Two measurement corrections

**Partial proofs needed the repo's existing treatment.** A twee run that
gives up prints every lemma it derived — 77,529 terms for one goal. The
`partial_abs` stage in `worker.py` already scores lemmas and keeps the top-k;
adopting that (`PARTIAL_TOPK = 60`) cut that corpus to 516 terms.

**Occurrence counts must be measured as patterns.** `target_occurrences`
counts subterms alpha-normalising to a definition body, i.e. with *variable*
arguments, but an abstraction `fn(A,B) = ldiv(A, op(B,A))` applies wherever
that *shape* occurs. On one partial proof T's pattern occurs 67 times while
its variable-argument form occurs zero — which is why a recovery once looked
like it contradicted the occurrence column.

### Expanded Prover9 proofs (`prooftrans expand`)

Works directly on stored Prover9 stdout, not only `.pf` files. On aim_lc
goal_1 it takes the proof from 337 to 875 steps, turning 90 compound
`back_rewrite` justifications into explicit paramodulations (231 -> 761
`para`). On the minimal example above it raises K occurrences from 4 to 14.

On the real aim_lc proofs it helps much less (K: 7 -> 8) and does not change
recovery. So expansion is worth having as a corpus variant -- it is the right
way to undo the rewrite-folding shown above -- but it does not by itself close
the twee/Prover9 gap on these goals.

### Answer to the phase-3 question, this time affirmative

Phase 3 found nothing because the Bol–Moufang proofs never build the
constructions. Phase 3.5 asks the same question of proofs whose content *is*
loop-theoretic with the concepts unnamed: **the commutator and the T inner
mapping are re-identified as top abstractions of proofs that never named
them.** Scope, stated honestly: unfolding leaves their bodies in the input, so
this shows compression re-identifies the right units from a primitive proof —
not that concepts appear from nothing. What makes it non-trivial is that the
prover chose its own route and a different prover's route yields nothing.

## Next

- **Expanded Prover9 proofs as a corpus variant.** `prooftrans expand -f` runs
  on the stored definition-free Prover9 output and roughly doubles the term
  count with explicit paramodulation steps. Preliminary check (above) shows it
  does not change recovery on aim_lc goal_1, but it has not been run across
  the matrix; the natural shape is a `--expanded` flag on `run_phase35.py`
  producing `<problem>__prover9_expanded` runs alongside the compact ones,
  exactly as Phase 0 keeps `*_expanded.pf` alongside `*.pf`.
- **Phase 4** (Stitch vs Babble, incl. babble-modulo-theory) is now the main
  remaining item. The phase-3.5 corpora are the natural target: they are the
  ones where concepts are demonstrably recoverable. Babble has not yet been
  run on them (`--engines babble`, low beams per the scaling limits). Note the AIM corpora are the ones with concepts to recover,
  so phase 4's theory experiments belong there rather than on Bol–Moufang.
- Optional: a corpus whose proofs *are* loop-theoretic but leave the concepts
  unnamed would be the real test of the phase-3 question; `data/bml_aim`
  (6 twee proofs, AIM signature) is the closest available candidate and has
  not yet been compressed.
