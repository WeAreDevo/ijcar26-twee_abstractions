import sys
from pathlib import Path
from datetime import datetime
import os
import numpy as np
project_root = Path(__file__).resolve().parents[2]
sys.path.append(project_root.as_posix())
os.chdir(project_root.as_posix())

script_dir = os.path.dirname(os.path.abspath(__file__))
from src.stitch.Abstractions import Stitch_Abstractions

from src.utils import expand_abstractions, extract_axioms_from_tptp_file, extract_terms_from_proof, normalize_equation, normalize_fof_term, to_fof, parse_fof_term, freeze
from data.experiments.util import get_base_times_with_flag, get_good_abstractions, get_good_axiom_experiments, get_good_hint_experiments

import json
import argparse
from functools import reduce

def parse_args():
    parser = argparse.ArgumentParser(description="Get meta-abstraction for theory experiment")
    parser.add_argument(
        "-d", "--experiment_dir",
        type=str,
        required=False,
        default="20250627_184531_LAT_7178373_264",
        help="Directory name containing the summary.json."
    )
    return parser.parse_args()


def compute_structural_similarity(axs1, axs2):
    """
    Computes similarity between two lists of axioms by averaging the best-match 
    structural similarity scores for each axiom.
    """
    def get_axiom_subtrees(ax):
        subtrees = set()
        # Handle both equations and plain terms
        parts = ax.split('=')
        for part in parts:
            # Parse to tree structure
            parsed = parse_fof_term(part.strip())
            # Freeze to make hashable (tuple instead of list)
            frozen = freeze(parsed)
            
            # Collect all subtrees
            stack = [frozen]
            while stack:
                node = stack.pop()
                subtrees.add(node)
                if isinstance(node, tuple):
                    # node is (func, arg1, arg2, ...)
                    stack.extend(node[1:])
        return subtrees

    def jaccard(s1, s2):
        if not s1 and not s2:
            return 1.0
        return len(s1 & s2) / len(s1 | s2)

    # Pre-compute subtrees for all axioms
    sets1 = [get_axiom_subtrees(ax) for ax in axs1]
    sets2 = [get_axiom_subtrees(ax) for ax in axs2]

    if not sets1 and not sets2:
        return 1.0
    if not sets1 or not sets2:
        return 0.0

    # Forward direction: for each ax in sets1, find best match in sets2
    score1 = 0.0
    for s1 in sets1:
        best = 0.0
        for s2 in sets2:
            sim = jaccard(s1, s2)
            if sim > best:
                best = sim
            if best == 1.0: break 
        score1 += best
    
    # Backward direction: for each ax in sets2, find best match in sets1
    score2 = 0.0
    for s2 in sets2:
        best = 0.0
        for s1 in sets1:
            sim = jaccard(s1, s2)
            if sim > best:
                best = sim
            if best == 1.0: break
        score2 += best
        
    return (score1 / len(sets1) + score2 / len(sets2)) / 2.0


def get_meta_abstractions(abstractions, iterations=4, max_arity=2):

    abstraction_rhss = [
            abs.split("= ", 1)[1] if "= " in abs else abs
            for abs in abstractions
        ]

    # Compute meta-abstraction
    meta_abstractions = Stitch_Abstractions(abstraction_rhss, iterations=iterations, max_arity=max_arity)
    
    return meta_abstractions.fo_abstractions


def get_abstractions(theory, goodness_threshold=0.5):
    """Get 'good' abstractions for a given theory."""
    experiments_dir = Path(project_root) / "data/experiments/27-07"

    compiled = get_good_abstractions(experiments_dir, goodness_threshold=goodness_threshold)
    abstractions = []
    for problem, successes in compiled["time_successes"].items():
        if theory not in problem:
            continue
        abs_for_problem = [entry["abstractions"] for entry, _ in successes]
        for abs in abs_for_problem:
            abstractions.extend(expand_abstractions(abs))

    return abstractions

def get_good_hints(theory, goodness_threshold=0.5, expreriments_dir="hints_17-11"):
    """Get 'good' hints for a given theory."""
    
def meta_abstractions_across_experiments(theory, goodness_threshold, iterations, max_arity):
    good_abs = get_abstractions(theory, goodness_threshold)
    m = get_meta_abstractions(good_abs, iterations=iterations, max_arity=max_arity)
    return m

def domain_hints_across_experiments(theory, goodness_threshold, experiments_dir = "hints_17-11"):
    experiments_dir = Path(project_root) / "data/experiments" / experiments_dir
    good_hints_experiments = get_good_hint_experiments(theory, goodness_threshold, experiments_dir)
    good_hints = set()
    for problem, experiments in good_hints_experiments.items():
        for entry in experiments:
            abstractions = [normalize_fof_term(a.split('=', 1)[1].strip()) for a in entry["expanded_abstractions"]] # normalize the RHS of the abstraction to ignore alpha-renaming
            good_hints.update(abstractions)
            
    return good_hints

