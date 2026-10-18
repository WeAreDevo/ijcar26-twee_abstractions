"""Step counts compatible with Krympa revision 7c19dec495a0271c1981c0e84e57ce3777415aeb.

These measure printed derivations, not term size or fully expanded proof trees (i.e each lemma counted once).
The primitive counters reproduce rust/src/prover_wrapper.rs. Vampire input
must already be a direct proof to reproduce the paper's measurement.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import re

METRIC = "krympa_steps_v1"
KRYMPA_REVISION = "7c19dec495a0271c1981c0e84e57ce3777415aeb"
VAMPIRE_INFERENCES = (
    "demodulation", "superposition", "resolution", "trivial inequality removal",
)


def count_twee_steps(proof: str) -> int:
    """Count '= { by' lines after the first Proof:, including all lemma chains."""
    in_proof = False
    count = 0
    for line in proof.splitlines():
        line = line.lstrip()
        if line.startswith("Proof:"):
            in_proof = True
        elif in_proof and "= { by" in line:
            count += 1
    return count


def count_vampire_steps(proof: str) -> int:
    """Port Krympa's textual inference filter; this does not turn refutations around."""
    count = 0
    for line in proof.splitlines():
        line = line.lstrip()
        if not line or line.startswith("%"):
            continue
        if "." in line:
            line = line.split(".", 1)[1].lstrip()
        if "[" in line and any(tag in line for tag in VAMPIRE_INFERENCES):
            count += 1
    return count


def count_superposition_steps(proof: str) -> int:
    """Count Krympa's annotated Vampire lemma definitions, not dependency mentions."""
    return len(re.findall(r"^\s*%\s*[A-Za-z_]*lemma_\d+\s*:", proof, re.MULTILINE))


def measure_proof(proof: str, proof_format: str) -> dict:
    """Measure a supplied derivation. This is not a proof-validity check."""
    if proof_format not in ("twee", "vampire", "krympa"):
        raise ValueError(f"Unknown proof format: {proof_format}")
    twee = count_twee_steps(proof) if proof_format != "vampire" else 0
    vampire = count_vampire_steps(proof) if proof_format != "twee" else 0
    annotated = count_superposition_steps(proof) if proof_format == "krympa" else 0
    return {
        "metric": METRIC,
        "steps": twee + vampire + annotated,
        "twee_steps": twee,
        "vampire_steps": vampire,
        "annotated_vampire_steps": annotated,
    }


def measure_completed_twee_proof(output: str) -> dict | None:
    """Return no size for failed, partial, or proof-suppressed Twee output.

    A completed reflexive proof can legitimately have zero steps.
    """
    results = re.findall(r"^RESULT:\s*(\w+)", output, re.MULTILINE)
    if not results or results[-1] not in ("Theorem", "Unsatisfiable"):
        return None
    if not any(line.lstrip().startswith("Proof:") for line in output.splitlines()):
        return None
    return measure_proof(output, "twee")


def measure_krympa_run(proof: str, baseline: str, minimize_log: str) -> dict:
    """Keep the artifact recount, upstream accounting, and benchmark cap separate.

    Upstream sometimes carries pre-trimming counts through fallback paths, so
    a mismatch must remain visible rather than silently selecting one count.
    """
    def reported(label):
        matches = re.findall(
            rf"^\[RESULT\] {re.escape(label)}:\s*(\d+)\s*$",
            minimize_log, re.MULTILINE,
        )
        if len(matches) != 1:
            raise ValueError(f"Expected one Krympa result for {label!r}")
        return int(matches[0])

    result = measure_proof(proof, "krympa")
    baseline_steps = count_vampire_steps(baseline)
    reported_steps = reported("Total steps")
    reported_baseline = reported("Initial proof steps")
    result.update(
        baseline_steps=baseline_steps,
        reported_steps=reported_steps,
        reported_baseline_steps=reported_baseline,
        benchmark_steps=min(baseline_steps, reported_steps),
        counts_match=(result["steps"] == reported_steps
                      and baseline_steps == reported_baseline),
    )
    return result


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("proof", type=Path)
    parser.add_argument("--format", choices=("twee", "vampire", "krympa"), required=True)
    args = parser.parse_args()
    proof = args.proof.read_text()
    if args.format == "twee":
        result = measure_completed_twee_proof(proof)
        if result is None:
            parser.error("No completed Twee proof found")
    else:
        result = measure_proof(proof, args.format)
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
