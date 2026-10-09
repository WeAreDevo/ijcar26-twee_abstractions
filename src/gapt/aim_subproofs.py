"""Carve self-contained Prover9 refutations out of a large Prover9 proof.

Motivation: GAPT cut-introduction is gated by the Herbrand term set of the input
proof (usable band ~5-50 terms; see PROGRESS_herbrand.md and AIM_GAPT.md).
Veroff's `data/AIM/aa2_to_aa3.pf` is 10,221 inferences and far outside it.  But
*every intermediate clause* of that proof has its own derivation -- the ancestor
subgraph -- and those span the whole size range from 2 steps upwards.  This
module turns any such subgraph back into a Prover9 refutation that GAPT can
import, so cut-introduction can be applied to genuine fragments of the original
proof rather than to re-proofs.

Construction, for a target clause `n` whose clause is a unit equation `s = t`:

    <ancestor clauses of n, verbatim, with their original ids and justifications>
    90001  s = t            # label(non_clause) # label(goal).  [goal].
    90002  s[c/x] != t[c/x]                                     [deny(90001)].
    90003  $F                                        [resolve(n,a,90002,a)].

This is *not* trusted blindly: GAPT's importer shells out to `prooftrans ivy`,
which re-checks every inference.  `test_aim_subproofs.py` pins that a falsified
step and a dropped premise are both rejected, so a successful import means the
carved fragment really is a checked derivation.

Usage:

    # list candidate sub-lemmas spanning a range of subproof sizes
    python src/gapt/aim_subproofs.py ladder data/AIM/aa2_to_aa3.pf

    # write subproof files for specific clause ids
    python src/gapt/aim_subproofs.py carve data/AIM/aa2_to_aa3.pf out/ 92 62 133

    # carve + probe term sets for a whole ladder (resumable)
    python src/gapt/aim_subproofs.py probe data/AIM/aa2_to_aa3.pf out/ --json p.json
"""

import argparse
import json
import os
import re
import subprocess
import sys
import time
from pathlib import Path

from dotenv import load_dotenv

project_root = Path(__file__).resolve().parents[2]
load_dotenv(project_root / ".env")

GAPT_ROOT = os.getenv("GAPT_ROOT") or (project_root / "third_party" / "gapt-2.19.0").as_posix()
LADR_DIR = os.getenv("LADR_DIR")
PROBE_SCRIPT = project_root / "src" / "gapt" / "probe_termset.scala"

# A Prover9 proof line: "<id> <clause>.  [<justification>]."
LINE = re.compile(r"^(\d+)\s+(.*?)\s*\.\s+\[(.*)\]\.\s*$")
# Prover9's default convention: a symbol is a variable iff it starts with u-z.
# twee's X2-style names do not occur here, but v5, v6, ... do -- hence the digits.
VAR = re.compile(r"(?<![A-Za-z0-9_])([u-z][0-9]*)(?![A-Za-z0-9_])")
# ids referenced as `11(a,1)` inside para/back_demod-style justifications
REF_WITH_POS = re.compile(r"(?<![\d.])(\d+)\(")
# inference functors whose bare integer arguments are clause ids
BARE_REF = re.compile(
    r"\b(?:hyper|resolve|clausify|copy|deny|back_demod|back_unit_del|factor|merge|xx)"
    r"\(([^()]*(?:\([^()]*\)[^()]*)*)\)")

HEADER = """============================== prooftrans ============================
Prover9 (64) version 2017-09A, September 2017.
Process 1 was started by claude on localhost,
Thu Sep 17 00:00:00 2026
The command was "prover9 -f {src}".
============================== end of head ===========================

============================== end of input ==========================

============================== PROOF =================================

% -------- Comments from original proof --------
% Sub-proof of clause {cid} carved from {src} by src/gapt/aim_subproofs.py.
% Goal: {clause}

"""


# --------------------------------------------------------------------------
# proof DAG
# --------------------------------------------------------------------------

def parents_of(just: str):
    """Clause ids referenced by a Prover9 justification string.

    Two shapes coexist and both must be handled: `para(11(a,1),13(a,1,2))`
    puts the id immediately before a position list, while
    `hyper(17,a,16,a(flip),b,88,a)` alternates bare ids with literal labels.
    The position numbers inside `(a,1,2)` are NOT clause ids.
    """
    out = [int(m) for m in REF_WITH_POS.findall(just)]
    for m in BARE_REF.finditer(just):
        for tok in re.split(r",(?![^(]*\))", m.group(1)):
            tok = tok.strip()
            if tok.isdigit():
                out.append(int(tok))
    return sorted(set(out))


