# Twitch: Learning Abstractions for Equational Theorem Proving

Source code, data, and experimental results for the paper
**Twitch: Learning Abstractions for Equational Theorem Proving**
(G. Axelrod, M. Johansson, N. Smallbone). The paper PDF is included as
[`paper.pdf`](paper.pdf).

Twitch discovers *abstractions* — term patterns that recur in proofs — using the
[Stitch](https://github.com/mlb2251/stitch) compression library, and feeds them
to the [Twee](https://github.com/nick8325/twee) equational prover to guide its
search. Abstractions are learned in two ways: from a **partial** (failed) proof
of a hard problem, and from **successful proofs of easier problems in the same
domain**.

## Setup

### Prerequisites

- Python 3.11.x (tested with 3.11.5 and 3.11.11).
- A copy of **TPTP v9.2.1** (download from the [TPTP Archive](https://tptp.org/TPTP/Archive/)).
  The UEQ problems used in the paper are already included under `data/TPTP/`;
  `TPTP_ROOT` is needed to resolve TPTP axiom includes.
- A **`twee` executable with abstraction support** (the `--hint-skel-*` flags
  used by the configs below).
- *(optional, for the babble backend)* a **Rust toolchain**, to build
  [babble](https://github.com/dcao/babble) from source — see below.

### Install

```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

Create a `.env` file in the repo root:

```
TPTP_ROOT=<path to your TPTP root>
TWEE_PATH=<path to your twee executable>
LOG_DIR=<directory for full logs and raw twee/TPTP output>
BABBLE_ROOT=<path to your babble checkout>   # only for the babble backend
```

`LOG_DIR` receives the bulky per-problem artifacts (twee output, TPTP files with
hints added). Result summaries go under the `--output_dir` you pass on the
command line.

### Optional: the babble compression backend

Abstractions are learned with [Stitch](https://github.com/mlb2251/stitch) by
default, which installs from `requirements.txt` like any other Python package.
[babble](https://github.com/dcao/babble) is an alternative backend, built from
source:

```bash
git clone https://github.com/dcao/babble.git third_party/babble
cd third_party/babble && cargo build --release --bin=fof
```

Four local patches are needed and are **not** upstream, so they must be
reapplied on a fresh clone:

1. `src/ast_node/expr.rs` — replace `Self(node)` with `Expr(node)` inside the
   nested `build` function. Newer rustc rejects referencing `Self` from an
   inner item (`E0401`); babble predates that becoming a hard error.
2. `src/bin/fof/main.rs` — a new binary, copied from `src/bin/list/main.rs`.
   It reuses the `list` binary's `ListOp` language (whose `Ident` catch-all
   accepts arbitrary function symbols) but prints the learned expression as a
   raw single-line s-expression instead of via babble's `Pretty` formatter,
   which sugars away the `@` applications and de Bruijn indices that the
   back-translation needs.
3. `src/extract/beam.rs` — `LibExtractor::best` falls back to a plain
   size-based extraction instead of panicking. Its memo caches a provisional
   `None` while breaking cycles, so a class can end up recorded as
   unextractable when it is not. Any rewrite that puts an e-class inside
   itself reaches this, which the axiom theories below routinely do.
4. `src/experiments/beam_experiment.rs` — a `dsr_node_limit` on the rewrite
   saturation runner, which previously had no node limit at all (unlike the
   lib-learning runner beneath it).

Then point `BABBLE_ROOT` at the checkout. Smoke-test with `python run_babble.py`,
and run `python src/babble/test_translation.py` for the translation tests (which
need neither the binary nor `BABBLE_ROOT`).

Note that babble writes `target/rec_expr` relative to the working directory and
unwraps the result, so it must be run from `BABBLE_ROOT` — `run_babble` does this.

#### Compressing modulo a theory

babble's distinguishing feature is that it takes an equational theory and
compresses modulo it, so it can share structure between subterms that are equal
under the axioms but not syntactically identical. `src/babble/theory.py` builds
that theory from a TPTP problem's own axioms:

```bash
python run_babble.py data/TPTP/LAT_UEQ_UNSAT/LAT005-10.p
```

To see what this buys, `compare_engines.py` runs Stitch, babble, and babble
with the theory over corpora whose terms are rearrangements of each other under
the associativity and commutativity of `add`:

```bash
python compare_engines.py            # constructed examples, a few seconds
python compare_engines.py --real     # also a real twee proof, ~45s
```

The middle configuration is the point: without it you cannot tell whether a
difference came from switching engines or from adding the theory.

TPTP equations are symmetric but babble's rules are directed, so each axiom
yields up to two rules, and a direction is dropped when egg could not use it or
when it would make the e-graph pathological. `directed_rules` documents the four
conditions. The most consequential is the last: rules that collapse a term to
one of its own subterms (absorption, idempotence, the identity laws) are
excluded by default, because together with associativity and commutativity they
send the e-matcher into a search that egg cannot interrupt — a 40-term corpus
goes from ten seconds to not finishing in two minutes. Pass
`include_collapsing=True` to get them back.

## Running experiments

The single entry point is `src/stitch/pipeline/worker.py`. It runs one **stage**
at a time over a directory of TPTP problems, writing a timestamped subdirectory
(config copy + `summary.json`) inside `--output_dir`. Stages are split so
intermediate results can be reused:

| Stage        | What it does | Extra inputs |
|--------------|--------------|--------------|
| `base`       | Runs Twee with default flags to produce baseline proofs. | – |
| `local_abs`  | Extracts Stitch abstractions from each problem's own base proof, re-runs Twee with them as hints. | `--base_dir` |
| `domain_abs` | Pools good local abstractions across problems in a domain, applies them to new problems in that domain. | `--base_dir`, `--local_abs_dir` |
| `partial_abs`| Runs Twee for a short timeslice, extracts abstractions from the partial proof, re-runs with the full time budget. | – |

Common arguments: `--stage`, `--stage_config` (a YAML config from
`src/stitch/configs/`), `--input_dir` (TPTP problems), `--output_dir` (result
summaries). Run `python src/stitch/pipeline/worker.py --help` for the full list.

```bash
# 1. Base proofs (required before local_abs or domain_abs stages)
python src/stitch/pipeline/worker.py --stage base \
  --stage_config src/stitch/configs/base.yaml \
  --input_dir data/TPTP/ALG_UEQ_UNSAT \
  --output_dir data/experiments/base

# 2. Local abstractions (needs the base output)
python src/stitch/pipeline/worker.py --stage local_abs \
  --stage_config src/stitch/configs/local_abs.yaml \
  --input_dir data/TPTP/ALG_UEQ_UNSAT \
  --base_dir data/experiments/base \
  --output_dir data/experiments/local_abs

# 3. Domain abstractions (needs base + local_abs output)
python src/stitch/pipeline/worker.py --stage domain_abs \
  --stage_config src/stitch/configs/domain_abs.yaml \
  --input_dir data/TPTP/ALG_UEQ_UNSAT \
  --base_dir data/experiments/base \
  --local_abs_dir data/experiments/local_abs \
  --output_dir data/experiments/domain_abs

# 4. Partial-proof abstractions (self-contained)
python src/stitch/pipeline/worker.py --stage partial_abs \
  --stage_config src/stitch/configs/partial_abs.yaml \
  --input_dir data/TPTP/ALG_UEQ_UNSAT \
  --output_dir data/experiments/partial_abs
```

The `--input_dir` selects the problem set. `data/TPTP/{ALG,BOO,COL,GRP,LAT,LCL,REL,RNG,ROB}_UEQ_UNSAT/`
hold the nine domains of unsatisfiable UEQ problems evaluated in the paper
(Table 1); each stage treats a `..._UEQ_UNSAT` directory as one domain.

Experiment behaviour (twee flags, Stitch iterations/arity, goodness threshold,
abstraction weight factor, partial proof timeslice, etc.) is controlled by the `--stage_config` YAML file.
See Appendix A of the paper for the parameter values used; the configs in
`src/stitch/configs/` are ready-to-run starting points.

## Where to find the results mentioned in the paper

Experiment outputs are under `data/experiments/`:

- **`hard_successes/`** — the hard problems Twitch solves, matching **Appendix C**
  of the paper. Each JSON maps a problem to the winning abstractions, timing, and config:
  - `partial.json` — solved with partial-proof abstractions (Appendix C.1).
  - `domain.json` — solved with domain abstractions (Appendix C.2).
  - `both.json` — solved using domain **and** partial-proof abstractions.
- **`base_runs/`** — baseline Twee runs (the "Twee (flat)" / "Twee (no flat)"
  curves in the Figure 2 and Figure 3 cactus plots).
- **`local_abs_{1,2,10}iter/`** — local-abstraction runs with 1/2/10 Stitch
  iterations (Figure 3, local-abstraction ablations).
- **`domain_abs/`, `domain_abs_hard/`** — domain-abstraction runs (Figure 2b,
  Section 5.2).
- **`partial_abs/`** — partial-proof-abstraction runs (Figure 2a).

Each timestamped run directory contains the config used and a `summary.json`.
`data/experiments/analysis.py` and `data/experiments/util.py` provide helpers for
loading and aggregating these summaries into the tables and cactus plots.

## Repository layout

| Path | Purpose |
|------|---------|
| `src/stitch/pipeline/worker.py` | Orchestrates the 4 stages; parallel execution via `ProcessPoolExecutor`. |
| `src/stitch/Abstractions.py` | FOF ↔ lambda translation, Stitch calls, tptp wrapping. |
| `src/stitch/domain_abstractions.py` | Domain-level abstraction aggregation across problems. |
| `src/stitch/configs/*.yaml` | Per-stage experiment parameters. |
| `src/utils.py` | Twee subprocess execution, proof parsing, TPTP utilities. |
| `data/TPTP/` | Input problems, organised as `{THEORY}_UEQ_{STATUS}/`. |
| `data/experiments/` | Experimental evaluation results (see above) + analysis helpers. |
| `paper.pdf` | The paper. |
