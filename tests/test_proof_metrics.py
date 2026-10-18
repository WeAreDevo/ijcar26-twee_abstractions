"""Fixtures are saved Equation1024_implies_Equation424 smoke-test outputs.

Krympa revision: 7c19dec495a0271c1981c0e84e57ce3777415aeb.
The minimize fixture retains just the two size result lines from the run log.
"""

import unittest
from pathlib import Path

from src.proof_metrics import (
    METRIC, count_twee_steps, count_vampire_steps, measure_completed_twee_proof,
    measure_krympa_run, measure_proof,
)

FIXTURES = Path(__file__).parent / "fixtures" / "proof_metrics"


class ProofMetricsTests(unittest.TestCase):
    def test_saved_twee_proof_counts_edges_not_terms(self):
        proof = (FIXTURES / "twee.txt").read_text()
        result = measure_completed_twee_proof(proof)
        # Two two-step lemmas and a one-step goal; eight terms across three chains.
        self.assertEqual(result["steps"], 5)
        self.assertEqual(result["metric"], METRIC)

    def test_saved_krympa_run_reconciles_with_upstream_log(self):
        result = measure_krympa_run(
            (FIXTURES / "krympa.txt").read_text(),
            (FIXTURES / "vampire.txt").read_text(),
            (FIXTURES / "minimize.txt").read_text(),
        )
        self.assertEqual(result["baseline_steps"], 5)
        self.assertEqual(result["steps"], 3)
        self.assertEqual(result["twee_steps"], 1)
        self.assertEqual(result["annotated_vampire_steps"], 2)
        self.assertEqual(result["vampire_steps"], 0)
        self.assertTrue(result["counts_match"])

    def test_lemma_presentation_changes_the_measured_size(self):
        # The same theorem under --all-lemmas and the default presentation.
        all_lemmas = (FIXTURES / "twee.txt").read_text()
        default = (FIXTURES / "twee_default.txt").read_text()
        self.assertEqual(count_twee_steps(all_lemmas), 5)
        self.assertEqual(count_twee_steps(default), 3)

    def test_shared_lemma_is_proved_once_and_each_use_counts(self):
        proof = """Axiom 1: f(X) = X.
Lemma 2: f(f(X)) = X.
Proof:
  f(f(X))
= { by axiom 1 }
  f(X)
= { by axiom 1 }
  X
Goal 1: f(f(f(f(a)))) = a.
Proof:
  f(f(f(f(a))))
= { by lemma 2 }
  f(f(a))
= { by lemma 2 }
  a
RESULT: Theorem
"""
        self.assertEqual(count_twee_steps(proof), 4)

    def test_vampire_filters_preprocessing_but_keeps_resolution(self):
        proof = """% superposition [comment]
1. f(X) = X [input]
2. a != b [negated conjecture 1]
3. f(X) = X [cnf transformation 1]
4. f(a) = a [superposition 1,3]
5. a = a [backward demodulation 4,1]
6. $false [equality resolution 2]
7. $false [trivial inequality removal 2]
8. a = b [forward subsumption resolution 4,5]
"""
        self.assertEqual(count_vampire_steps(proof), 5)

    def test_failed_partial_and_suppressed_proofs_have_no_size(self):
        for text in ("", "RESULT: Satisfiable", "RESULT: Theorem",
                     "Proof:\n a\n= { by axiom 1 }\n b\nRESULT: GaveUp"):
            with self.subTest(text=text):
                self.assertIsNone(measure_completed_twee_proof(text))

    def test_reflexive_proof_is_zero_not_missing(self):
        result = measure_completed_twee_proof("Goal 1: a = a.\nProof:\n a\nRESULT: Theorem")
        self.assertEqual(result["steps"], 0)

    def test_mixed_proof_counts_definitions_not_dependency_references(self):
        proof = """% === Superposition Steps ===
% lemma_0001: a = b | deps: a_1: a = b
% small_step_lemma_0002: f(a) = f(b) | deps: lemma_0001: a = b
10. g(a) = g(b) [superposition 1,2]
Proof:
  g(a)
= { by lemma 2 }
  g(b)
"""
        result = measure_proof(proof, "krympa")
        self.assertEqual(result["steps"], 4)
        self.assertEqual(result["annotated_vampire_steps"], 2)

    def test_cap_and_accounting_mismatch_remain_visible(self):
        result = measure_krympa_run(
            "Proof:\n a\n= { by axiom 1 }\n b\n",
            "1. a = b [superposition 2,3]\n",
            "[RESULT] Total steps: 4\n[RESULT] Initial proof steps: 1\n",
        )
        self.assertEqual(result["steps"], 1)
        self.assertEqual(result["reported_steps"], 4)
        self.assertEqual(result["benchmark_steps"], 1)
        self.assertFalse(result["counts_match"])

    def test_missing_or_ambiguous_upstream_results_are_rejected(self):
        for log in ("", "[RESULT] Total steps: 1\n" * 2):
            with self.subTest(log=log), self.assertRaises(ValueError):
                measure_krympa_run("", "", log)


if __name__ == "__main__":
    unittest.main()
