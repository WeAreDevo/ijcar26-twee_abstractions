# Interpreting the Krympa–Twitch comparison

See [ANALYSIS.MD](ANALYSIS.MD) for the dated results summary, ranked examples,
and analysis of Vampire's contribution.

This directory compares **final proof lengths** for the same problems. A
**Twitch win** means that its final Twee proof, including its printed lemma
proofs, has fewer counted steps than Krympa's reported final length for its
combined proof. Krympa's reported `Total steps` is definitive for this report.

- [summary.json](summary.json) contains aggregate results and coverage counts.
- [per_problem.csv](per_problem.csv) contains the measurements, statuses,
  selected Twitch configuration, and outcome for each problem.
- [../manifest.json](../manifest.json) specifies the 1,041-problem cohort,
  configurations, budgets, and reused base runs.

## What the two systems output

**Twitch** learns local abstraction hints from a base Twee proof and runs Twee
again with those hints. Its measured output is the resulting Twee proof: the
printed lemma derivations and the goal derivation. The hints are search guidance;
their number is not the proof length.

**Krympa** starts from a Vampire proof, searches for shorter derivations of parts
of it using Vampire and Twee, and assembles retained proof segments. Its final
`output/proof_<problem>.out` can contain annotated superposition steps, Twee
equality chains, and Vampire proof segments. It is not necessarily a single
Twee proof. An intermediate lemma can be presented as an axiom inside a later
segment; its derivation in the combined output also contributes to the count.

For example, the saved [Krympa test fixture](../../../../tests/fixtures/proof_metrics/krympa.txt)
contains two annotated superposition steps deriving lemmas, followed by one Twee
step using a lemma. Its measured length is **three steps**, including the lemma
derivations, rather than just the last step.

## The proof-length metric

The metric is `krympa_steps_v1`, implemented in
[proof_metrics.py](../../../../src/proof_metrics.py) against Krympa revision
`7c19dec495a0271c1981c0e84e57ce3777415aeb`.

| Proof component | What contributes to its length |
|---|---|
| Twee | Every `= { by ... }` equality step after the first `Proof:`, across printed lemma and goal chains |
| Direct Vampire segment | Inference lines matching Krympa's filter: `demodulation`, `superposition`, `resolution`, or `trivial inequality removal` |
| Krympa annotated superposition block | Each `% ...lemma_N:` definition; dependency mentions are not counted again as definitions |
| Krympa artifact recount (diagnostic) | The sum of these component counts |
| Krympa final length used in comparisons | The minimizer's reported `Total steps` |

This measures printed proof steps, not symbols, terms, output bytes, search
steps, runtime, or a fully expanded proof tree. Printed lemma derivations
contribute where they appear, and subsequent uses contribute steps without
recursively expanding the lemma at every use.

The systems are comparable **under this counting convention**, with a limitation:
a Vampire inference and a Twee equality step need not perform the same amount
of work. For example, a parallel superposition inference can rewrite multiple
occurrences while counting as one step. We have not translated both outputs
into a common primitive proof calculus. Matching the recorded counts also does
not independently verify proof correctness. The report retains the output
recount for diagnosis but uses Krympa's reported final count even when they differ.

Krympa receives an equivalent FOF rendering of the original CNF problem because
its minimizer requires a positive conjecture. Twitch uses the original CNF
input. This conversion, and proof presentation/sharing, can affect the proof
found and its measured length.

## Selecting Twitch's best configuration

The two Twitch configurations use `--hint-skel-factor 0.2 --hint-skel-cost 0`:

- `twitch_no_flatten`: `--no-flatten-goal`, learning from a no-flatten base proof.
- `twitch_flatten`: `--flatten-goal`, learning from a flatten base proof.

Both use goal-proof-only term extraction. For each problem, `twitch_best` selects
the **shorter comparable successful local-abstraction proof** across these two
configurations. If only one configuration has such a proof, it uses that result.
If both tie, the CSV lists both names in `twitch_best_configs`, separated by `|`.
`twitch_available_configs` is the number of configurations contributing usable
proofs, from zero to two.

This is a best-of-two selection made after observing the results, not a single
configuration selected in advance. It does not include the cost of choosing a
configuration. It also does not substitute an unhinted base proof when the
local run fails or produces a longer proof.

## What “comparable” means

“Comparable” is an eligibility flag for these statistics:

- **Twitch:** the run has status `success`, and its baseline and final proof
  measurements both carry the expected metric.
- **Krympa:** the run has status `success`, the metric and pinned revision match,
  and its reported final count is a nonnegative integer. A recount mismatch
  (`counts_match: false`) does not exclude it.

