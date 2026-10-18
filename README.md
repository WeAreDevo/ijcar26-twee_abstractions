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

### Apptainer dependency environment (Vera)

Use `containers/run.sh` for day-to-day development. It runs **the source in
this checkout**, with Python, packages, compilers, and provers supplied by
`containers/images/krympa-twitch.sif`. Python edits take effect on the next
run; rebuilding the image is only necessary when changing its dependencies.
No `env.sh`, virtualenv, or host software modules are needed.

From the repository root:

```bash
bash containers/run.sh twitch --help
bash containers/run.sh krympa --help
bash containers/run.sh python src/stitch/test_translation.py
bash containers/run.sh  # interactive shell in this checkout
```

The wrapper also accepts arbitrary commands, such as `python`, `cargo`, or
`dune`. It sets the working directory and Python import path to this checkout.
It loads the repository's `.env` for every command, including interactive
shells. Values there override image defaults. Explicitly exported
`TPTP_ROOT`, `LOG_DIR`, `TWEE_PATH`, `VAMPIRE_PATH`, `RAYON_NUM_THREADS`,
`KRYMPA_ROOT`, `SLURM_CPUS_PER_TASK`, and `TWITCH_MAX_WORKERS` take precedence over `.env`; other host module settings are
excluded. The file is parsed with python-dotenv, not executed as shell code.
Changes to `.env` take effect on the next run without rebuilding the image.

```bash
export TPTP_ROOT=/absolute/path/to/TPTP-v9.2.1
export LOG_DIR="$PWD/logs"
bash containers/run.sh twitch \
  --stage base --stage_config src/stitch/configs/base.yaml \
  --input_dir data/TPTP/ALG_UEQ_UNSAT --output_dir results/twitch-base --debug

bash containers/run.sh krympa /absolute/path/problem.p \
  --output-dir results/krympa-example --timeout 600 --sequential
```

Both commands use your embedded `twee_hints_v3` and Vampire unless overridden
in `.env` or by an exported variable.
TPTP data, source changes, and run outputs live on the host. Vera makes its
usual cluster filesystems visible in containers; the wrapper explicitly
binds this checkout too. Relative argument paths refer to the repository root.
Twitch limits its process pool to the available CPU affinity and
`SLURM_CPUS_PER_TASK` when set. Set `TWITCH_MAX_WORKERS` to a smaller positive
number to cap memory-intensive concurrent compression jobs without reducing
the Slurm allocation. `--debug` selects one worker. For parallel Krympa jobs, export
`RAYON_NUM_THREADS="$SLURM_CPUS_PER_TASK"` to match the allocation.

The Krympa **Python launcher** is read from this checkout. By default it uses
the precompiled Krympa executable and OCaml parser inside the image. If you
also edit Krympa's Rust or OCaml source, build the local checkout and select it:

```bash
bash containers/run.sh bash scripts/setup_krympa.sh
export KRYMPA_ROOT="$PWD/third_party/Krympa"
bash containers/run.sh krympa /absolute/path/problem.p \
  --output-dir results/krympa-local --timeout 600 --sequential
```

After Rust/OCaml edits, repeat the build command. The build products stay in
`third_party/Krympa`; no SIF rebuild is needed. Unset `KRYMPA_ROOT` to return
to the bundled Krympa build. The native launcher outside the container also
accepts `KRYMPA_ROOT` (including from `.env`). The wrapper uses the bundled
build when `KRYMPA_ROOT` is set in neither `.env` nor the shell.

To build a new dependency image:

```bash
bash containers/build.sh containers/images/krympa-twitch-new.sif
export CONTAINER_IMAGE="$PWD/containers/images/krympa-twitch-new.sif"
```

The image includes Python 3.11 and `requirements.txt`, Rust/Cargo 1.91.1,
C/C++ build tools, OCaml, Dune, compiled Krympa, and the provers copied from
`~/.local/bin/twee_hints_v3` and `~/.local/bin/vampire`. Set `TWEE_BINARY` and
`VAMPIRE_BINARY` at build time to change those source paths. Package manifests
and prover hashes are under `/opt/twitch/` in the image. Builds use `/tmp`
and two compilation/compression workers. The base image and Debian packages
can receive updates between builds.

