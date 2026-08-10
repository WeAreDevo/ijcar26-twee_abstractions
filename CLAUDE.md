# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Research project implementing the [Twitch paper](https://arxiv.org/abs/2603.06849): learning proof abstractions for equational theorem proving using the Twee prover and the Stitch program synthesis library.

## Setup

**Prerequisites:** Python 3.11.x, TPTP v9.2.1 (download separately), a `twee` executable with hints support.

```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

Create `.env` in the repo root:
```
TPTP_ROOT=<path_to_tptp_root>
LOG_DIR=<storage_location_for_logs>
TWEE_PATH=<path_to_twee_executable>
```

## Running Experiments

Main entry point: `src/stitch/pipeline/worker.py`

```bash
# See all options
python src/stitch/pipeline/worker.py --help

# Base stage (required first — produces baseline proofs)
python src/stitch/pipeline/worker.py --stage base --stage_config src/stitch/configs/base.yaml \
  --input_dir data/TPTP/ALG_UEQ_UNSAT --output_dir data/experiments/base

# Local abstractions (requires --base_dir from base stage)
python src/stitch/pipeline/worker.py --stage local_abs --stage_config src/stitch/configs/local_abs.yaml \
  --input_dir data/TPTP/ALG_UEQ_UNSAT --base_dir data/experiments/base \
  --output_dir data/experiments/local_abs

# Domain abstractions (requires --base_dir and --local_abs_dir)
python src/stitch/pipeline/worker.py --stage domain_abs --stage_config src/stitch/configs/domain_abs.yaml \
  --input_dir data/TPTP/ALG_UEQ_UNSAT --base_dir data/experiments/base \
  --local_abs_dir data/experiments/local_abs --output_dir data/experiments/domain_abs

# Partial abstractions (self-contained)
python src/stitch/pipeline/worker.py --stage partial_abs --stage_config src/stitch/configs/partial_abs.yaml \
  --input_dir data/TPTP/ALG_UEQ_UNSAT --output_dir data/experiments/partial_abs
```

Each run creates a **timestamped subdirectory** inside `--output_dir` with a config copy and results summary. Detailed logs (twee outputs, TPTP files with hints) go to `LOG_DIR`. Note that the existing directories in `data/experiments/` were produced from earlier code, and so the exact directory structure may differ for new runs. In particular, previously the config contained a 'theory' field which was used to choose the input problems, and the subdirectory was named with the theory. But now the input problems are directly specified by the `--input_dir` argument, so the new output directories won't be organized by theory like the old ones.

## Running Tests

```bash
python src/stitch/test_translation.py
```

This tests the FOF term ↔ lambda calculus translation logic in `src/stitch/Abstractions.py`.

## Architecture

### Pipeline Stages

The 4-stage pipeline is designed so intermediate results can be reused across experiments:

1. **base** — Runs Twee with default flags to produce baseline proofs.
2. **local_abs** — Extracts Stitch abstractions from a problem's own baseline proof; re-runs Twee with those abstractions as hints.
3. **domain_abs** — Pools good local abstractions from many problems in the same domain (e.g., ALG, BOO, GRP); applies them as hints to new problems in that domain.
4. **partial_abs** — Runs Twee for a short timeslice to get a partial proof, extracts abstractions, re-runs with full time.

### Key Files

| File | Purpose |
|------|---------|
| `src/stitch/pipeline/worker.py` | Orchestrates all 4 stages; parallel problem execution via `ProcessPoolExecutor` |
| `src/stitch/Abstractions.py` | Core abstraction generation: FOF→lambda translation, Stitch calls, hint wrapping |
| `src/stitch/domain_abstractions.py` | Domain-level abstraction aggregation across problems |
| `src/utils.py` | Twee subprocess execution, proof parsing, term extraction, TPTP utilities |
| `src/stitch/configs/*.yaml` | Per-stage experiment parameters (twee flags, stitch iterations, timeouts) |
| `data/experiments/util.py` | Loading and aggregating experiment result files |
| `data/experiments/analysis.py` | Statistical analysis of results |

### Abstraction Flow

1. Twee proof output → parse proof terms (`src/utils.py`)
2. Terms → Stitch compression → named abstractions (`src/stitch/Abstractions.py`)
3. Abstractions → TPTP hint format → next Twee run
4. Results stored as `summary.json` + raw outputs per problem

### Data Layout

- `data/TPTP/` — Problem files organized as `{THEORY}_UEQ_{STATUS}/` (e.g., `ALG_UEQ_UNSAT/`). `ALG_UEQ_UNSAT/` contains union of all therory-specific unsat problems.
- `data/experiments/` — Experiment output directories (gitignored due to size; large outputs go to `LOG_DIR`)

### Term Representation

- Problems are in FOF (first-order formula) format
- Internally, terms are parsed to nested Python lists and converted to lisp-like lambda calculus with De Bruijn indices for variable handling
- The `parse_fof_term()` / lisp conversion functions in `src/utils.py` and `src/stitch/Abstractions.py` handle this translation
- Twee takes input in TPTP format.
