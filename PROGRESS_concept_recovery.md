# Progress: Proof-Compression Concept-Recovery Experiment

Tracks work against `proof_compression_concept_recovery_experiment.md`.
Started 2026-08-19.

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

## Next (Phase 1)

Uniform proof-term extraction across the three proof sources (Prover9 .pf,
Otter archive, twee traces). The parsed JSONs already expose per-step
equations for the first two; twee traces already work with
`src/utils.py::extract_terms`. Remaining: subterm extraction option,
multiplicity, alpha-normalization (exists: `normalize_fof_term`), and export
to the Stitch/Babble input formats (exists: `fof_to_lambda`, `fof_to_babble`).