A completed run can therefore be excluded from comparison. Its measured values
can still appear in the CSV; use the `*_comparable` flags when computing paired
statistics yourself. Eligibility does not mean the proof passed an independent
proof checker.

`best_of_two_coverage` partitions the full cohort into these outcomes:

| Outcome | Meaning |
|---|---|
| `twitch_shorter` | Both have comparable proofs, and Twitch's best proof has fewer steps |
| `krympa_shorter` | Both have comparable proofs, and Krympa's proof has fewer steps |
| `equal` | Both have comparable proofs with equal step counts |
| `twitch_only_comparable` | At least one Twitch configuration has a comparable proof; Krympa does not |
| `krympa_only_comparable` | Krympa has a comparable proof; neither Twitch configuration does |
| `neither_comparable` | Neither side has a comparable proof |

One-sided availability is **not a proof-length win**. It can reflect a timeout,
error, missing checkpoint, or excluded measurement on the other side. It should
not be described as “only this tool can solve the problem.”

## Reading summary fields and ratios

`comparisons.twitch_best` answers the main best-of-two question. The separate
`twitch_no_flatten` and `twitch_flatten` entries compare Krympa against each
configuration individually; their eligible problem sets can differ.

`paired_proofs` is the number of problems with comparable proofs on both sides.
It equals `twitch_shorter + krympa_shorter + equal`. `best_of_two_by_domain`
breaks coverage and outcomes down by domain.
`best_of_two_paired_with_both_twitch_configs` shows how many paired problems
actually had usable results from both Twitch configurations.

The proof-length ratio is:

```text
krympa_over_twitch_steps = Krympa final steps / Twitch final steps
```

A ratio greater than one favors Twitch; a ratio less than one favors Krympa.
For example, a ratio of two means Krympa's proof has twice as many steps.
Median and geometric-mean ratios use only pairs with strictly positive lengths;
`positive_ratio_pairs` records that denominator. A valid zero-step proof still
participates in wins and ties, but pairs containing one are excluded from ratio
statistics. A blank CSV field represents a missing or undefined value, not zero.

Krympa exposes the following lengths:

| CSV field | Meaning |
|---|---|
| `krympa_final_steps` | Definitive final count reported by Krympa; used for wins, ratios, and reductions when eligible |
| `krympa_reported_steps` | The same final count reported by Krympa's minimizer |
| `krympa_recounted_steps` | Independent count of the saved output; retained for diagnosis |
| `krympa_benchmark_steps` | `min(baseline_steps, reported_steps)`, matching upstream's benchmark fallback convention |

The benchmark-capped count is **not** used for our length wins. The saved final
candidate can be longer than its baseline; that remains visible here.
`krympa_counts_match` remains diagnostic. The summary records the counting policy
in `final_length_source` and the number of included mismatches in
`krympa_count_mismatches_included`. Checkpoint measurements are preserved as
originally recorded; this policy changes report selection and aggregation.

## Reduction fractions use different starting proofs

For a positive baseline length:

```text
reduction_fraction = (baseline_steps - final_steps) / baseline_steps
```

Krympa's baseline is the recount of its initial Vampire proof converted to a direct proof.
Twitch's baseline is the unhinted Twee proof used to learn that configuration's
hints. Flatten and no-flatten configurations have their own base proofs.

| Example | Baseline steps | Final steps | Reduction |
|---|---:|---:|---:|
| Krympa | 100 | 40 | 60% |
| Twitch | 50 | 30 | 40% |

In this example, Krympa achieves the larger reduction from its own starting
proof, while Twitch wins on final proof length. **The win counts compare final
lengths, not reduction fractions.** A negative fraction means the final proof
is longer; zero means equal length. A zero-length baseline has no defined
reduction fraction.

`reductions_from_own_baseline` summarizes each method's eligible results, not
necessarily the common paired set. Its `measured_proofs` can therefore exceed
the denominator of the direct comparison. There is no best-of-two reduction
aggregate with a shared baseline in the current report.

## Results after the remaining runs: 2026-10-20

All three methods have terminal records for all **1,041 problems**; none are
pending, running, or interrupted. There are **503 comparable pairs** for the
best-of-two comparison:

| Outcome | Problems |
|---|---:|
| Krympa shorter | 360 |
| Twitch shorter | 99 |
| Equal length | 44 |

Of those pairs, 484 have successful comparable proofs from both Twitch
configurations; 19 use the only available successful configuration.
There are another 368 Twitch-only comparable problems, 25 Krympa-only comparable
problems, and 145 with neither side comparable. These counts sum to 1,041.
All 100 successful Krympa runs with count mismatches are included: in every case,
its reported final length is exactly one greater than the output recount, and
the baseline counts agree. Of these 100, 98 have a comparable Twitch proof and
two are Krympa-only comparable. No successful runs are excluded under the new policy.

