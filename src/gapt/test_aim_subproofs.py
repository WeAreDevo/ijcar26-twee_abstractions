"""Tests for carving sub-proofs out of a large Prover9 proof.

Two tiers:

  * Parsing/carving tests run everywhere -- they pin the justification grammar
    (`para(11(a,1),...)` vs `hyper(17,a,16,a(flip),...)`) and the Prover9
    variable convention, which is the bug class that has silently produced wrong
    answers in this repo before.
  * Import *controls* need GAPT, LADR and `data/AIM/`, and skip without them.
    They are the reason a successful import can be believed: they show that
    GAPT's importer rejects a falsified inference and a dropped premise, so
    "it imported" is evidence the fragment is a checked derivation and not just
    well-formed text.

    python src/gapt/test_aim_subproofs.py
"""

import os
import sys
import unittest
from pathlib import Path

project_root = Path(__file__).resolve().parents[2]
sys.path.insert(0, (project_root / "src" / "gapt").as_posix())

from aim_subproofs import (GAPT_ROOT, LADR_DIR, ancestor_sets, ancestors_of, carve,
                           is_unit_equation, ladder, parents_of, parse_proof,
                           probe_termset)

AIM_PF = project_root / "data" / "AIM" / "aa2_to_aa3.pf"

MINI = """============================== prooftrans ============================
============================== end of head ===========================

============================== end of input ==========================

============================== PROOF =================================

11 1 * x = x.  [assumption].
13 x \\ (x * y) = y.  [assumption].
21 (x * (y * z)) \\ ((x * y) * z) = a(x,y,z) # label("associator").  [assumption].
22 a(x,y,z) = (x * (y * z)) \\ ((x * y) * z).  [copy(21),flip(a)].
47 1 \\ x = x.  [para(11(a,1),13(a,1,2))].
88 T(v5,x) = x.  [hyper(13,a,11,a(flip),b,22,a)].

============================== end of proof ==========================
"""


class TestJustificationParsing(unittest.TestCase):
    def test_para_positions_are_not_clause_ids(self):
        # `(a,1,2)` are literal/argument positions, not references
        self.assertEqual(parents_of("para(11(a,1),13(a,1,2))"), [11, 13])

    def test_hyper_alternates_ids_and_literals(self):
        self.assertEqual(parents_of("hyper(17,a,16,a(flip),b,88,a)"), [16, 17, 88])

    def test_flip_and_copy(self):
        self.assertEqual(parents_of("copy(21),flip(a)"), [21])

    def test_resolve_and_deny(self):
        self.assertEqual(parents_of("resolve(11429,a,46,a)"), [46, 11429])
        self.assertEqual(parents_of("deny(10)"), [10])

    def test_assumption_has_no_parents(self):
        self.assertEqual(parents_of("assumption"), [])


class TestProofParsing(unittest.TestCase):
    def setUp(self):
        self.tmp = Path(os.environ.get("TMPDIR", "/tmp")) / "mini_proof.pf"
        self.tmp.write_text(MINI)
        self.nodes = parse_proof(self.tmp)

    def test_parses_all_clauses(self):
        self.assertEqual(sorted(self.nodes), [11, 13, 21, 22, 47, 88])

    def test_ancestors(self):
        self.assertEqual(ancestors_of(self.nodes, 47), {11, 13, 47})
        self.assertEqual(ancestors_of(self.nodes, 22), {21, 22})
        self.assertEqual(ancestors_of(self.nodes, 88), {88, 13, 11, 22, 21})

    def test_dangling_parent_raises(self):
        self.nodes[88]["parents"] = [11, 9999]
        with self.assertRaises(KeyError):
            ancestors_of(self.nodes, 88)

    def test_unit_equation_predicate(self):
        self.assertTrue(is_unit_equation("1 \\ x = x"))
        self.assertFalse(is_unit_equation("x * y != z | x * u != z | u = y"))
        self.assertFalse(is_unit_equation("$F"))
        # labelled clauses are excluded: their text carries `# label(...)`
        self.assertFalse(is_unit_equation('a(x,y,z) = 1 # label("aa2")'))


