from logging import config
import os
import json
import sys
from pathlib import Path
import yaml
from collections import defaultdict
import ast

project_root = Path(__file__).resolve().parents[2]
sys.path.append(project_root.as_posix())
os.chdir(project_root.as_posix())
script_dir = os.path.dirname(os.path.abspath(__file__))

from dotenv import load_dotenv
import os
from pulp import LpProblem, LpVariable, LpMinimize, lpSum, LpBinary, value, LpMaximize

load_dotenv()
log_dir = os.getenv("LOG_DIR")

from data.experiments.util import get_base_times

def get_flattened_goal_experiments(experiments_dir):
    """ Returns a list of experiment names that use the --flatten-goal flag """
    experiments = [
        d for d in os.listdir(experiments_dir)
        if os.path.isdir(os.path.join(experiments_dir, d))
    ]

    runs = []
    for experiment in experiments:
        config_path = os.path.join(experiments_dir, experiment, "config.yaml")
        if not os.path.isfile(config_path):
            continue
        with open(config_path, "r") as f:
            config = yaml.safe_load(f)
            if "--flatten-goal" in config["twee"]["flags"]:
                runs.append(experiment)

    return runs


def results_by_problem(theory=None, include_flattened_goal_runs=True, include_unflattened_goal_runs=True):
    """ Returns a dictionary mapping each problem to a list of (experiment, base_time, abs_time, ) tuples """
    experiments_dir = Path(script_dir) / "local_abs_10iter"
    # base_times = get_base_times(experiments_dir)
    results_per_problem = defaultdict(list)
    experiments = os.listdir(experiments_dir)
    flattened_goal_runs = get_flattened_goal_experiments(experiments_dir)
    if not include_flattened_goal_runs:
        experiments = [e for e in experiments if e not in flattened_goal_runs]
    if not include_unflattened_goal_runs:
        experiments = [e for e in experiments if e in flattened_goal_runs]

    for experiment in experiments:
        if theory and theory not in experiment:
            continue
        summary_path = os.path.join(experiments_dir, experiment, "summary.json")
        if not os.path.isfile(summary_path):
            continue
        with open(summary_path, "r") as f:
            results = json.load(f)

        for entry in results:
            problem = entry.get("problem", "")
            base_time = entry.get("base_time", 0)
            base_status = entry.get("base_status", "error")
            abs_status = entry.get("augmented_status", "error")
            abs_time = entry.get("abs_time", "error")
            hints_status = entry.get("hints_status", "error")
            hints_time = entry.get("hints_time", "error")
            abstractions = entry.get("abstractions", [])
            if base_status == "success":
                results_per_problem[problem].append(
                    (experiment, base_time, 1000 if abs_status == "timeout" else abs_time, 1000 if hints_status == "timeout" else hints_time, abstractions)
                )
    
    return results_per_problem

def all_problem_hint_results_for_twee_config(theory=None, experiments="local_abs_10iter"):
    """ Returns a dict mapping each twee hint config to its results by problem """
    experiments_dir = Path(script_dir) / experiments
    config_results = defaultdict(list)
    experiments = os.listdir(experiments_dir)
    for experiment in experiments:
        summary_path = os.path.join(experiments_dir, experiment, "summary.json")
        if not os.path.isfile(summary_path):
            continue
        with open(summary_path, "r") as f:
            runs = json.load(f)
        config_path = os.path.join(experiments_dir, experiment, "config.yaml")
        with open(config_path, "r") as cf:
            config = yaml.safe_load(cf)
        twee_options = config["twee"]["flags"]
        if theory:
            twee_options += [f"theory : {config['theory']}"]
        twee_options = tuple(sorted(twee_options))

        results = []
        for entry in runs:
            problem = entry.get("problem", "")
            status = entry.get("status", "")
            # staus = entry.get("staus", "")
            if status in ["base timeout"]:
                continue
            base_time = entry["mean_base_user_time"]
            hints_status = entry.get("hints_status", "error")
            hints_time = entry.get("hints_time_user", "error")
            abstractions = entry.get("expanded_abstractions", [])
            if base_time:
                results.append({
                    "problem": problem,
                    "base_time": base_time,
                    "hints_time": None if hints_status != "success" else hints_time,
                    "abstractions": abstractions,
                    "experiment": experiment,
                })
        
        config_results[twee_options].extend(results)
    return config_results


def all_problem_hint_results_for_total_config(theory=None, experiments="uns_12-12"):
    """ Returns a dict mapping each twee hint experiment config to its results by problem """
    experiments_dir = Path(script_dir) / experiments
    config_results = defaultdict(list)
    experiments = os.listdir(experiments_dir)
    for experiment in experiments:
        summary_path = os.path.join(experiments_dir, experiment, "summary.json")
        if not os.path.isfile(summary_path):
            continue
        with open(summary_path, "r") as f:
            runs = json.load(f)
        config_path = os.path.join(experiments_dir, experiment, "config.yaml")
        with open(config_path, "r") as cf:
            config = yaml.safe_load(cf)
        if theory and config.get("theory") != theory:
            continue
        elif not theory:
            config = config.copy()
            del config["theory"] # CONSIDER ALL THEORIES TOGETHER
        config_key = tuple(sorted((k, str(v)) for k, v in config.items()))

        for entry in runs:
            problem = entry.get("problem", "")
            status = entry.get("status", "")
            hints_time = entry.get("hint_time_user", None)
            hints = entry.get("final_hints", [])
            # first check if config_results[config_key] contains an entry for this problem
            if any((existing:=r).get("problem")==problem for r in config_results.get(config_key, [])):
                # if so, check if this one is better (lower hints_time), and only keep the better one
                if existing.get("hints_time") is None or (hints_time is not None and hints_time < existing.get("hints_time")):
                    # replace existing entry
                    config_results[config_key] = [r for r in config_results[config_key] if r.get("problem")!=problem]
                else:
                    continue
            config_results[config_key].append({
                "problem": problem,
                "hints_time": hints_time,
                "abstractions": hints,
            })
    return config_results

