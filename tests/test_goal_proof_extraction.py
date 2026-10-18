import unittest
from pathlib import Path

from src.utils import extract_terms, extract_terms_from_proof


# A deliberately unused critical pair sits between a dependency and its user.
PROOF = '''Here is the input problem:
  Goal 1 (goal): a = b.
Lemma 2: a = b.
Proof:
  a
= { by axiom 1 }
  f(a) (peak)
= { by axiom 1 R->L }
  b
Lemma 3: unused(a) = unused(b).
Proof:
  unused(a)
= { by axiom 1 }
  unused(b)
Lemma 4: g(a) = g(b).
Proof:
  g(a)
= { by lemma 2 }
  g(b)
Goal 1 (goal): g(g(a)) = g(g(b)).
Proof:
  g(g(a))
= { by lemma 4 R->L }
  g(g(b))
RESULT: Theorem (the conjecture is true).
'''


class GoalProofExtractionTests(unittest.TestCase):
    def test_transitive_closure_excludes_unused_and_preserves_order(self):
        self.assertEqual(extract_terms(PROOF, {'onlyUsedLemmas': True}),
                         ['a', 'f(a)', 'b', 'g(a)', 'g(b)', 'g(g(a))', 'g(g(b))'])
        self.assertIn('unused(a)', extract_terms(PROOF, {'onlyProofTerms': True}))

    def test_peak_filter_applies_after_reachability(self):
        proof = PROOF.replace('unused(b)\nRESULT', 'unused(b) (peak)\nRESULT')
        self.assertEqual(extract_terms(proof, {'onlyUsedLemmas': True, 'onlyPeakTerms': True}), ['f(a)'])

    def test_repeated_references_do_not_duplicate_lemma_terms(self):
        proof = PROOF.replace('  g(g(b))\nRESULT',
                              '  g(g(b))\n= { by lemma 4 }\n  g(g(a))\nRESULT')
        terms = extract_terms(proof, {'onlyUsedLemmas': True})
        self.assertEqual(terms.count('g(a)'), 1)
        self.assertEqual(terms.count('g(g(a))'), 2)

    def test_goal_with_no_lemmas(self):
        proof = PROOF[PROOF.index('Goal 1 (goal): g'):].replace('by lemma 4', 'by axiom 1')
        self.assertEqual(extract_terms(proof, {'onlyUsedLemmas': True}), ['g(g(a))', 'g(g(b))'])

    def test_missing_dependency_rejected(self):
        with self.assertRaisesRegex(ValueError, 'missing lemma 99'):
            extract_terms(PROOF.replace('by lemma 2', 'by lemma 99'), {'onlyUsedLemmas': True})

    def test_partial_proofs_and_missing_goal_rejected(self):
        for proof in [PROOF.replace('RESULT: Theorem', 'RESULT: GaveUp'),
                      PROOF[:PROOF.index('Goal 1 (goal): g')] + 'RESULT: Theorem\n']:
            with self.assertRaises(ValueError):
                extract_terms(proof, {'onlyUsedLemmas': True})

    def test_incompatible_config_rejected(self):
        with self.assertRaises(ValueError):
            extract_terms(PROOF, {'onlyUsedLemmas': True, 'onlyTopLemmas': True})

    def test_existing_completed_twee_fixtures(self):
        for name in ['twee.txt', 'twee_default.txt']:
            text = (Path(__file__).parent / 'fixtures/proof_metrics' / name).read_text()
            self.assertEqual(extract_terms_from_proof(text, only_used_lemmas=True),
                             extract_terms_from_proof(text))


if __name__ == '__main__':
    unittest.main()