The existing image also contains a source snapshot for standalone use via
`apptainer run IMAGE.sif twitch ...` or `krympa ...`. Those commands do **not**
use your edits; use `bash containers/run.sh` during development.
`bash containers/smoke-test.sh` validates the bundled snapshot and dependencies
and retains proof logs under `containers/images/smoke-*`.

The recipe follows the [C3SE container documentation](https://www.c3se.chalmers.se/documentation/miscellaneous/containers/).
Module discovery found Python 3.11.5 and Rust 1.91.1/1.94.1, but no OCaml or
Dune modules. All dependencies are installed inside the image.

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

### Proof size for the Krympa comparison

The shared metric is **proof steps**, identified as `krympa_steps_v1` in new
results. The [Krympa paper, Section 4](https://arxiv.org/html/2605.21200v1#S4)
defines Twee length as the sum of equality steps across all lemma and goal
chains, and Vampire length as direct-proof inference steps excluding
preprocessing. Lemma proofs are counted where they are printed; each subsequent
use is one step, without recursively expanding the lemma. This is not a term
count, symbol count, byte count, or fully expanded proof-tree size.

The implementation is pinned to Krympa revision
`7c19dec495a0271c1981c0e84e57ce3777415aeb`:

| Output | Counted as one step | Implementation reference |
|--------|---------------------|--------------------------|
| Twee | Each line containing `= { by` after the first `Proof:` | [`proof_length_twee`](third_party/Krympa/rust/src/prover_wrapper.rs) |
| Direct Vampire | Each non-comment line with `[` and one of `demodulation`, `superposition`, `resolution`, `trivial inequality removal` | [`proof_length_vampire`](third_party/Krympa/rust/src/prover_wrapper.rs) |
| Krympa's combined proof | Twee steps + raw Vampire steps + annotated `% ...lemma_N:` definitions | [`count_superposition_steps` and segment accounting](third_party/Krympa/rust/src/minimize.rs) |

The Vampire filter includes, for example, `forward subsumption resolution`.
It is a textual filter, not a general inference parser. Apply it to Krympa's
`output/vampire_proof_*.out`, which has already been converted to a direct
proof by [`run_vamp.rs`](third_party/Krympa/rust/src/run_vamp.rs).
Applying it to a raw refutation also counts its closing resolution; the paper's
direct-proof transformation can remove that step. A parallel superposition
inference still costs one step, even when it rewrites multiple occurrences.
Thus this metric matches Krympa's convention, not a normalized count of
individual rewritten occurrences across both provers.

[`src/proof_metrics.py`](src/proof_metrics.py) implements these counters without
changing the term extraction used to learn abstractions. Previously,
`compile_*_proof_lengths` used `len(extract_terms_from_proof(...))`: a chain
with `n` steps normally contributed `n+1` terms. The offset is per chain, so
it can distort comparisons when the number of lemmas changes. Those helpers
now count steps and label each entry with `proof_size_metric`. **Regenerate old
proof-length JSON files from their raw logs**; unlabelled historical lengths
must not be combined with the new measurements.

New base-stage summaries contain `base_proof_size`; local-abstraction summaries
contain `base_proof_size` for the exact proof used to learn hints and
`hints_proof_size` for the resulting proof. Missing, failed, partial, and
proof-suppressed Twee outputs have no size (`null`), rather than size zero.
A completed reflexive chain may legitimately have zero steps.

New Krympa `run.json` manifests contain `proof_size` with:

- `steps` and component counts: a recount of the final proof artifact;
- `baseline_steps`: the converted Vampire input proof's size;
- `reported_steps` and `reported_baseline_steps`: the minimizer's log values;
- `counts_match`: whether both recounts agree with the log;
- `benchmark_steps`: `min(baseline_steps, reported_steps)`, matching upstream's
  [`bench_run.rs`](third_party/Krympa/rust/src/bench_run.rs) fallback to the baseline;
- `reference_revision_matches`: whether this run uses the audited revision.

Keep the uncapped sizes. The upstream benchmark can report the baseline's size
even when the saved candidate is longer. Treat a count mismatch as requiring
inspection before comparison: some upstream fallback paths retain a count from
before converting or trimming a segment. Counts do not validate proof correctness.

Measure existing proof files directly:

```bash
python -m src.proof_metrics --format twee /path/to/problem_base_output.txt
python -m src.proof_metrics --format twee /path/to/problem_with_hints_output.txt
python -m src.proof_metrics --format vampire /path/to/output/vampire_proof_problem.out
python -m src.proof_metrics --format krympa /path/to/output/proof_problem.out
python -m unittest discover -s tests
```

For shortening, record the before and after sizes and use
`100 * (before - after) / before` when `before > 0`. Report final sizes on the
same problems as well: local abstractions start from a Twee proof, whereas
Krympa starts from a Vampire proof, so their percentage reductions have
different denominators. If retaining the shorter of baseline and candidate,
apply that policy to **both** methods and retain their uncapped results too.

Proof presentation also affects the comparison. Existing local-abstraction
configs use `--all-lemmas` (one lemma per critical pair);
Krympa calls Twee with `--quiet` and its default lemma presentation. This can
change step counts through sharing/inlining. For new comparison runs, use
[`comparison_base.yaml`](src/stitch/configs/comparison_base.yaml) for `base` and
[`comparison_local_abs.yaml`](src/stitch/configs/comparison_local_abs.yaml) for
`local_abs` as the `--stage_config` arguments. Both explicitly select
`--no-all-lemmas`, matching Krympa's default. Point `--base_dir` at those new
baseline runs: these configs also learn from that default presentation, which
can change the extracted abstractions compared with historical experiments.
Use a separate output directory to avoid mixing presentation policies.
The other settings retain the existing stage defaults; time budgets and search
settings still need to be controlled and reported for the full experiment.
On the smoke-test problem `Equation1024_implies_Equation424`, the original
Twee presentation has 8 terms and 5 steps; the default presentation has 3 steps.
With the comparison configs, both baseline and local-abstraction proofs have
3 steps, as does Krympa's final proof (from a 5-step Vampire baseline). This is
a measurement check on one problem, not a benchmark result.

Krympa's optional `--term-size` selection is disabled by our launcher; its
`op(`-based term-size heuristic is specific to the magma benchmarks and is
not a general symbol-size metric for our UEQ signature.

This establishes the counting convention and records it in both pipelines.
### Krympa vs Twitch on the full UNSAT TPTP set

[`scripts/proof_shortening.py`](scripts/proof_shortening.py) prepares the batch,
runs bounded groups of problems, and produces the proof-length comparison.
The prepared run is described in
[`plan.json`](data/experiments/proof_shortening/plan.json) and
[`manifest.json`](data/experiments/proof_shortening/manifest.json), with scripts in
[`vera_jobs/proof_shortening`](vera_jobs/proof_shortening).
Preparation does not submit jobs.

The cohort contains **1,041 distinct official TPTP problems** with status
`Unsatisfiable`, across all nine domains. Copies in `UEQ_UNS` are deduplicated.
The 1,027 generated ETP inputs have no official status header and are excluded
by default; `prepare --include-etp` includes them in a separate prepared run.

Both Twitch variants use `--hint-skel-factor 0.2 --hint-skel-cost 0`, with
`--no-flatten-goal` and `--flatten-goal` respectively. Both use
`--no-all-lemmas --show-peaks`, ten Stitch iterations, maximum arity ten, and
`onlyUsedLemmas: true` to learn from the final goal proof and its dependencies.
The no-flatten variant reuses the recent GRP/LAT base attempts: **559 proofs and
48 base timeouts**. Those timeouts remain recorded outcomes, with no local run.
Only the other **434 no-flatten bases** are computed. The flatten variant
computes its own 1,041 bases. Historical all-lemma runs are not interchangeable
proof-size baselines. `prepare --base-root PATH` (repeatable) can select another
root of compatible base summaries when preparing a new run.

Krympa requires a positive FOF conjecture: its minimizer rejects our original
CNF files with `No conjecture found`. The converter in
[`scripts/ueq_inputs.py`](scripts/ueq_inputs.py) expands includes, universally
closes positive unit equalities, and negates the single negative clause to form
the conjecture. Nonground negative clauses become **existential** conjectures.
This preserves the original UNSAT problem's meaning. All 1,041 inputs pass this
conversion; unsupported syntax is rejected during preparation. Converted inputs
and hashes are saved for inspection. Twitch continues to use the original CNF
inputs, preserving compatibility with the saved base proofs. Krympa failures,
including unsupported upstream proof-processing cases, remain explicit outcomes.

Each method has an independent array of 131 tasks, with eight problems per task
(the final task has fewer). A task requests four CPUs, 64 GB, and three hours;
at most two tasks per method run simultaneously. Four separate problem processes
run per task; `TWITCH_MAX_WORKERS` can reduce that limit and also limits this
runner's Krympa concurrency. Each Krympa pipeline is sequential internally and
`RAYON_NUM_THREADS=1`. With all three arrays active, at most 24 problem processes
run at once; a Krympa process can invoke either prover during its pipeline.

Budgets are explicit in the manifest: base Twee has `--max-time 1000`, a 1,500s
subprocess timeout, and a 1,530s outer phase limit; hinted Twee has a 1,000s
timeout within a **1,800s compression-plus-proving limit**; Krympa has a **1,000s
total pipeline limit**. These are proof-length experiments, not equal-total-time
speed comparisons. Existing no-flatten base work is reused rather than charged
as new runtime.

After reviewing the manifest and scripts, submit from the project root:

```bash
bash vera_jobs/proof_shortening/submit.sh
```

The submission script first checks LOG_DIR access, unchanged inputs/includes,
and all 559 reused proof files and their counts. It submits nothing if that
check fails. This check must run from a shell with access to the configured
LOG_DIR; the Codex backend previously lacked its storage group membership.
Each array is independent: a problem needing a base computes it before its
local stage, so there is no separate whole-array dependency.

Full outputs, converted Krympa inputs, intermediate files, stdout/stderr, and
phase checkpoints live under `$LOG_DIR/proof_shortening/`. Compact result files
are written atomically under `data/experiments/proof_shortening/results/`, and
each task updates its own `shards/METHOD/INDEX/summary.json` after every problem.
One failed or timed-out problem does not discard other results. A hard-killed
task may leave a running record, which remains excluded from finished statistics.
Rerunning the same task skips all terminal results (including failures/timeouts),
resumes unfinished problems, and reuses any base already saved in their compact
checkpoint. Do not submit the same task concurrently. To retry terminal failures
with different limits, prepare a separate suite rather than overwrite evidence.

Build or refresh the comparison at any time, including while arrays run:

```bash
bash containers/run.sh python scripts/proof_shortening.py report
```

This writes `comparison/per_problem.csv` and `comparison/summary.json` in the
suite directory. The CSV shows each baseline, final artifact step count,
reduction fraction, status, and raw-output location. The summary compares final
proof sizes on paired successes, counts wins/ties/losses, and reports reductions
from each method's own baseline (Vampire for Krympa, Twee for Twitch). The ratio
`krympa_steps / twitch_steps > 1` means Twitch's proof is shorter. Zero-step
proofs count in wins/ties but are excluded from ratio statistics. Krympa's
reported and benchmark-capped counts are separate columns; accounting or pinned
revision mismatches are excluded from paired statistics. Failed/pending runs
never receive invented proof lengths.

To prepare a separate run, use a distinct suite, log label, and script directory:

```bash
bash containers/run.sh python scripts/proof_shortening.py prepare \
  --suite data/experiments/proof_shortening_v2 \
  --label proof_shortening_v2 --scripts-dir vera_jobs/proof_shortening_v2
```

The default run has been prepared only. Small local smoke tests use `/tmp` and
are not included in its comparison results.

### Prepared comparison: terms from the final goal proof

The reviewable run is configured in
[`goal_proof_only/pipeline.yaml`](src/stitch/configs/goal_proof_only/pipeline.yaml).
It reruns `base` over the GRP and LAT UEQ UNSAT domains, then runs `local_abs` using
only those new baselines.

[`selection.json`](src/stitch/configs/goal_proof_only/selection.json) records
the historical selection, the 18 matching run directories, the successful
problem IDs, and the top five configurations. Ranking uses
`analysis.successes_per_config` on successful hint runs satisfying
`hints_time_user < 0.5 * mean_base_user_time`. The winner has 285 records on
285 distinct problems across the nine historical domains; the initial rerun
is restricted to GRP and LAT. Its settings are no goal flattening, hint factor 0,
hint cost 1, 10 Stitch iterations, and maximum arity 10.

The new base and local configs replace `--all-lemmas` with `--no-all-lemmas`.
Local extraction also sets `onlyUsedLemmas: true`: it retains the goal chains
and the transitive closure of their lemma references, preserving term order
and multiplicity. Missing goal proofs or missing referenced lemmas produce
an error instead of falling back to all printed lemmas. Other configs retain
their existing extraction behavior. This comparison changes lemma presentation
as well as term selection; it is not a measurement of filtering alone with
an otherwise identical printed proof.

The run uses the image's `/usr/local/bin/twee_hints_v3` explicitly, overriding
the current `.env` choice of `twee_goal_hint`. Historical summaries do not
record executable hashes, so exact historical binary identity is unverified.
The base budget remains `--max-time 1000` with a 1500-second process timeout;
the local timeout remains 1000 seconds. Each task requests 64 CPUs and five
hours on `vera`, account `c3se2026-1-12` (verified through Slurm associations).
Stitch's Rayon thread count is 1 per Python worker.

Summaries go under `data/experiments/goal_proof_only/{base,local_abs}/THEORY/`.
Separate theory directories avoid concurrent writes to base indexes.
Both scripts pin the configured `LOG_DIR` to
`/cephyr/NOBACKUP/groups/c3se2026-1-96/guy/proof_outputs`.
The Codex process lacked this directory's Unix group during preparation,
although the user's normal shell could access it. The configured destination
is retained at the user's request.
Raw base proofs, local proof outputs, and `*_extracted_terms.json` are saved
in uniquely named run directories there; local summaries identify the exact
base output file and extracted term count. Local abstractions are recorded
in `summary.json` as `abstractions` and `expanded_abstractions`.

Regenerate the selection, configs, and scripts without running any jobs:

```bash
bash containers/run.sh python scripts/prepare_goal_proof_run.py
```

To preserve manual edits to the configs and regenerate just the scripts:

```bash
bash containers/run.sh python src/stitch/pipeline/main.py \
  --config src/stitch/configs/goal_proof_only/pipeline.yaml \
  --scripts_dir vera_jobs/goal_proof_only --job_id goal_proof_only
```

Review [`pipeline_base.sh`](vera_jobs/goal_proof_only/pipeline_base.sh),
[`pipeline_local_abs.sh`](vera_jobs/goal_proof_only/pipeline_local_abs.sh), and
[`submit.sh`](vera_jobs/goal_proof_only/submit.sh). Only when ready, running
`bash vera_jobs/goal_proof_only/submit.sh` submits the two two-task arrays,
with the local array depending on `afterok` for the entire base array.
Slurm success indicates task completion; inspect summaries for individual
problem failures or timeouts when comparing with the historical runs.

To compare completed local results with the historical runs, run from the
project root:

```bash
bash containers/run.sh python scripts/compare_local_abs.py --plot
```

The comparison reads saved summaries only, so it can be rerun while jobs are
running. It defaults to GRP and LAT and matches the full local config,
allowing only the intended differences in `--all-lemmas` versus
`--no-all-lemmas` and `onlyUsedLemmas`. Flag order, theory labels, and explicit
extraction defaults do not affect matching. It does not filter the historical
data down to the successful problems used to select the config.

Outputs are under `data/experiments/goal_proof_only/comparison/`:

- `per_problem.csv`: old/new outcomes, baseline and hinted user CPU seconds,
  speedups, changes, and source run directories for every problem in either set.
- `summary.json`: overall and per-domain results, outcome transitions,
  partial/missing/pending/unreadable runs, and repeated-problem counts.
- `speedups.png` with `--plot`: old versus new speedup on logarithmic axes;
  points above the diagonal have improved speedup. Created only when both
  sides have positive timings for at least one common successful problem.

Speedup is `mean_base_user_time / hints_time_user`, using each run's own
baseline. `speedup_ratio_new_over_old > 1` means improved normalized speedup;
`hint_runtime_ratio_old_over_new > 1` means the hinted prover itself ran
faster. `base_runtime_ratio_new_over_old` makes baseline timing changes visible.
These measurements exclude extraction time and do not measure total pipeline
speedup. Historical binary and machine differences can still affect timings.

Geometric means and speedup wins/losses use the same problems on both sides,
requiring successful results and strictly positive finite timings. Failures
and timeouts remain visible as outcome transitions; they are not assigned
invented runtimes. Missing or zero times have blank ratios in the CSV and
`null` values in JSON. Zero hint times still count toward the strict historical
`hints_time_user < 0.5 * mean_base_user_time` criterion when the baseline is
positive. Counts on common problems are separate from paired timing averages.

For repeated problems, the script selects the latest completed record by the
timestamped run directory name, even if it failed. It reports pending or
unreadable newer summaries separately and retains the earlier completed
record until a valid newer one exists. It never chooses the fastest repeat.
Checkpointed partial summaries are included and explicitly flagged; their
statistics describe finished problems only, not the whole benchmark set.
Use `--new-root` to restrict analysis to a particular run or collection;
`--old-root`, `--config`, `--theories GRP LAT`, and `--output-dir` are also
available. The functions `load_results`, `compare_records`, and `summarize`
in `scripts.compare_local_abs` can be imported for interactive analysis.

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

Each child now saves an atomic `results/PROBLEM.json` before returning its
result. The parent consumes completions as they arrive and atomically updates
`summary.json` after every result, in both the experiment directory and its
`LOG_DIR` directory. A slow first input no longer delays recording later
results. Ordinary problem exceptions become error records and other problems
continue. The container's Twitch entry point uses unbuffered Python output so
completion messages appear promptly in the Slurm log.

`run_state.json` records `running`, `complete`, `failed`, or `interrupted`,
plus the expected problems, finished count, and unfinished problem IDs.
`complete` means every task returned a record, not that every proof succeeded.
On a broken pool or SIGTERM, the parent collects durable child records,
checkpoints them, and stops its remaining worker/prover process groups before
exiting unsuccessfully. SIGKILL cannot run cleanup: the last summary remains
valid, and child records may contain more results than that snapshot.

After a run has **stopped**, rebuild its summary from those child records:

```bash
python3 scripts/rebuild_stage_summary.py /path/to/timestamped-experiment-directory \
  --log-dir /path/to/LOG_DIR/matching-timestamped-directory
```

Omit `--log-dir` to recover only the repository copy. Do not rebuild a live
run while its parent is writing summaries. This command requires the new
checkpoint format; it cannot reconstruct CPU timings for older config-only
runs from raw proof text or file timestamps.

The first GRP/LAT local run failed with different resource errors: GRP hit
its five-hour Slurm limit (`10502346_0`), and LAT was OOM-killed
(`10502346_1`), breaking the 64-worker pool. Both predated incremental
summaries. The configured Twee timeout does **not** cover Stitch compression;
checkpointing preserves completed work but does not impose a compression
timeout or guarantee that a retry fits its allocation. For a reviewed retry,
start with fewer concurrent workers, for example export
`TWITCH_MAX_WORKERS=8` when submitting the local-stage script, retain the
existing base results, and review memory use and the wall-time budget.
The existing job scripts still default to the CPU allocation unless this cap
is supplied; no retry was submitted as part of this fix.

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
