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

## Next

- **Phase 4** (Stitch vs Babble, incl. babble-modulo-theory) is now the main
  remaining item. Note the AIM corpora are the ones with concepts to recover,
  so phase 4's theory experiments belong there rather than on Bol–Moufang.
- Optional: a corpus whose proofs *are* loop-theoretic but leave the concepts
  unnamed would be the real test of the phase-3 question; `data/bml_aim`
  (6 twee proofs, AIM signature) is the closest available candidate and has
  not yet been compressed.