def multi_ob_ranking(t1, t2, alpha=0.5, scale=None, tau=None,
                          clip_negative=True, cap_log_ratio=None):
    """
    Weighted geometric mean of absolute and relative improvement.
    For times t1 (without abstraction) and t2 (with abstraction), computes:
    m = ((Δ_+ / (scale+tau))^alpha) * (((t1+tau)/(t2+tau))^(1-alpha))

    Parameters
    ----------
    t1, t2 : array-like or float
        Times, allowing t2 == 0 (and even t1 == 0).
    alpha : float in [0,1]
    scale : float or None
        Typical scale; if None uses median of positive t2, else median of t1.
    tau : float or None
        Regularization constant. If None, uses 5th percentile of positive t2,
        with a fallback based on t1 if no positive t2 exists.
    clip_negative : bool
        If True, uses Δ_+ = max(t1 - t2, 0). Otherwise uses raw Δ.
    cap_log_ratio : float or None
        Optional cap on log((t1+tau)/(t2+tau)) to prevent extreme ratios
        from dominating. Example: cap_log_ratio=np.log(1000) caps ratio at 1000x.

    Returns
    -------
    m : ndarray or float
        Higher is better.
    """
    t1 = np.asarray(t1, dtype=float)
    t2 = np.asarray(t2, dtype=float)

    if np.any(t1 < 0) or np.any(t2 < 0):
        raise ValueError("This metric assumes nonnegative times.")

    if not (0.0 <= alpha <= 1.0):
        raise ValueError("alpha must be in [0, 1].")

    # Choose tau from data if not provided
    if tau is None:
        pos_t2 = t2[t2 > 0]
        if pos_t2.size > 0:
            tau = np.quantile(pos_t2, 0.05)
        else:
            # fallback if all t2 are zero
            tau = np.quantile(t1[t1 > 0], 0.05) if np.any(t1 > 0) else 1.0
        tau = max(tau, 1e-12)

    # Choose scale
    if scale is None:
        pos_t2 = t2[t2 > 0]
        if pos_t2.size > 0:
            scale = np.median(pos_t2)
        else:
            scale = np.median(t1)
        scale = max(scale, 1e-12)

    delta = t1 - t2
    if clip_negative:
        delta = np.maximum(delta, 0.0)

    # Dimensionless absolute term, stabilized
    abs_term = delta / (scale + tau)

    # Stabilized ratio
    log_ratio = np.log(t1 + tau) - np.log(t2 + tau)

    if cap_log_ratio is not None:
        log_ratio = np.clip(log_ratio, -cap_log_ratio, cap_log_ratio)

    # Compute in log-space for stability
    eps = 1e-12
    log_abs = np.log(np.maximum(abs_term, eps))
    log_m = alpha * log_abs + (1.0 - alpha) * log_ratio

    return np.exp(log_m)

def domain_abstractions_across_experiments(theory, goodness_threshold, experiments_dir = "axiom_abs_11-11"):
    experiments_dir = Path(project_root) / "data/experiments" / experiments_dir
    good_axioms_experiments = get_good_axiom_experiments(theory, goodness_threshold, experiments_dir)
    t1 = []
    t2 = []
    good_axioms = []
    for problem, experiments in good_axioms_experiments.items():
        for entry in experiments:
            abstractions = [normalize_fof_term(a.split('=', 1)[1].strip()) for a in entry["expanded_abstractions"]] # normalize the RHS of the abstraction to ignore alpha-renaming
            # zip abstractions with multi_ob_ranking(entry["base_time_user"], entry["abs_time_user"])
            # zipped = zip(abstractions, [multi_ob_ranking(entry["base_time_user"], entry["abs_time_user"])] * len(abstractions))
            t1.extend([entry["base_time_user"]] * len(abstractions))
            t2.extend([entry["abs_time_user"]] * len(abstractions))
            good_axioms.extend(abstractions)
    
    # calculate ranking scores
    scores = multi_ob_ranking(np.array(t1), np.array(t2))
    # sort good_axioms by their scores
    good_axioms = list(zip(good_axioms, scores))
    # combine scores for duplicate axioms by taking the sum of their scores
    ax_score_dict = {}
    for ax, score in good_axioms:
        if ax in ax_score_dict:
            ax_score_dict[ax] += score
        else:
            ax_score_dict[ax] = score
    good_axioms = list(ax_score_dict.items())
    # sort by score descending
    good_axioms.sort(key=lambda x: x[1], reverse=True)
    # return only the abstractions
    good_axioms = [ax for ax, _ in good_axioms]
    return good_axioms