def parse_proof(path):
    """Parse the PROOF block of a prooftrans (.pf) file into {id: node}."""
    nodes, inside = {}, False
    for line in Path(path).read_text().splitlines():
        if line.startswith("====="):
            if "PROOF" in line:
                inside = True
            elif "end of proof" in line:
                inside = False
            continue
        if not inside:
            continue
        m = LINE.match(line.strip())
        if not m:
            continue
        cid = int(m.group(1))
        nodes[cid] = {"id": cid, "clause": m.group(2), "just": m.group(3),
                      "parents": [p for p in parents_of(m.group(3)) if p != cid]}
    return nodes


def ancestors_of(nodes, root):
    """Ancestor ids of one clause, including itself, by DFS.

    A missing parent is an error, not something to skip: silently dropping it
    would emit a subproof with a hole, which `prooftrans ivy` would then reject
    for reasons that look like a bug in the carving rather than in the input.
    """
    seen, stack = set(), [root]
    while stack:
        n = stack.pop()
        if n in seen:
            continue
        if n not in nodes:
            raise KeyError(f"justification references clause {n}, absent from the proof")
        seen.add(n)
        stack.extend(nodes[n]["parents"])
    return seen


def ancestor_sets(nodes):
    """{id: set of ancestor ids, including itself}, in one topological pass.

    Only valid on a complete proof; use `ancestors_of` for a single target.
    """
    order = sorted(nodes)
    assert all(p < n for n in order for p in nodes[n]["parents"]), \
        "proof is not topologically ordered by clause id"
    anc = {}
    for n in order:
        s = {n}
        for p in nodes[n]["parents"]:
            s |= anc[p]
        anc[n] = s
    return anc


def is_unit_equation(clause: str) -> bool:
    """Unit positive equation, and not the goal/answer-annotated clause."""
    return "|" not in clause and "!=" not in clause and "=" in clause and "#" not in clause


# --------------------------------------------------------------------------
# carving
# --------------------------------------------------------------------------

def carve(nodes, cid, src="aa2_to_aa3.pf"):
    """Build a standalone Prover9 refutation text proving clause `cid`.

    Returns (text, number_of_original_steps).
    """
    clause = nodes[cid]["clause"]
    if not is_unit_equation(clause):
        raise ValueError(f"clause {cid} is not a plain unit equation: {clause}")
    anc = sorted(ancestors_of(nodes, cid))

    variables = sorted(set(VAR.findall(clause)))
    # Fresh Skolem constants. They must NOT start with u-z, or Prover9 would
    # read them back as variables and the denial would be vacuous.
    consts = {v: f"c{100 + i}" for i, v in enumerate(variables)}
    subst = lambda s: VAR.sub(lambda m: consts[m.group(1)], s)

    goal_id, deny_id, false_id = 90001, 90002, 90003
    lines = [f'{goal_id} {clause} # label("sub{cid}") # label(non_clause) '
             f'# label(goal).  [goal].']
    lines += [f'{n} {nodes[n]["clause"]}.  [{nodes[n]["just"]}].' for n in anc]
    lhs, rhs = clause.split("=", 1)
    lines.append(f'{deny_id} {subst(lhs.strip())} != {subst(rhs.strip())} '
                 f'# label("sub{cid}") # answer("sub{cid}").  [deny({goal_id})].')
    lines.append(f'{false_id} $F # answer("sub{cid}").  '
                 f'[resolve({cid},a,{deny_id},a)].')

    text = (HEADER.format(cid=cid, src=src, clause=clause) + "\n".join(lines)
            + "\n\n============================== end of proof "
              "==========================\n")
    return text, len(anc)


def ladder(nodes, wants=None):
    """Pick one sub-lemma per requested subproof size, spanning the proof."""
    wants = wants or [2, 3, 4, 5, 6, 8, 10, 13, 16, 20, 25, 32, 40, 50, 64, 80,
                      100, 128, 160, 200, 256, 320, 400, 500, 640, 800, 1000,
                      1300, 1600, 2000, 2500, 3200, 4000, 5000, 6400, 8000, 10000]
    anc = ancestor_sets(nodes)
    size = {n: len(anc[n]) for n in nodes}
    cands = [n for n in sorted(nodes)
             if is_unit_equation(nodes[n]["clause"]) and size[n] > 1]
    chosen, used = [], set()
    for want in wants:
        pool = [n for n in cands if n not in used]
        if not pool:
            break
        best = min(pool, key=lambda n: (abs(size[n] - want), n))
        used.add(best)
        chosen.append((best, size[best], nodes[best]["clause"]))
    return chosen


# --------------------------------------------------------------------------
# term-set probe
# --------------------------------------------------------------------------

