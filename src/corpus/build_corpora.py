"""Build the uniform term corpora for the concept-recovery experiment.

    python src/corpus/build_corpora.py

Walks every proof acquired in phase 0 and writes one corpus file per proof to
data/corpora/<corpus>/<problem>__<variant>.json:

    aim_lc/{first_sketch,second_sketch,lc}[_expanded]__<goal>.json   (42)
    bol_moufang/thmN__otter.json and thmN__twee.json                 (18)
    bml_aim/3_goal_N__twee.json                                      (6)

Each file holds the phase-0 metadata, the term records (see
src/corpus/extraction.py for the record shape and normalization rules), and
the ready-to-use Stitch and Babble encodings, aligned index-for-index with
the records. data/corpora/manifest.json summarizes everything.

The outputs are derived data, regenerable by this script; data/corpora/ is
gitignored.
"""

import json
import sys
from pathlib import Path

project_root = Path(__file__).resolve().parents[2]
sys.path.append(project_root.as_posix())

from src.corpus.extraction import (
    babble_input,
    stitch_input,
    terms_from_otter_theorem,
    terms_from_prover9_proof,
    terms_from_twee_output,
)

DATA = project_root / "data"
OUT = DATA / "corpora"


def write_corpus(rel_path: str, header: dict, records: list) -> dict:
    out_path = OUT / rel_path
    out_path.parent.mkdir(parents=True, exist_ok=True)
    corpus = {
        **header,
        "n_terms": len(records),
        "n_input_terms": sum(r["is_input"] for r in records),
        "n_distinct_terms": len({r["term"] for r in records}),
        "records": records,
        "stitch": stitch_input(records),
        "babble": babble_input(records),
    }
    out_path.write_text(json.dumps(corpus, indent=1))
    return {"path": rel_path, **{k: corpus[k] for k in
            ["corpus", "problem", "prover", "n_terms", "n_input_terms", "n_distinct_terms"]},
            "expanded": header.get("expanded", False)}


def build_aim(manifest: list):
    metadata = {(m["problem"], m["expanded"]): m
                for m in json.loads((DATA / "aim_lc" / "metadata.json").read_text())}
    for stem in ["first_sketch", "second_sketch", "lc"]:
        for expanded in [False, True]:
            suffix = "_expanded" if expanded else ""
            parsed = json.loads((DATA / "aim_lc" / "parsed" / f"{stem}{suffix}.json").read_text())
            for proof in parsed:
                problem = f"{stem}:{proof['goal']}"
                manifest.append(write_corpus(
                    f"aim_lc/{stem}{suffix}__{proof['goal']}.json",
                    {"corpus": "aim_lc", "problem": problem, "prover": "prover9",
                     "expanded": expanded,
                     "source": f"data/aim_lc/parsed/{stem}{suffix}.json",
                     "metadata": metadata[(problem, expanded)]},
                    terms_from_prover9_proof(proof)))


def build_bol_moufang(manifest: list):
    metadata = {m["problem"]: m
                for m in json.loads((DATA / "bol_moufang" / "metadata.json").read_text())}
    theorems = json.loads((DATA / "bol_moufang" / "parsed" / "qbm.json").read_text())
    for theorem in theorems:
        problem = f"thm{theorem['number']}"
        manifest.append(write_corpus(
            f"bol_moufang/{problem}__otter.json",
            {"corpus": "bol_moufang", "problem": problem, "prover": "otter",
             "source": "data/bol_moufang/parsed/qbm.json",
             "metadata": metadata[problem]},
            terms_from_otter_theorem(theorem)))

        trace = DATA / "bol_moufang" / "twee" / f"{problem}.out"
        manifest.append(write_corpus(
            f"bol_moufang/{problem}__twee.json",
            {"corpus": "bol_moufang", "problem": problem, "prover": "twee",
             "source": trace.relative_to(project_root).as_posix(),
             "metadata": metadata[problem]},
            terms_from_twee_output(trace.read_text())))


def build_bml_aim(manifest: list):
    twee_summary = json.loads((DATA / "bml_aim" / "twee" / "summary.json").read_text())
    for goal, info in sorted(twee_summary.items()):
        trace = DATA / "bml_aim" / "twee" / f"{goal}.out"
        manifest.append(write_corpus(
            f"bml_aim/{goal}__twee.json",
            {"corpus": "bml_aim", "problem": goal, "prover": "twee",
             "source": trace.relative_to(project_root).as_posix(),
             "metadata": {"corpus": "bml_aim", "problem": goal, "prover": "twee",
                          "uses_hints": False, "demodulation_free": False,
                          "signature": ["*", "\\", "/", "0", "1", "a", "K", "L", "R", "T"],
                          "derived_symbols_present": True, "twee": info}},
            terms_from_twee_output(trace.read_text())))


if __name__ == "__main__":
    OUT.mkdir(exist_ok=True)
    manifest = []
    build_aim(manifest)
    build_bol_moufang(manifest)
    build_bml_aim(manifest)
    (OUT / "manifest.json").write_text(json.dumps(manifest, indent=1))
    total = sum(m["n_terms"] for m in manifest)
    print(f"{len(manifest)} corpora, {total:,} term occurrences -> {OUT.relative_to(project_root)}/")
    for m in manifest:
        print(f"  {m['path']}: {m['n_terms']} terms "
              f"({m['n_input_terms']} input, {m['n_distinct_terms']} distinct)")