def domain_hints_from_hints_stage(goodness_threshold, hints_dir):
    experiments_dir = Path(hints_dir)
    good_hints_experiments = get_good_hint_experiments(None, goodness_threshold=goodness_threshold, experiments_dir=experiments_dir, stage="hints")
    good_hints = set()
    for problem, experiments in good_hints_experiments.items():
        for entry in experiments:
            abstractions = [normalize_fof_term(a.split('=', 1)[1].strip()) for a in entry["expanded_abstractions"]] # normalize the RHS of the abstraction to ignore alpha-renaming
            good_hints.update(abstractions)
            
    return good_hints

def domain_hints_for_problem(theory, problem, problem_dir, goodness_threshold, experiments_dir = "hints_17-11"):
    experiments_dir = Path(project_root) / "data/experiments" / experiments_dir
    good_hints_experiments = get_good_hint_experiments(theory, goodness_threshold, experiments_dir)
    good_hints = set()
    p_axs = extract_axioms_from_tptp_file(problem_dir / problem)
    p_axs = [normalize_equation(ax) for ax in p_axs]
    for other_problem, experiments in good_hints_experiments.items():
        # check if the other_problem axioms match the problem axioms
        op_axs = extract_axioms_from_tptp_file(problem_dir / f"{other_problem}.p")
        op_axs = [normalize_equation(ax) for ax in op_axs]

        sim = compute_structural_similarity(p_axs, op_axs)
        if sim < 0.9:
            continue

        for entry in experiments:
            abstractions = [normalize_fof_term(a.split('=', 1)[1].strip()) for a in entry["expanded_abstractions"]] # normalize the RHS of the abstraction to ignore alpha-renaming
            good_hints.update(abstractions)
    
    return good_hints


def veroff_hints_for_problem(theory, problem, problem_dir, configs, base_times_path=None):
    if base_times_path is None:
        base_times_path = os.path.join("data", "experiments", "base_runs", "base_times.json")
    with open(base_times_path, "r") as f:
        base_times = json.load(f)
    if "--flatten-goal" in configs["twee"].get("flags", ""):
        base_times_f = get_base_times_with_flag(base_times, "--flatten-goal")
    elif "--no-flatten-goal" in configs["twee"].get("flags", ""):
        base_times_f = get_base_times_with_flag(base_times, "--no-flatten-goal")
    proof_hints_from_files = set()
    hints = set()
    p_axs = extract_axioms_from_tptp_file(problem_dir / problem)
    p_axs = [normalize_equation(ax) for ax in p_axs]
    # tptp_domain_dir = os.path.join("data", "TPTP", f"{theory}_UEQ_UNSAT")
    for other_problem in os.listdir(problem_dir):
        other_problem_name = other_problem.split('.', 1)[0]
        # check if the other_problem axioms match the problem axioms
        op_axs = extract_axioms_from_tptp_file(problem_dir / other_problem)
        op_axs = [normalize_equation(ax) for ax in op_axs]

        sim = compute_structural_similarity(p_axs, op_axs)
        if sim < 0.9:
            continue
        
        ## Get proof terms from base run on other_problem
        base_times_for_problem = base_times_f.get(other_problem_name, [])
        if not base_times_for_problem:
            continue
        min_base_time_entry = min(base_times_for_problem, key=lambda x: x["user_time"])
        base_dir = Path(os.getenv("LOG_DIR")) / min_base_time_entry["experiment"]
        base_output_path = base_dir / f"{other_problem_name}_base_output.txt"
        proof_hints_from_files.add(str(base_output_path))
        with open(base_output_path, "r") as f:
            base_output = f.read()

        extracted_terms = extract_terms_from_proof(base_output)
        # normalize extracted terms
        extracted_terms = {normalize_fof_term(t) for t in extracted_terms}
        hints.update(extracted_terms)
    
    return hints, proof_hints_from_files
    


if __name__ == "__main__":
    # args = parse_args()
    # experiment_dir = args.experiment_dir
    # theory = "LAT"
    # m = meta_abstractions_across_experiments(theory, goodness_threshold=0.1, iterations=4, max_arity=2)
    # p_axs = extract_axioms_from_tptp_file("/Users/guya/Projects/Twee/twee_abstractions/data/TPTP/ROB_UEQ_UNSAT/ROB001-1.p")
    # op_axs = extract_axioms_from_tptp_file("/Users/guya/Projects/Twee/twee_abstractions/src/stitch/tmp.p")
    # p_axs = [normalize_equation(ax) for ax in p_axs]
    # op_axs = [normalize_equation(ax) for ax in op_axs]
    # sim = compute_structural_similarity(p_axs, op_axs)
    domain_abstractions_across_experiments("REL", 0.8)
    pass