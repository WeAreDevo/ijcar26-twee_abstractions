# Progress: Herbrand compression (GAPT)

Tool case study on Ebner–Hetzl–Leitsch–Reis–Weller, *On the Generation of
Quantified Lemmas* (JAR 2019). Started 2026-08-25.

## State at a glance

**Tool characterisation done.** GAPT runs, imports our Prover9 proofs, and its
I/O is understood and wrapped. **No corpus or evaluation criterion is chosen** —
deliberately deferred.

| | |
|---|---|
| Tool | GAPT 2.19.0, `third_party/gapt-2.19.0` (gitignored), no build needed |
| Code | `src/gapt/cutintro.scala` (harness), `run_gapt.py` (wrapper), `test_run_gapt.py` (7 tests, no GAPT needed) |
| Env | `GAPT_ROOT` in `.env`; needs `$LADR_DIR/bin` on PATH |

**Headline finding: term set size gates everything, and our proofs are far
outside the workable band.** GAPT decomposes a 10-term proof in seconds; our
definition-free Prover9 proofs give term sets of 55 and 9,645, and neither
decomposes within 150 s.

## What GAPT computes (and how it differs from Stitch/babble)

Stitch and babble find repeated **subterms** and emit **term patterns**. GAPT
computes a **decomposition of the proof's Herbrand term set** and emits a
**universally quantified lemma**, introduced as a cut. The compression measure
is decomposition (grammar) size, not corpus cost. Algorithm 2 of the paper:

    T ← extractTermSet(π);  D ← computeDecomposition(T)
    F ← canonicalSolution(D) → minimizeSolution → beautifySolution → proof with cut

## Invocation (all verified)

```bash
# reference: the paper's own lattice case study, recovers transitivity + antisymmetry
java -Xmx4g -Xss20m -cp gapt-2.19.0.jar gapt.examples.poset.cutintro

# our harness (proof path MUST be absolute)
PATH="$LADR_DIR/bin:$PATH" java -Xmx4g -Xss20m -cp gapt-2.19.0.jar \
  gapt.cli.CLIMain src/gapt/cutintro.scala /abs/proof.out many_dtable 60

# or via the wrapper, which adds the outer timeout and parses the output
python src/gapt/run_gapt.py <prover9 .out> [--method M] [--timeout S] [--json]
```

Methods needing no external binary: `many_dtable` (best in the paper),
`1_dtable_ss`, `1_maxsat`, `1_2_maxsat` (bundled sat4j), `reforest`.

## Input / output contract

**In:** a Prover9 `.out` file (the proof, not the `.in`). GAPT also imports
generic TSTP by replaying each step with its built-in prover Escargot, and can
prove a TPTP problem itself via Escargot — both unused so far.

**Out** (`KEY<TAB>VALUE` lines from the harness → dict from the wrapper):
`status` (OK / NO_LEMMA / TIMEOUT / ERROR), `background_theory`,
`termset_size`, `termset_distinct_roots`, `termset_trivial`, `grammar_size`,
`grammar_wsize`, `num_cuts`, `lemmas`, `sehs_size`, `sehs_numvars`, plus ~38
GAPT metrics (`cansol_scomp`, `minsol_scomp`, `beausol_scomp`, timings).

## Worked examples

| proof | termset | distinct roots | result |
|---|---:|---:|---|
| GAPT's `alex2.out` | 10 | 5 | **OK**, `∀x1∀x2∀x3 f(x1, f(x1, f(x2, x3))) = f(x2, x3)` |
| GAPT's `farmer.out` | 9 | 8 | NO_LEMMA (near-trivial) |
| ours: bml_aim `3_goal_4` | 55 | 11 | TIMEOUT at 60 s and 150 s, `many_dtable` and `1_dtable_ss` |
| ours: aim_lc `first_sketch_goal_1` | 9,645 | 11 | TIMEOUT |

Both of our proofs **import cleanly** and the background theory is correctly
guessed as `Equality`. The failure is entirely in the decomposition step.

Context from the paper: term sets of size ≤10 are *trivial* (each term a
distinct root symbol, nothing to compress); the method works best at **size
10–50**; of 138,005 TSTP proofs GAPT imported 49%, and generated lemmas for
34% of the non-trivial ones. Our 55-term proof sits at the top of that band and
still does not finish, which suggests **term depth**, not just count, is the
real cost driver — our loop terms are deeply nested `op`/`ldiv` towers.

## Landmines (each verified the hard way)

1. **`prooftrans` must be on PATH.** GAPT shells out to it for *every* Prover9
   interaction. Homebrew's prover9 formula omits it; ours is at
   `$LADR_DIR/bin`. Worse, `Prover9Importer.isInstalled` only checks for
   `prover9`, so it reports `true` and then every import throws.
2. **`gapt.cli.CLIMain` swallows exceptions and still exits 0.** A throw
   silently aborts the rest of the script. The harness wraps everything in
   `try/catch` and calls `sys.exit`, which *does* propagate.
3. **GAPT's `withTimeout` does not bound the decomposition.** Confirmed: on the
   55-term proof the inner timeout never fired and the process had to be killed
   externally (`exit_code = None`). The wrapper's outer subprocess timeout is
   load-bearing, not belt-and-braces.
4. **`BackgroundTheory` must be `Equality` for equational problems** or the
   extended Herbrand sequent comes out unprovable. Use the `guess`-based
   factories; the poset example hardcodes `PureFOL`, which is safe only because
   its equality is carried as explicit axioms.
5. **Two metric line formats coexist.** `MetricsPrinter` prints its own
   `METRICS {json}` lines alongside our `METRIC<tab>k<tab>v`. The parser ignores
   the former; a test pins this.
6. `os.Path` in the harness requires an **absolute** proof path.
7. `loadExpansionProof` dispatches on *file path substring* (`/Prover9`,
   `/leanCoP`), so call `Prover9Importer` directly.

## Open questions (deliberately not decided)

- **Corpus.** None chosen. The proofs used above are illustrative only.
- **Evaluation.** The existing alpha/subterm/equational tiers match *terms*
  against five hardcoded constructions; GAPT emits *quantified formulas*, so
  the right criterion may instead be decomposition size, compression ratio, or
  whether the lemma shortens a re-proof.
- **Making our proofs tractable.** Options not yet tried: shorter proofs
  (smaller goals, or twee/Escargot instead of Prover9), restricting the
  end-sequent, the `keyLimit`/`singleQuantifier` knobs, or the MaxSAT methods
  with a longer budget.
