# Krympa versus Twitch: proof-length analysis

Snapshot: 20 October 2026, after the remaining runs completed.

Krympa produces shorter proofs on 360 of the 503 problems with comparable
results on both sides; Twitch produces shorter proofs on 99, with 44 ties.
Twitch has broader successful coverage. The largest Krympa advantages show
strong evidence of a contribution from Vampire, but the experiments do not
isolate Vampire's causal effect.

## Comparison and counting policy

The cohort contains 1,041 UNSAT TPTP problems. Twitch uses local abstractions
extracted from terms in the final goal proof, with two configurations:

- `--no-flatten-goal --hint-skel-factor 0.2 --hint-skel-cost 0`
- `--flatten-goal --hint-skel-factor 0.2 --hint-skel-cost 0`

Each configuration learns from a base proof with the corresponding flattening
setting. For each problem, the comparison selects the shorter successful,
comparable Twitch local-abstraction proof. If only one configuration succeeds,
that result is used. This is a best-of-two selection after observing the results;
it does not substitute the baseline if a local run fails or produces a longer proof.

Twitch's length counts printed Twee equality steps across lemma and goal
derivations. Krympa's final output can combine Twee derivations, Vampire
segments, and annotated Vampire-derived lemma steps. Lemma derivations are
counted where printed, without recursively expanding every subsequent use.

**Krympa's reported final `Total steps` is definitive for this report.**
The independent output recount remains available as a diagnostic:

| CSV field | Meaning |
|---|---|
| `krympa_final_steps` | Krympa's reported final length, used for comparisons |
| `krympa_reported_steps` | The same reported value |
| `krympa_recounted_steps` | Independent count of the saved output |
| `krympa_counts_match` | Whether final and baseline recounts agree with the logged counts |
| `krympa_benchmark_steps` | Upstream-style baseline-capped value; not used for wins |

There are 100 successful Krympa runs with count mismatches. In every case,
Krympa reports exactly one more final step than our output counter, while the
baseline counts agree. For example, ALG007-1 has a reported length of 17 and
a recount of 16 (10 Twee steps plus 6 annotated Vampire steps). This discrepancy
does not establish that the proof is invalid.

Those 100 runs were initially excluded. At the user's request, all are now
included using Krympa's reported count; 98 have a comparable Twitch result.
The earlier rerun totals of 288 Krympa wins, 78 Twitch wins, and 39 ties over
405 pairs are superseded by the results below.

These are proof-length comparisons, not runtime speedups. A reduction fraction
uses each method's own baseline: the initial Vampire-derived direct proof for
Krympa, and the corresponding unhinted Twee proof for Twitch. A larger reduction
fraction does not necessarily imply a shorter final proof.

## Results and coverage

All methods have terminal records for all 1,041 problems. A terminal record
can be a failure or timeout; it does not necessarily contain a comparable proof.

| Outcome against Twitch's best configuration | Problems |
|---|---:|
| Krympa shorter | 360 |
| Twitch shorter | 99 |
| Equal length | 44 |
| Twitch only comparable | 368 |
| Krympa only comparable | 25 |
| Neither comparable | 145 |
| Total | 1,041 |

Thus Twitch has comparable proofs on 871 problems and Krympa on 528. One-sided
availability is not counted as a proof-length win. Among the 503 paired
problems, 484 have usable proofs from both Twitch configurations; 19 use the
only available successful configuration.

The median Krympa/Twitch final-length ratio is 0.6667, and its geometric mean
is 0.5916, over these 503 pairs. Ratios below one favor Krympa.

The remaining exclusions arise from unsuccessful runs, rather than successful
Krympa count mismatches. The rerun logs include Twitch out-of-memory kills.
No current result record reports a disk-quota error. Coverage and resource
failures should accompany the paired win counts when interpreting the results.

## Largest differences favoring Twitch

Sorted by **Krympa minus Twitch**, largest first. All lengths use the policy above.

| Problem | Krympa | Twitch best | Difference |
|---|---:|---:|---:|
| LAT021-1 | 47 | 33 | 14 |
| GRP200-1 | 38 | 26 | 12 |
| GRP768-1 | 25 | 13 | 12 |
| LAT019-1 | 33 | 22 | 11 |
| BOO012-2 | 19 | 10 | 9 |
| GRP531-1 | 29 | 22 | 7 |
| GRP535-1 | 38 | 33 | 5 |
| GRP683-11 | 28 | 23 | 5 |
| GRP181-4 | 29 | 25 | 4 |
| LCL164-1 | 23 | 19 | 4 |

## Largest differences favoring Krympa

Sorted by **Twitch minus Krympa**, largest first.

| Problem | Krympa | Twitch best | Difference |
|---|---:|---:|---:|
| LAT394-1 | 25 | 597 | 572 |
| REL042-2 | 3 | 316 | 313 |
| GRP473-1 | 17 | 202 | 185 |
| GRP472-1 | 6 | 169 | 163 |
| LCL192-10 | 13 | 144 | 131 |
| GRP571-1 | 4 | 134 | 130 |
| BOO070-1 | 6 | 131 | 125 |
| LCL138-1 | 13 | 130 | 117 |
| BOO068-1 | 22 | 130 | 108 |
| GRP431-1 | 4 | 110 | 106 |