def hints_analysis_by_config(theory = None, goodness_threshhold=1, config=None, experiments="local_abs_10iter"):
    if config is None:
        config=['--no-flatten-goal', '--all-lemmas', '--show-peaks', '--hint-skel-factor 0.5', '--hint-skel-cost 0']
    res_all = all_problem_hint_results_for_twee_config(theory=theory, experiments=experiments)
    # res[config] = [{'problem': p, 'base_time': x, 'hints_time': y, 'abstractions': list}, ....]
    if theory:
        config += [f"theory : {theory}"]
    res = res_all[tuple(sorted(config))]
    good_res = []
    for entry in res:
        base_time = entry["base_time"]
        hints_time = entry["hints_time"]
        if isinstance(hints_time, float) and hints_time < goodness_threshhold * base_time:
            good_res.append(entry)
    good_res = sorted(good_res, key=lambda r: r["base_time"] / (r["hints_time"] + 1), reverse=True)
    hints_time_zero = [r for r in good_res if r["hints_time"] == 0.0]
    return good_res


def list_hard_problems():
    base_times = get_base_times(Path(script_dir) / "base_runs")
    hard_problems = []
    for theory in ["ALG","BOO","COL","GRP","LAT","LCL","REL","RNG","ROB"]:
        tptp_dir = os.path.join("data", "TPTP", f"{theory}_UEQ_UNSAT")
        for problem in os.listdir(tptp_dir):
            tptp_path = os.path.join(tptp_dir, problem)
            # Extract the rating from the file problem.p
            rating = None
            with open(tptp_path, "r") as f:
                file_text = f.read()
                for line in file_text.splitlines():
                    if line.startswith("% Rating"):
                        # Extract first number after "% Rating   : "
                        parts = line.split(":")
                        if len(parts) > 1:
                            rating_str = parts[1].strip().split()[0]
                            try:
                                rating = float(rating_str)
                            except ValueError:
                                pass
                        break
            if rating is not None and rating >= 0.9 and problem.split(".")[0] not in base_times:
                hard_problems.append((problem, rating))

    # for problem, rating in hard_problems:
    #     print(f"{problem} (Rating: {rating})")
    return hard_problems

def get_problem_rating(problem):
    # get theory by taking the problem name before the first digit
    theory = ""
    for c in problem:
        if c.isdigit():
            break
        theory += c
    tptp_dir = os.path.join("data", "TPTP", f"{theory}_UEQ_UNSAT")
    tptp_path = os.path.join(tptp_dir, problem)
    # Extract the rating from the file problem.p
    rating = None
    with open(tptp_path, "r") as f:
        file_text = f.read()
        for line in file_text.splitlines():
            if line.startswith("% Rating"):
                # Extract first number after "% Rating   : "
                parts = line.split(":")
                if len(parts) > 1:
                    rating_str = parts[1].strip().split()[0]
                    try:
                        rating = float(rating_str)
                    except ValueError:
                        pass
                break
    return rating

def successes_per_config(successes):
    count_configs = defaultdict(list)
    for problem, runs in successes.items():
        for r in runs:
            config = r["config"].copy()
            #delete config["theory"] to consider all theories together
            if "theory" in config:
                del config["theory"]
            config_key = tuple(sorted((k, str(v)) for k, v in config.items()))
            count_configs[config_key].append(problem)
    sorted_count_configs = dict(sorted(count_configs.items(), key=lambda item: len(item[1]), reverse=True))
    return sorted_count_configs

def count_terminating_problems(theory=None, non_flattened=True, flattened=False):
    experiments_dir = Path(script_dir) / "base_runs"
    base_times = get_base_times(experiments_dir)
    base_times_nf = {}
    base_times_f = {}
    if non_flattened:
        base_times_nf = {p: t for p, t in base_times.items() if any(["--no-flatten-goal" in e["config"]["twee"]["flags"] for e in t])}
    if flattened:
        base_times_f = {p: t for p, t in base_times.items() if any(["--flatten-goal" in e["config"]["twee"]["flags"] for e in t])}
    # union of base_times_nf and base_times_f
    # diff = base_times_f.keys() - base_times_nf.keys()
    base_times = base_times_f | base_times_nf
    terminating = list(base_times.keys())
    if theory:
        terminating = [p for p in terminating if p.startswith(theory)]
    return terminating

    
if __name__ == "__main__":
    pass