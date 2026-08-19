# Proof-Compression Concept-Recovery Experiment

## Goal

Test whether Stitch or Babble can recover standard loop-theoretic constructions (especially associators and commutators) from ATP proofs.

Use two corpora:

- **AIM / Prover9**: controlled corpus where `a`, `K`, `L`, `R`, `T` are explicitly defined.
- **Bol–Moufang quasigroup / Otter**: primitive equational corpus over multiplication/division operations, better for genuine concept recovery.

---

## Phase 0: Acquire proof corpora

Note that data/bml_aim/translate.py can convert Prover9 `.in` into TPTP. The LADR (see LADR_DIR in .env) utils may be generally useful for parsing and transforming input and output files.

### AIM

Source: https://www.cs.unm.edu/~veroff/AIM_LC/

Download:

- `first_sketch.{in,out,pf,xml}`
- `second_sketch.{in,out,pf,xml}`
- `lc.{in,out,pf,xml}`

Roles:

- `first_sketch`: no input hints; best initial AIM proof.
- `second_sketch`: same theorem, strictly-forward and demodulation-free; compare proof presentation.
- `lc`: final AIM+LC result, but heavily hint-guided; use as secondary corpus.

Tasks:

- [ ] Download files.
- [ ] Parse `.pf` proofs into equations/terms.
- [ ] Re-run at least `first_sketch` with twee if possible.
- [ ] Record proof metadata.

### Bol–Moufang

Use Phillips–Vojtěchovský, *The varieties of quasigroups of Bol–Moufang type: An equational reasoning approach*.

Publication page: https://cs.du.edu/~petr/in_research_journals.html

Tasks:

- [ ] Download the linked **OTTER generated proofs** archive.
- [ ] Inventory problems/proofs.
- [ ] Select 3 representative proofs: short, medium, long.
- [ ] Run Twee on them and retain successful proof traces.

### Bol-Moufang + AIM

We also have problems in data/bml_aim.
Tasks:
- [ ] Run Twee on them and retain successful proof traces.

---

## Phase 1: Build uniform proof-term extraction

For Prover9, Otter, and Twee proofs:

- extract top-level terms from proof equations;
- preserve multiplicity (i.e., if a term occurs twice in the proof, it should occur twice in the extracted corpus);
- alpha-normalize variables;
- export equivalent Stitch and Babble inputs.

Store metadata:

```text
corpus, problem, prover, proof_length, uses_hints,
demodulation_free, signature, derived_symbols_present
```

---

## Phase 2: AIM definition-erasure control

Targets:

```text
   % associator
   (x * (y * z)) \ ((x * y) * z) = a(x,y,z).
   
   % commutator
   (x * y) \ (y * x) = K(y,x).
   
   % inner mappings
   
   % L(u,x,y) = u L(x) L(y) L(yx)^{-1}
   (y * x) \ (y * (x * u)) = L(u,x,y).
   
   % R(u,x,y) = u R(x) R(y) R(xy)^{-1}
   ((u * x) * y) / (x * y) = R(u,x,y).
   
   % T(u,x) = u R(x) L(x)^{-1}
   x \ (u * x) = T(u,x).
```

Use the exact definitions in the AIM input.

For each selected AIM proof:

1. unfold `a`, `K`, `L`, `R`, `T` in the proof's own input clauses (axioms + Skolemized denial) into the corresponding equations above;
2. remove their defining equations from the compression corpus;
3. run Stitch;
4. run Babble;
5. record whether the hidden definition is recovered and its rank.

This is a **control**, not the main novelty: the original proof search had access to the named operations.

Compare at least:

- `first_sketch`;
- `second_sketch`.

Question: does proof presentation affect recovery?

---

## Phase 3: Primitive Bol–Moufang recovery

Run Stitch/Babble directly on primitive Otter proofs and corresponding Twee proofs.

Look for learned abstractions that are:

- exactly standard constructions;
- trivially equivalent by variable renaming;
- provably equivalent under the background equations.

Primary question:

> Do human loop-theoretic concepts emerge from proofs in which those concepts were never named?

If associator/commutator recovery is unrealistic for a selected theorem, retain the highest-ranking repeated constructions and inspect them instead.

---

## Phase 4: Stitch vs Babble

Run:

1. **Stitch**: syntactic compression.
2. **Babble without equations**: comparable syntactic baseline.
3. **Babble modulo a small theory**: test whether equality-aware compression improves recovery.

Do not initially give Babble the full loop theory. Add equations incrementally.

---

## Metrics

For each target and proof record:

```text
recovered: yes/no
match: exact / alpha-equivalent / equationally equivalent
rank
compression score/gain
occurrence count
```

Also retain the top 20–50 learned abstractions, including uninterpreted ones.

Key comparison:

| corpus | proof | prover | target | Stitch rank | Babble rank | Babble+eq rank |
|---|---|---|---|---:|---:|---:|

---

## Minimal first milestone

Before expanding the experiment, obtain:

- AIM `first_sketch` and `second_sketch` proofs;
- 3 Bol–Moufang Otter proofs;
- Twee proofs for any selected Bol–Moufang problems Twee can solve;
- one working parser producing Stitch/Babble term corpora;
- one AIM definition-erasure result;
- one primitive Bol–Moufang compression result.

Only then decide whether to scale to more proofs or more target concepts.