## Restricting to Twitch improvements over its own baseline

There are **143 problems** where Krympa is shorter even though the selected best
Twitch proof improves its own configuration's baseline. If the two configurations
tie for best, at least one must improve its corresponding baseline.

The ten largest remaining gaps are:

| Problem | Vampire baseline | Krympa final | Twitch baseline → final | Twitch − Krympa |
|---|---:|---:|---:|---:|
| REL042-2 | 98 | 3 | 335 → 316 | 313 |
| GRP473-1 | 61 | 17 | 245 → 202 | 185 |
| GRP472-1 | 43 | 6 | 245 → 169 | 163 |
| GRP431-1 | 81 | 4 | 137 → 110 | 106 |
| BOO014-4 | 70 | 5 | 122 → 100 | 95 |
| REL011-2 | 76 | 4 | 107 → 93 | 89 |
| GRP201-1 | 91 | 28 | 106 → 105 | 77 |
| REL007-1 | 99 | 61 | 217 → 138 | 77 |
| GRP729-1 | 8 | 8 | 140 → 77 | 69 |
| GRP730-1 | 8 | 8 | 140 → 77 | 69 |

“Vampire baseline” means the initial Vampire proof after Krympa transforms it
into a direct proof, before its subsequent shortening procedure.

## How much of the advantage is associated with Vampire?

For all ten filtered examples, the initial Vampire-derived proof was already
shorter than Twitch's final improved proof. All ten final Krympa outputs contain
counted Vampire-derived steps: five contain only such steps, and five mix them
with Twee steps.

An arithmetic decomposition separates the starting-proof gap from subsequent
shortening:

```text
Twitch final − Krympa final
  = (Twitch final − Vampire baseline)
  + (Vampire baseline − Krympa final)
```

| Measurement | Ten largest filtered gaps | All 143 qualifying cases |
|---|---:|---:|
| Vampire baseline already shorter than Twitch final | 10 | 82 |
| Vampire baseline equal to Twitch final | 0 | 2 |
| Vampire baseline longer than Twitch final | 0 | 59 |
| Final output contains counted Vampire-derived steps | 10 | 140 |
| Vampire-only / mixed / Twee-only output recounts | 5 / 5 / 0 | 42 / 98 / 3 |
| Summed final gap | 1,243 | 4,299 |
| Summed gap already present before shortening | 752 | 575 |
| Summed additional advantage from shortening | 491 | 3,724 |
| Baseline-gap fraction of summed final gap | 60.5% | 13.4% |

The baseline-gap sum is signed: cases where the Vampire baseline is longer
than Twitch contribute negatively. These fractions describe summed step-count
differences, not averages of per-problem percentages.

**The ten largest examples show a substantial Vampire starting-proof advantage.**
Across all 143 cases, however, most of the aggregate advantage arises during
Krympa's shortening procedure, which can use both Vampire and Twee. Merely
observing Vampire steps in the final output does not measure how much worse
the result would have been without Vampire.

Final component attribution uses output recounts. The reported-minus-recount
differences total three steps for the ten examples and 17 for the full 143;
these extra reported steps are not assigned to either prover.

## What the evidence does and does not establish

The evidence supports Vampire being an important contributor, particularly in
the largest examples. It does **not** establish a causal percentage of Krympa's
advantage attributable to Vampire:

- Vampire inferences and Twee equality steps need not represent the same amount
  of reasoning. The outputs have not been translated into a common primitive
  proof calculus.
- Krympa uses an equivalent FOF rendering, whereas Twitch uses the original
  CNF input. The pipelines also differ in search configuration, decomposition,
  lemma selection, and proof presentation.
- An output containing only Twee steps can still depend on the structure of
  Krympa's initial Vampire-derived proof.
- The 143-case cohort is selected for Krympa wins and Twitch baseline
  improvements; the ten examples are further selected for the largest gaps.
  Their statistics should not be generalized to all problems.
- The Vampire analysis uses previously saved measurements. LOG_DIR was
  inaccessible during this analysis, so the raw proofs were not re-inspected.
  No controlled ablation was run.

To isolate the mechanisms, a follow-up should distinguish the starting prover
from the provers used during shortening. Holding the initial Vampire proof fixed
while disabling later Vampire calls would test its additional contribution
during shortening, but would not remove the initial Vampire contribution.
Comparing starting proofs under matched inputs and assessing inference
granularity would address separate confounders.

## Supporting files

- [summary.json](summary.json): aggregate results under the reported-count policy.
- [per_problem.csv](per_problem.csv): final counts, baseline counts, configurations,
  eligibility, recounts, and mismatch flags.
- [vampire_contribution.csv](vampire_contribution.csv): the 143-case filtered
  analysis, sorted by Twitch minus Krympa.
- [vampire_contribution_summary.json](vampire_contribution_summary.json):
  aggregate baseline-gap and final-composition measurements.
- [README.md](README.md): detailed metric and report interpretation.

This document records the dated snapshot above. Regenerating the main report
updates its JSON and CSV, not this document or the separate Vampire analysis.