On the 503 eligible pairs, the median Krympa/Twitch proof-length ratio is
**0.6667**, and its geometric mean is **0.5916**. These are final-proof-length
ratios, not runtime speedups. Every eligible pair has a positive proof length.

| Recorded outcome | Krympa | Twitch no-flatten | Twitch flatten |
|---|---:|---:|---:|
| Success | 528 | 814 | 826 |
| Timeout | 168 | 40 | 38 |
| Base timeout | — | 153 | 149 |
| No valid abstractions | — | 12 | 12 |
| Error | 345 | 22 | 16 |
| Comparable successful proof | 528 | 814 | 826 |

The last row is a subset of successes, not an additional outcome. Krympa's 345
error records report no final proof. Twitch error records include local-phase
processes killed with exit code -9, and 15 rerun Slurm logs report OOM events.
No current result record reports a disk-quota/storage error. The retained
`previous_attempt` records can still contain historical quota failures.

**Finished attempts do not mean every problem has a comparable pair.** Failures
and timeouts affect which 503 problems enter the
length comparison. Twitch has a comparable result on 871 problems, versus 528
for Krympa. Thus Krympa's larger number of paired length wins should be reported
alongside this coverage difference, not as a win over the full cohort.

Under the earlier policy excluding count mismatches, the incomplete snapshot
(2026-10-19) had only 136 comparable pairs:
63 Krympa-shorter, 52 Twitch-shorter, and 21 ties. The new report covers all nine
domains rather than only ALG, BOO, COL, and part of GRP. The initial rerun report
under that earlier policy had 405 pairs (288 Krympa-shorter, 78 Twitch-shorter,
39 ties); it is superseded by the reported-count results above.

The `outcomes` section reports saved statuses. `pending` means no result record
was found; it does not establish that a job is still queued. `running` can be a
stale checkpoint left by a stopped task. These values are not live Slurm status.
`base_timeout` means there was no successful base proof from which to learn
local hints. `no valid abstractions produced by Stitch` is also not a successful
local proof. Neither is assigned an invented proof length.

The numbers in this dated section describe the saved snapshot when this README
was written. Regenerated JSON and CSV files are authoritative for later runs.

## Vampire contribution in the improved-Twitch cases

[vampire_contribution.csv](vampire_contribution.csv) and
[vampire_contribution_summary.json](vampire_contribution_summary.json) analyze
the 143 problems where Krympa is shorter and at least one selected best Twitch
configuration improved its own baseline. The CSV is sorted by Twitch minus
Krympa, largest first. This analysis uses saved counters, not new prover runs;
LOG_DIR was inaccessible during the analysis.

For all ten largest gaps, Krympa's initial Vampire-derived direct proof was
already shorter than Twitch's final improved proof. All ten Krympa outputs
contain recounted Vampire-derived steps (five have only such steps; five mix
them with Twee steps). Of the summed 1,243-step final gap, 752 steps (60.5%)
already separate Twitch's final proof from the initial Vampire-derived proof;
another 491 arise through Krympa's subsequent shortening.

Across all 143 cases, the initial Vampire-derived proof is already shorter in
82 cases, equal in two, and longer in 59. Final output recounts contain
Vampire-derived steps in 140 cases: 42 Vampire-only and 98 mixed, versus three
Twee-only. The summed initial-baseline gap is only 575 of the 4,299-step final
gap (13.4%); the rest arises during shortening, which can use both provers.
Thus the ten largest examples show a strong starting-proof advantage, while
the full set also depends substantially on Krympa's shortening procedure.

These decompositions are arithmetic, not causal attribution. Vampire and Twee
steps have different granularity; the systems use different input presentations
and search procedures. Final component counts are output recounts; the 17 total
reported-minus-recount steps in this cohort are not assigned to either prover.
Isolating Vampire's causal contribution would require controlled ablations of
the starting prover and of Vampire calls during shortening. No such ablation
has been run here.

## Regenerating and inspecting the report

From the project root:

```bash
bash containers/run.sh python scripts/proof_shortening.py report
```

The report reads the compact saved checkpoints; it does not run provers, submit
jobs, or require access to the raw proof directory. Re-running it updates
`summary.json` and `per_problem.csv`, not this README. In the CSV, inspect
`twitch_best_comparison`, `twitch_best_configs`, and each method's
`*_final_steps` and `*_comparable` columns. `*_raw_dir` points to the retained
artifacts for investigating an individual case.

Report selection and aggregation are implemented in
[proof_shortening.py](../../../../scripts/proof_shortening.py).
