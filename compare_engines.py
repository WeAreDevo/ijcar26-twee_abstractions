"""
Compare Stitch and babble on corpora where the equational theory matters.

Both engines compress a corpus of first-order terms into reusable
abstractions. babble can additionally take an *equational theory* and compress
modulo it, so it can share structure between subterms that are equal under the
axioms but written differently. Stitch is purely syntactic and has no
equivalent.

Each example below is a corpus whose terms are all rearrangements of each
other under the associativity and commutativity of `add` -- axioms taken from
a real TPTP problem, not written by hand. Three configurations are run:

    stitch          the current backend
    babble          babble with no theory, to isolate the engine
    babble + theory babble compressing modulo the problem's axioms

The middle row is what makes the comparison honest: without it you cannot tell
whether a difference came from switching engines or from adding the theory.

    python compare_engines.py                  # synthetic examples (seconds)
    python compare_engines.py --real           # also a real twee proof

Requires BABBLE_ROOT in .env and the `fof` binary built; see the README.
"""

import os
import sys
import time
from pathlib import Path

project_root = Path(__file__).resolve().parents[0]
sys.path.append(project_root.as_posix())
os.chdir(project_root.as_posix())

from src.babble.Abstractions import Babble_Abstractions
from src.babble.theory import dsrs_for_problem
from src.stitch.Abstractions import Stitch_Abstractions
from src.utils import (
    expand_abstractions,
    extract_axioms_from_tptp_file,
    extract_terms,
    filter_out_higer_order_abstractions,
    filter_out_uninteresting,
)

# Robbins algebra: `add` is commutative and associative. Any UEQ problem with
# an AC operator would do; this one is small and its axioms are recognisable.
PROBLEM = "data/TPTP/ROB_UEQ_UNSAT/ROB001-1.p"

ITERATIONS = 3
MAX_ARITY = 3
SHOW_TERMS = 8  # a real proof has hundreds; the constructed examples are shorter

EXAMPLES = [
    (
        "Commutativity: the same pattern with its arguments flipped",
        [
            "negate(add(negate(a), a))",
            "negate(add(a, negate(a)))",
            "negate(add(negate(b), b))",
            "negate(add(b, negate(b)))",
        ],
        "Every term is `negate(add(negate(X), X))`. Half of them have the two\n"
        "arguments of `add` swapped, which a syntactic compressor cannot see\n"
        "through, so it learns the same concept twice.",
    ),
    (
        "Associativity: the same pattern nested the other way",
        [
            "negate(add(add(a,b),c))",
            "negate(add(a,add(b,c)))",
            "negate(add(add(a,b),d))",
            "negate(add(a,add(b,d)))",
        ],
        "Every term is `negate(add(add(a,b), X))`. Half of them are\n"
        "re-associated, which again splits one concept into two.",
    ),
    (
        "Both, scrambled six ways",
        [
            "negate(add(add(a,b),c))",
            "negate(add(c,add(b,a)))",
            "negate(add(b,add(a,c)))",
            "negate(add(add(a,b),d))",
            "negate(add(d,add(b,a)))",
            "negate(add(b,add(a,d)))",
        ],
        "Six terms, two distinct up to AC. babble without the theory learns one\n"
        "abstraction per spelling. Stitch learns a single one, but only by\n"
        "abstracting away `a` and `b` too -- an arity-3 skeleton that has given up\n"
        "on the shared constants, rather than the arity-1 pattern that keeps them.",
    ),
]


def arity_of(abstraction):
    """Number of parameters on the left-hand side of `fn_0(A, B) = ...`."""
    head = abstraction.split("=", 1)[0].strip()
    if "(" not in head:
        return 0
    return len(head[head.index("(") + 1: head.rindex(")")].split(","))


def first_order(abstractions):
    """Apply the same filtering the pipeline applies before emitting hints."""
    return expand_abstractions(
        filter_out_uninteresting(filter_out_higer_order_abstractions(abstractions))
    )


def run_stitch(terms, _rules):
    result = Stitch_Abstractions(terms, ITERATIONS, MAX_ARITY)
    return result.fo_abstractions, result.stitch_compression.json["compression_ratio"]


def run_babble(terms, rules):
    result = Babble_Abstractions(
        terms, iterations=ITERATIONS, max_arity=MAX_ARITY, dsrs=rules
    )
    return result.fo_abstractions, result.compression_ratio


