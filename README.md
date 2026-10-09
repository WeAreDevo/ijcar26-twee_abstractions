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
```

`LOG_DIR` receives the bulky per-problem artifacts (twee output, TPTP files with
hints added). Result summaries go under the `--output_dir` you pass on the
command line.

## Running experiments

### Krympa setup and single-problem runs

[Krympa](https://github.com/kondylidou/Krympa) is fetched into the ignored
`third_party/Krympa` directory. The setup script pins upstream revision
`7c19dec495a0271c1981c0e84e57ce3777415aeb` and Rust dependencies, and builds
the main Krympa executable and its OCaml parser from source. Prerequisites
are Git, Rust/Cargo, OCaml, and Dune >= 3.0, with `cargo`, `ocamlc`, and
`dune` on `PATH` (activate your opam environment if needed).

```bash
bash scripts/setup_krympa.sh
```

Add `VAMPIRE_PATH=/absolute/path/to/vampire` to `.env`. The launcher uses that
Vampire and `TWEE_PATH` from the existing setup; if `TWEE_PATH` is unset,
it uses Krympa's bundled Twee. Exported environment variables override `.env`.
Python requires `python-dotenv`, already included in `requirements.txt`.

For an upstream example, generate the first benchmark set, then run one problem:

```bash
(cd third_party/Krympa/shell && python3 ../python/generate_input.py ../benchmarks/Proofs1.lean)
venv/bin/python scripts/run_krympa.py \
  third_party/Krympa/benchmarks/input1/Equation1024_implies_Equation424.p \
  --output-dir third_party/krympa-runs/example --timeout 600 --sequential
```

The launcher runs `run_vampire`, `collect`, `shorten`, and `minimize`. Each
run requires a new output directory and keeps separate prover links, scratch
files, stage logs, and a `run.json` manifest. The final proof is under
`<output-dir>/output/proof_<problem-stem>.out`. The timeout covers the whole
pipeline and terminates its active process group. Omit `--sequential` for
Krympa's parallel mode; use `RAYON_NUM_THREADS` to match allocated CPUs.
The launcher requires a nonempty final proof because upstream sometimes exits
zero after reporting a minimization failure. Such runs are marked failed in
`run.json`; their baseline proof and logs remain available for inspection.

On a Linux cluster, run the same setup script to build native executables,
activate the Python environment, and export cluster-local `VAMPIRE_PATH`,
`TWEE_PATH`, and `TPTP_ROOT` before invoking the launcher. Give every job a
unique output directory. Runtime directories contain absolute symlinks and
should be created on the machine where the job runs. Linux execution has
not yet been validated here.

This prepares Krympa for experiments; it does not yet implement the comparison
with Twitch. The supplied paper counts direct Vampire inference steps excluding
preprocessing, and equalities in Twee proof chains. The comparison will need to
align those metrics and check input compatibility with our UEQ datasets.

### Twitch stages

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