class TestCarving(unittest.TestCase):
    def setUp(self):
        self.tmp = Path(os.environ.get("TMPDIR", "/tmp")) / "mini_proof.pf"
        self.tmp.write_text(MINI)
        self.nodes = parse_proof(self.tmp)

    def test_carved_text_is_a_refutation(self):
        text, steps = carve(self.nodes, 47)
        self.assertEqual(steps, 3)                      # 11, 13, 47
        self.assertIn("90001 1 \\ x = x", text)         # the new goal
        self.assertIn("[deny(90001)]", text)
        self.assertIn("$F", text)
        self.assertIn("[resolve(47,a,90002,a)]", text)
        self.assertIn("end of proof", text)

    def test_denial_skolemises_every_variable(self):
        text, _ = carve(self.nodes, 47)
        denial = [l for l in text.splitlines() if l.startswith("90002 ")][0]
        self.assertIn("1 \\ c100 != c100", denial)

    def test_skolem_constants_are_not_prover9_variables(self):
        # Prover9: a symbol is a VARIABLE iff it begins with u-z. A constant
        # named `x1` would silently turn the denial into a tautology.
        text, _ = carve(self.nodes, 47)
        denial = [l for l in text.splitlines() if l.startswith("90002 ")][0]
        for tok in ("c100", "c101", "c102"):
            if tok in denial:
                self.assertNotIn(tok[0], "uvwxyz")

    def test_excluded_clause_kinds_raise(self):
        self.nodes[99] = {"id": 99, "clause": "$F", "just": "assumption", "parents": []}
        with self.assertRaises(ValueError):
            carve(self.nodes, 99)


@unittest.skipUnless(AIM_PF.exists(), "data/AIM/aa2_to_aa3.pf not present")
class TestOnVeroffProof(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.nodes = parse_proof(AIM_PF)

    def test_proof_is_fully_connected(self):
        """Every clause is an ancestor of $F -- no orphaned steps."""
        anc = ancestor_sets(self.nodes)
        root = max(self.nodes)
        self.assertEqual(len(anc[root]), len(self.nodes))

    def test_no_dangling_parents(self):
        missing = [(n, d["just"]) for n, d in self.nodes.items()
                   if any(p not in self.nodes for p in d["parents"])]
        self.assertEqual(missing, [])

    def test_ladder_sizes_increase(self):
        sizes = [s for _, s, _ in ladder(self.nodes)]
        self.assertEqual(sizes, sorted(sizes))
        self.assertLess(sizes[0], 10)
        self.assertGreater(sizes[-1], 1000)


@unittest.skipUnless(
    AIM_PF.exists() and Path(GAPT_ROOT, "gapt-2.19.0.jar").exists()
    and LADR_DIR and Path(LADR_DIR, "bin", "prooftrans").exists(),
    "needs data/AIM/, GAPT_ROOT and LADR_DIR")
class TestImportControls(unittest.TestCase):
    """The control that makes a successful import mean something.

    GAPT's Prover9 importer re-checks each inference via `prooftrans ivy`, so a
    carved fragment that imports really is a derivation. These tests show the
    detector fires on a true positive and rejects two kinds of false one.
    """

    @classmethod
    def setUpClass(cls):
        cls.tmpdir = Path(os.environ.get("TMPDIR", "/tmp")) / "aim_subproof_ctrl"
        cls.tmpdir.mkdir(exist_ok=True)
        nodes = parse_proof(AIM_PF)
        # clause 62: (x*(y*z))*a(x,y,z) = (x*y)*z, a 4-step subproof
        cls.text, _ = carve(nodes, 62)
        cls.good = cls.tmpdir / "good.pf"
        cls.good.write_text(cls.text)

    def test_true_positive_imports(self):
        rec = probe_termset(self.good)
        self.assertEqual(rec["status"], "OK", rec.get("error"))
        self.assertEqual(rec["background"], "Equality")

    def test_falsified_step_is_rejected(self):
        lines = self.text.splitlines()
        for i, l in enumerate(lines):
            if l.startswith("62 "):
                lines[i] = ("62 (x * (y * z)) * a(x,y,z) = (y * x) * z.  "
                            + l.split("  ", 1)[1])
        bad = self.tmpdir / "bogus_step.pf"
        bad.write_text("\n".join(lines) + "\n")
        self.assertEqual(probe_termset(bad)["status"], "IMPORT_FAIL")

    def test_dropped_premise_is_rejected(self):
        lines = [l for l in self.text.splitlines() if not l.startswith("22 ")]
        bad = self.tmpdir / "missing_premise.pf"
        bad.write_text("\n".join(lines) + "\n")
        self.assertEqual(probe_termset(bad)["status"], "IMPORT_FAIL")


if __name__ == "__main__":
    unittest.main(verbosity=2)