CONFIGS = [
    ("stitch", run_stitch, None),
    ("babble", run_babble, None),
    ("babble + theory", run_babble, "rules"),
]


def compare(title, terms, commentary, rules):
    print(f"\n{'=' * 78}\n{title}\n{'=' * 78}")
    print(f"\n{len(terms)} terms:")
    for term in terms[:SHOW_TERMS]:
        print(f"    {term}")
    if len(terms) > SHOW_TERMS:
        print(f"    ... and {len(terms) - SHOW_TERMS} more")
    print(f"\n{commentary}\n")

    print(f"    {'engine':<16} {'ratio':>7}  {'kept':>4}  {'arity':>5}  abstractions")
    print(f"    {'-' * 16} {'-' * 7}  {'-' * 4}  {'-' * 5}  {'-' * 40}")

    for label, runner, wants_rules in CONFIGS:
        start = time.time()
        raw, ratio = runner(terms, rules if wants_rules else None)
        kept = first_order(raw)
        elapsed = time.time() - start

        if not kept:
            print(f"    {label:<16} {ratio:>7.3f}  {0:>4}  {'':>5}  (none)")
        for i, abstraction in enumerate(kept):
            left = f"    {label:<16} {ratio:>7.3f}  {len(kept):>4}" if i == 0 \
                else f"    {'':<16} {'':>7}  {'':>4}"
            print(f"{left}  {arity_of(abstraction):>5}  {abstraction}")
        if elapsed > 5:
            print(f"    {'':<16} {'':>7}  {'':>4}  {'':>5}  ({elapsed:.0f}s)")


def real_proof_example(rules):
    """The same comparison on the terms of an actual twee proof."""
    log_dir = os.getenv("LOG_DIR")
    proof = Path(log_dir or "") / "20260127_143452_LAT_local" / "LAT005-10_base_output.txt"
    if not proof.exists():
        print(f"\n(skipping --real: no proof output at {proof})")
        return

    terms = extract_terms(
        proof.read_text(), {"onlyProofTerms": True, "onlyPeakTerms": False}
    )
    lat_rules = dsrs_for_problem("data/TPTP/LAT_UEQ_UNSAT/LAT005-10.p")
    compare(
        "A real twee proof: LAT005-10, compressed modulo its own axioms",
        terms,
        "Not a constructed example -- these are the terms of the baseline proof,\n"
        "and the rules are that problem's lattice axioms. Slower, and the gain is\n"
        "smaller than above, because a real proof is not uniformly AC-scrambled.",
        lat_rules,
    )


if __name__ == "__main__":
    axioms = extract_axioms_from_tptp_file(PROBLEM)
    rules = dsrs_for_problem(PROBLEM)

    print(f"Theory taken from {PROBLEM}")
    print("\n  axioms:")
    for axiom in axioms:
        print(f"    {axiom}")
    print(f"\n  translated to {len(rules)} babble rewrite rules:")
    for rule in rules:
        print(f"    {rule}")
    print(
        "\n  The third axiom (Robbins) yields no rule: reversed it would need to\n"
        "  invent variables, and forwards it collapses a term to a subterm.\n"
        "  See `directed_rules` in src/babble/theory.py."
    )

    for title, terms, commentary in EXAMPLES:
        compare(title, terms, commentary, rules)

    if "--real" in sys.argv:
        real_proof_example(rules)

    print(f"\n{'=' * 78}")
    print(
        "Reading the table:\n"
        "  'kept' counts abstractions surviving the filters the pipeline applies\n"
        "  before emitting hints, so it is what a run would actually use.\n"
        "\n"
        "  'arity' matters as much as the count. A low-arity abstraction pins down\n"
        "  shared structure; a high-arity one has abstracted that structure away\n"
        "  and says less. One arity-3 skeleton is not the same win as one arity-1\n"
        "  pattern, even though both count as 'kept: 1'.\n"
        "\n"
        "  Compare ratios DOWN a column, not across engines: Stitch and babble\n"
        "  cost terms differently (n-ary vs curried application), so their cost\n"
        "  scales are unrelated. The cross-engine comparison that means something\n"
        "  is which abstractions each one finds.\n"
        "\n"
        "  The pattern to look for: the syntactic engines either learn the same\n"
        "  concept once per spelling, or fall back to a generic high-arity\n"
        "  skeleton. Only the theory row recovers the single specific pattern\n"
        "  that every term shares."
    )
