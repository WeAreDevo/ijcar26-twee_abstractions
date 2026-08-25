# CLAUDE.md

Guidance for Claude Code (claude.ai/code) working in this repository.

## Project Overview

Research project on **learning proof abstractions for equational theorem
proving**. Two lines of work share the repo:

1. **Abstraction-as-hints pipeline** (original): compress Twee proof terms into
   abstractions, feed them back as hints. Implements the
   [Twitch paper](https://arxiv.org/abs/2603.06849).
2. **Concept recovery** (`src/corpus/`, since 2026-08): can a compressor
   rediscover named mathematical concepts (associator, commutator, inner
   mappings) from proofs where they were never named? See
   `proof_compression_concept_recovery_experiment.md` for the spec and
   `PROGRESS_concept_recovery.md` for the running record — **read the latter
   first**, it has a "State at a glance" block.

Compression engines: **Stitch** (pip, default), **babble** (built from source,
optional), and **GAPT** Herbrand decomposition (`src/gapt/`, see
`PROGRESS_herbrand.md`) — the last emits a *quantified lemma* rather than a
term pattern.

## Setup

Python 3.11.x, TPTP v9.2.1, a `twee` with hints support, LADR/Prover9.

```bash
python -m venv venv && source venv/bin/activate && pip install -r requirements.txt
```

`.env` in the repo root:

```
TPTP_ROOT=<TPTP root>          LOG_DIR=<bulky logs, outside the repo>
TWEE_PATH=<twee executable>    LADR_DIR=<LADR-2009-11A>
BABBLE_ROOT=<third_party/babble>   VAMPIRE_PATH=<vampire>
GAPT_ROOT=<third_party/gapt-2.19.0>
```

## Landmines (each of these silently produced a wrong result)

- **Prover9 variable convention.** Without `set(prolog_style_variables)`, a
  symbol is a *variable* iff it begins with `u`–`z`; everything else,
  **including upper case, is a constant**. TPTP's `A, B, C` carried into a
  `.in` file turns every axiom into a ground fact. Worse, a *constant*
  starting u–z becomes a variable: `zero` did, making the loop axioms
  inconsistent so Prover9 "proved" goals in four steps via `x = y`. Emit
  variables as `v0, v1, …`; rename `zero`→`e0`. **Probe consistency (can the
  axioms prove `x = y`?) before trusting any generated problem.**
- **twee variable naming.** twee uses `X, Y, Z, W, V, U` then `X2, Y2, …`.
  Code matching only single-letter variables treats `X2` as a constant.
- **Proof-format asymmetry.** twee prints an equational *chain* (the whole
  term at every step); Prover9 prints one equation per inference and folds
  rewrite sequences into a single justification. Any cross-prover comparison of
  term/subterm counts is dominated by this until it is controlled for.
  `data/minimal_example/` isolates the effect — start there when a
  cross-prover comparison looks surprising. `prooftrans expand -f` (LADR)
  makes Prover9's paramodulation steps explicit and works on stored stdout.
- **twee result strings.** `RESULT: Theorem` for fof conjectures,
  `RESULT: Unsatisfiable` for cnf denials. Detectors must accept both.
- **babble scale.** OOM-killed above ~2.6k terms at default beams; the failure
  surfaces as `RuntimeError: babble failed (exit -9)`. Use `beams=25`–100.
- **CPU timing.** `run_twee_on_file` uses `RUSAGE_CHILDREN`, which is
  process-global — only accurate when runs do not share a process.
- **GAPT needs `prooftrans` on PATH** (`$LADR_DIR/bin`) for any Prover9
  import; `Prover9Importer.isInstalled` does not check for it and reports
  `true` regardless. `gapt.cli.CLIMain` swallows exceptions and exits 0, and
  GAPT's own `withTimeout` does not bound the decomposition — the outer
  subprocess timeout in `src/gapt/run_gapt.py` is load-bearing.

## Running things

```bash
# original pipeline (base must run first; see --help for all stages)
python src/stitch/pipeline/worker.py --stage base \
  --stage_config src/stitch/configs/base.yaml \
  --input_dir data/TPTP/ALG_UEQ_UNSAT --output_dir data/experiments/base

# concept recovery
python src/corpus/build_corpora.py          # rebuild data/corpora/ (gitignored)
python src/corpus/run_phase2.py --help      # AIM definition erasure
python src/corpus/run_phase3.py --help      # primitive Bol-Moufang
python src/corpus/definition_free.py        # build definition-free problems
python src/corpus/run_phase35.py --help     # run provers + compress
python src/corpus/analyze_phase35.py        # regenerate summaries

# herbrand/GAPT
python src/gapt/run_gapt.py <prover9 .out> [--method M] [--timeout S] [--json]

# smoke tests / engine comparison
python run_stitch.py ; python run_babble.py ; python compare_engines.py
```

**Long runs get killed.** Keep each invocation under ~10 minutes and make
runners resumable: `--skip-existing` (don't redo finished work) and
`--reuse-proofs` (re-extract and recompress stored prover output without
re-proving). Keep the expensive step (running provers) separate from analysis
so a bug fix costs a re-analysis, not a re-experiment.

## Tests

```bash
python src/corpus/test_extraction.py    # proof-term extraction, all 3 sources
python src/corpus/test_erasure.py       # definition erasure + recovery matching
python src/corpus/test_equiv.py         # twee-backed equational matching
python src/stitch/test_translation.py   # FOF <-> lambda (Stitch)
python src/babble/test_translation.py   # FOF <-> curried (babble) + theory
python src/gapt/test_run_gapt.py        # GAPT output parsing (no GAPT needed)
```

Several of these exist specifically to **pin conventions** (e.g. that `X2` is a
variable) — that bug class is the main source of wrong answers here. Tests
depending on generated data skip rather than fail when it is absent.

## Architecture

| Path | Purpose |
|---|---|
| `src/stitch/pipeline/worker.py` | 4-stage hint pipeline (base, local_abs, domain_abs, partial_abs) |
| `src/stitch/Abstractions.py` | FOF→lambda translation, Stitch calls, hint wrapping |
| `src/babble/Abstractions.py` | Same contract for babble (curried encoding) |
| `src/babble/theory.py` | TPTP axioms → babble `--dsr` rewrite rules |
| `src/corpus/extraction.py` | Uniform proof-term extraction: Prover9 `.pf`, Otter, twee |
| `src/corpus/erasure.py` | Unfold/erase `a,K,L,R,T`; match learned abstractions |
| `src/corpus/equiv.py` | "Provably equal under the axioms?" discharged by twee |
| `src/corpus/definition_free.py` | Delete definitions from problem *inputs* |
| `src/gapt/cutintro.scala` | GAPT harness: Prover9 proof → decomposition → lemma |
| `src/gapt/run_gapt.py` | Wrapper: PATH fix, outer timeout, output parsing |
| `src/utils.py` | Twee subprocess, proof parsing, normalization, TPTP helpers |

All corpora share one signature: `op` / `ldiv` / `rdiv` / `unit` / `zero`.
Terms are prefix FOF, alpha-normalized to `A, B, C, …` by first occurrence.

## Data layout

- `data/TPTP/` — problems, `{THEORY}_UEQ_{STATUS}/`
- `data/aim_lc/`, `data/bol_moufang/`, `data/bml_aim/` — proof corpora + parsers
- `data/definition_free/` — definition-free problems (raw output gitignored,
  gzipped in `$LOG_DIR/definition_free_out/`)
- `data/concept_recovery/phase{2,3,35}/` — results, `summary.md` per phase
- `data/corpora/` — **gitignored**, rebuild with `build_corpora.py`
- Bulky artifacts go to `$LOG_DIR`, never into git.

## Working style that has paid off here

- **Controls before believing a negative.** A "nothing found" result is worth
  nothing unless the detector is shown to fire on a true positive and reject a
  false one (`test_equiv.py` does this).
- **Minimal example when a comparison surprises**, rather than reasoning about
  the large case.
- **Verify numbers against the data before writing them up.** Stale figures and
  mismatched corpora have both slipped into summaries here.
- Record **withdrawn claims** next to live ones in the progress doc, so it is
  clear which conclusions depended on which bug.