def probe_termset(proof_file, heap="2g", timeout=600):
    """Import one proof into GAPT and report term-set statistics only."""
    env = dict(os.environ)
    if LADR_DIR:  # prooftrans; without it every Prover9 import throws
        env["PATH"] = f"{Path(LADR_DIR) / 'bin'}:{env.get('PATH', '')}"
    cmd = ["java", f"-Xmx{heap}", "-Xss20m", "-cp", "gapt-2.19.0.jar",
           "gapt.cli.CLIMain", PROBE_SCRIPT.as_posix(),
           Path(proof_file).resolve().as_posix()]
    started = time.time()
    try:
        out = subprocess.run(cmd, cwd=GAPT_ROOT, env=env, capture_output=True,
                             text=True, timeout=timeout).stdout
    except subprocess.TimeoutExpired:
        return {"status": "IMPORT_TIMEOUT", "seconds": round(time.time() - started, 1)}
    fields = dict(l.split("\t", 1) for l in out.splitlines() if "\t" in l)
    if "PROBE_OK" not in fields:
        return {"status": "IMPORT_FAIL", "seconds": round(time.time() - started, 1),
                "error": fields.get("PROBE_FAIL", out)[:300]}
    rec = {"status": "OK",
           "termset": int(fields["TERMSET_SIZE"]),
           "roots": int(fields["TERMSET_DISTINCT_ROOTS"]),
           "max_depth": int(fields["TERMSET_MAX_DEPTH"]),
           "avg_depth": round(float(fields["TERMSET_AVG_DEPTH"]), 2),
           "background": fields.get("BACKGROUND_THEORY"),
           "seconds": round(time.time() - started, 1)}
    # "trivial" in the paper's sense: every term has a distinct root symbol, so
    # each end-sequent formula was instantiated once and nothing can compress.
    rec["trivial"] = rec["roots"] == rec["termset"]
    return rec


# --------------------------------------------------------------------------
# CLI
# --------------------------------------------------------------------------

def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)

    p = sub.add_parser("ladder", help="list sub-lemmas spanning subproof sizes")
    p.add_argument("proof")

    p = sub.add_parser("carve", help="write subproof files for given clause ids")
    p.add_argument("proof")
    p.add_argument("outdir")
    p.add_argument("ids", nargs="+", type=int)

    p = sub.add_parser("probe", help="carve a ladder and probe each term set")
    p.add_argument("proof")
    p.add_argument("outdir")
    p.add_argument("--json")
    p.add_argument("--heap", default="2g")
    p.add_argument("--timeout", type=int, default=600)
    p.add_argument("--skip-existing", action="store_true",
                   help="keep records already present in --json")

    args = ap.parse_args()
    nodes = parse_proof(args.proof)
    src = Path(args.proof).name

    if args.cmd == "ladder":
        print(f"{len(nodes)} clauses parsed from {src}")
        for cid, steps, clause in ladder(nodes):
            print(f"{cid:>6}  steps={steps:>6}  {clause[:80]}")
        return

    outdir = Path(args.outdir)
    outdir.mkdir(parents=True, exist_ok=True)

    if args.cmd == "carve":
        for cid in args.ids:
            text, steps = carve(nodes, cid, src)
            path = outdir / f"sub{cid}.pf"
            path.write_text(text)
            print(f"{path}  steps={steps}  {nodes[cid]['clause'][:60]}")
        return

    results = {}
    if args.json and args.skip_existing and Path(args.json).exists():
        results = json.load(open(args.json))
    print(f"{'cid':>6} {'steps':>6} {'tset':>6} {'roots':>5} {'maxd':>5} "
          f"{'avgd':>6} {'triv':>5}  clause")
    for cid, steps, clause in ladder(nodes):
        if str(cid) in results:
            continue
        text, _ = carve(nodes, cid, src)
        path = outdir / f"sub{cid}.pf"
        path.write_text(text)
        rec = probe_termset(path, heap=args.heap, timeout=args.timeout)
        rec.update(cid=cid, steps=steps, clause=clause)
        results[str(cid)] = rec
        if rec["status"] == "OK":
            print(f"{cid:>6} {steps:>6} {rec['termset']:>6} {rec['roots']:>5} "
                  f"{rec['max_depth']:>5} {rec['avg_depth']:>6.2f} "
                  f"{str(rec['trivial']):>5}  {clause[:60]}")
        else:
            print(f"{cid:>6} {steps:>6} {rec['status']:>30}  {clause[:50]}")
        sys.stdout.flush()
        if args.json:
            json.dump(results, open(args.json, "w"), indent=1)


if __name__ == "__main__":
    main()
