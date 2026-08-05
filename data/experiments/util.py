import json
import sys
from dotenv import load_dotenv
import os
from pathlib import Path
from collections import defaultdict
import yaml

project_root = Path(__file__).resolve().parents[2]
script_dir = os.path.dirname(os.path.abspath(__file__))

sys.path.append(project_root.as_posix())
from src.utils import extract_terms_from_proof

load_dotenv()
log_dir = os.getenv("LOG_DIR")

def get_last_nonempty_line(file_path, chunk_size=8192):
    """
    Efficiently read the last non-empty line of a file without loading it all into memory.
    Reads backwards from the end in chunks.
    
    Args:
        file_path: Path to the file
        chunk_size: Size of chunks to read (default 8KB)
    
    Returns:
        The last non-empty line as a string (stripped), or None if file is empty
    """
    with open(file_path, 'rb') as f:
        f.seek(0, os.SEEK_END)
        file_size = f.tell()
        
        if file_size == 0:
            return None
        
        buffer = b''
        position = file_size
        
        while position > 0:
            # Read a chunk from the end
            read_size = min(chunk_size, position)
            position -= read_size
            f.seek(position)
            chunk = f.read(read_size)
            buffer = chunk + buffer
            
            # Try to find lines in buffer
            lines = buffer.split(b'\n')
            
            # If we found at least 2 parts (meaning at least one newline), check from the end
            if len(lines) > 1:
                # Check lines from end, skipping the last empty one if exists
                for line in reversed(lines[:-1] if lines[-1] == b'' else lines):
                    line_str = line.decode('utf-8', errors='ignore').strip()
                    if line_str:
                        return line_str
            
            # If we've read the whole file and found nothing
            if position == 0:
                # Check the buffer one more time
                line_str = buffer.decode('utf-8', errors='ignore').strip()
                return line_str if line_str else None
        
        return None

def get_base_times_with_flag(base_times, flag):
    filtered_times = {}
    for problem, experiments in base_times.items():
        filtered_times[problem] = [experiment for experiment in experiments if flag in experiment["config"]["twee"]["flags"]]
    return filtered_times

# def get_flattened_times(base_times):
#     flattened_times = {}
#     for problem, times in base_times.items():
#         flattened_times[problem] = [t[0] for t in times if "--flatten-goal" in t[1]["twee"]["flags"]]
#     return flattened_times

# def get_non_flattened_times(base_times):
#     non_flattened_times = {}
#     for problem, times in base_times.items():
#         non_flattened_times[problem] = [t[0] for t in times if "--no-flatten-goal" in t[1]["twee"]["flags"]]
#     return non_flattened_times

def compile_base_times(experiments_dir, id = None):
    experiments = [
        d for d in os.listdir(experiments_dir)
        if (id is None or id in d)
        and os.path.isdir(os.path.join(experiments_dir, d))
    ]
    base_times = defaultdict(list)

    for experiment in experiments:
        summary_path = os.path.join(experiments_dir, experiment, "summary.json")
        config_path = os.path.join(experiments_dir, experiment, "config.yaml")
        if not (os.path.isfile(summary_path)):
            continue
        # Load the data
        with open(summary_path, "r") as f:
            data = json.load(f)

        # Load the config (if exists)
        config = None
        if os.path.isfile(config_path):
            try:
                with open(config_path, "r") as cf:
                    config = yaml.safe_load(cf)
            except Exception:
                config = None

        for entry in data:
            if entry.get("base_status", "") == "success" and "base_time" in entry:
                base_times[entry["problem"]].append({"user_time" : entry["base_time_user"], "config": config, "experiment": experiment})
    
    return base_times

def compile_base_output_locations(experiments_dir):
    experiments = [
        d for d in os.listdir(experiments_dir)
        if os.path.isdir(os.path.join(experiments_dir, d))
        and "base" in d
    ]

    m = defaultdict(list)
    for experiment in experiments:
        summary_path = os.path.join(experiments_dir, experiment, "summary.json")
        config_path = os.path.join(experiments_dir, experiment, "config.yaml")
        if not (os.path.isfile(summary_path)):
            continue
        # Load the data
        with open(summary_path, "r") as f:
            data = json.load(f)

        # Load the config (if exists)
        config = None
        if os.path.isfile(config_path):
            try:
                with open(config_path, "r") as cf:
                    config = yaml.safe_load(cf)
            except Exception:
                config = None
        for entry in data:
            problem = entry.get("problem", "")
            if not any(("--flatten-goal" in entry["config"]["twee"]["flags"]) == ("--flatten-goal" in config["twee"]["flags"]) for entry in m[problem]):
                file_path = os.path.join(experiment, problem + "_base_output.txt")
                m[problem].append({
                    "output_file": file_path,
                    "config": config,
                })
    return m


def compile_base_proof_lengths(experiments_dir):
    experiments = [
        d for d in os.listdir(experiments_dir)
        if os.path.isdir(os.path.join(experiments_dir, d))
    ]
    base_lengths = defaultdict(list)

    for experiment in experiments:
        config_path = os.path.join(experiments_dir, experiment, "config.yaml")
        experiment_dir = os.path.join(log_dir, experiment)
        if os.path.isfile(config_path):
            with open(config_path, "r") as cf:
                config = yaml.safe_load(cf)

        flags = config.get("twee", {}).get("flags", []) if config else []
        for root, _, files in os.walk(experiment_dir):
            for file in files:
                if file.endswith("_base_output.txt"):
                    problem_name = file.replace("_base_output.txt", "")
                    do_append = False
                    if base_lengths[problem_name]:
                        if "--flatten-goal" in flags and not any("--flatten-goal" in entry["config"]["twee"]["flags"] for entry in base_lengths[problem_name]):
                            do_append = True
                        elif "--no-flatten-goal" in flags and not any("--no-flatten-goal" in entry["config"]["twee"]["flags"] for entry in base_lengths[problem_name]):
                            do_append = True
                    else:
                        do_append = True
                    if do_append:
                        proof_path = os.path.join(root, file)
                        # get last non-empty line of very large file efficiently
                        last_line = get_last_nonempty_line(proof_path)
                        if last_line is None or "GaveUp" in last_line:
                            continue
                        with open(proof_path, "r") as pf:
                            proof_text = pf.read()
                        terms = extract_terms_from_proof(proof_text)
                        proof_length = len(terms)
                        base_lengths[problem_name].append({"proof_length": proof_length, "config": config, "experiment": experiment})
        
    # write to file
    output_path = experiments_dir / "base_proof_lengths.json"
    with open(output_path, "w") as f:
        json.dump(base_lengths, f, indent=2)

def compile_hint_proof_lengths(experiments_dir):
    experiments = [
        d for d in os.listdir(experiments_dir)
        if os.path.isdir(os.path.join(experiments_dir, d))
    ]
    hint_lengths = defaultdict(list)

    for experiment in experiments:
        config_path = os.path.join(experiments_dir, experiment, "config.yaml")
        experiment_dir = os.path.join(log_dir, experiment)
        if os.path.isfile(config_path):
            with open(config_path, "r") as cf:
                config = yaml.safe_load(cf)

        for root, _, files in os.walk(experiment_dir):
            for file in files:
                if file.endswith("_with_hints_output.txt"):
                    problem_name = file.replace("_with_hints_output.txt", "")
                    proof_path = os.path.join(root, file)
                    # get last non-empty line of very large file efficiently
                    last_line = get_last_nonempty_line(proof_path)
                    if last_line is None or "GaveUp" in last_line:
                        continue
                    with open(proof_path, "r") as pf:
                        proof_text = pf.read()
                    terms = extract_terms_from_proof(proof_text)
                    proof_length = len(terms)
                    hint_lengths[problem_name].append({"proof_length": proof_length, "config": config, "experiment": experiment})
                   
    # write to file
    output_path = experiments_dir / "hint_proof_lengths.json"
    with open(output_path, "w") as f:
        json.dump(hint_lengths, f, indent=2)

def compile_axiom_proof_lengths(experiments_dir):
    experiments = [
        d for d in os.listdir(experiments_dir)
        if os.path.isdir(os.path.join(experiments_dir, d))
    ]
    axiom_lengths = defaultdict(list)

    for experiment in experiments:
        config_path = os.path.join(experiments_dir, experiment, "config.yaml")
        experiment_dir = os.path.join(log_dir, experiment)
        if os.path.isfile(config_path):
            with open(config_path, "r") as cf:
                config = yaml.safe_load(cf)

        for root, _, files in os.walk(experiment_dir):
            for file in files:
                if file.endswith("_with_abstractions_output.txt"):
                    problem_name = file.replace("_with_abstractions_output.txt", "")
                    proof_path = os.path.join(root, file)
                    # get last non-empty line of very large file efficiently
                    last_line = get_last_nonempty_line(proof_path)
                    if last_line is None or "GaveUp" in last_line:
                        continue
                    with open(proof_path, "r") as pf:
                        proof_text = pf.read()
                    terms = extract_terms_from_proof(proof_text)
                    proof_length = len(terms)
                    axiom_lengths[problem_name].append({"proof_length": proof_length, "config": config, "experiment": experiment})
                   
    # write to file
    output_path = experiments_dir / "axiom_proof_lengths.json"
    with open(output_path, "w") as f:
        json.dump(axiom_lengths, f, indent=2)

def compile_results_by_config(experiments_dir):
    """
    Compile a mapping from config (as a hashable type) to experiment run.
    """
    experiments = [
        d for d in os.listdir(experiments_dir)
        if os.path.isdir(os.path.join(experiments_dir, d))
    ]
    abstractions_by_config = defaultdict(dict)

    for experiment in experiments:
        summary_path = os.path.join(experiments_dir, experiment, "summary.json")
        config_path = os.path.join(experiments_dir, experiment, "config.yaml")
        if not (os.path.isfile(summary_path) and os.path.isfile(config_path)):
            continue
        # Load the data
        with open(summary_path, "r") as f:
            data = json.load(f)

        # Load the config (if exists)
        try:
            with open(config_path, "r") as cf:
                config = yaml.safe_load(cf)
        except Exception:
            config = None

        for entry in data:
            if "abstractions" in entry and config is not None:
                # Use the entire config as a key by converting it to a string that can be serialized
                # Use a JSON string with sorted keys as a hashable and serializable key
                config_key = json.dumps(config, sort_keys=True)
                abstractions_by_config[config_key][entry["problem"]] = entry
        
    return abstractions_by_config
    

def get_base_times(experiments_dir):
    # open base_times.json and return the dict
    base_times_path = os.path.join(experiments_dir, "base_times.json")
    if not os.path.isfile(base_times_path):
        raise FileNotFoundError(f"Base times file not found: {base_times_path}")
    with open(base_times_path, "r") as f:
        base_times = json.load(f)
    return base_times


def get_good_abstractions(experiments_dir, goodness_threshold=0.5):
    time_successes_per_problem = defaultdict(list)
    step_successes_per_problem = defaultdict(list)
    experiments = os.listdir(experiments_dir)
    for experiment in experiments:
        summary_path = os.path.join(experiments_dir, experiment, "summary.json")
        if not os.path.isfile(summary_path):
            continue
        with open(summary_path, "r") as f:
            results = json.load(f)

        for entry in results:
            problem = entry.get("problem", "")
            base_time = entry.get("base_time", 0)
            abs_time = entry.get("abs_time", 0)
            base_steps = entry.get("base_steps", 0)
            abs_steps = entry.get("abs_steps", 0)
            if "COL" in problem:
                continue
            if base_time and abs_time:
                speed_up = base_time / abs_time
                if 1 / speed_up <= goodness_threshold:
                    time_successes_per_problem[problem].append(
                        (entry, speed_up)
                    )
            if base_steps and abs_steps:
                step_speed_up = base_steps / abs_steps
                if 1 / step_speed_up <= goodness_threshold:
                    step_successes_per_problem[problem].append(
                        (entry, step_speed_up)
                    )

    m = {
        "time_successes": time_successes_per_problem,
        "step_successes": step_successes_per_problem,
    }
    return m

def get_good_hint_experiments(theory=None, goodness_threshold=0.5, experiments_dir=None, stage=None):
    experiments = os.listdir(experiments_dir)
    good_hints = defaultdict(list)
    for experiment in experiments:
        if theory and theory not in experiment:
            continue
        if stage and stage not in experiment:
            continue
        summary_path = os.path.join(experiments_dir, experiment, "summary.json")
        if not os.path.isfile(summary_path):
            continue
        with open(summary_path, "r") as f:
            results = json.load(f)
        config_path = os.path.join(experiments_dir, experiment, "config.yaml")
        with open(config_path, "r") as cf:
            config = yaml.safe_load(cf)

        for entry in results:
            problem = entry.get("problem", "")
            base_time = entry.get("mean_base_user_time", None)
            hints_time = entry.get("hints_time_user", None)
            if isinstance(base_time, (int, float)) and isinstance(hints_time, (int, float)):
                if hints_time < goodness_threshold * base_time:
                    good_hints[problem].append(entry)
    return good_hints

def get_good_axiom_experiments(theory=None, goodness_threshold=0.5, experiments_dir=None, stage=None):
    experiments = os.listdir(experiments_dir)
    good_axioms = defaultdict(list)
    for experiment in experiments:
        if theory and theory not in experiment:
            continue
        if stage and stage not in experiment:
            continue
        summary_path = os.path.join(experiments_dir, experiment, "summary.json")
        if not os.path.isfile(summary_path):
            continue
        with open(summary_path, "r") as f:
            results = json.load(f)
        config_path = os.path.join(experiments_dir, experiment, "config.yaml")
        with open(config_path, "r") as cf:
            config = yaml.safe_load(cf)

        for entry in results:
            problem = entry.get("problem", "")
            base_time = entry.get("base_time_user", None)
            abs_time = entry.get("abs_time_user", None)
            if isinstance(base_time, (int, float)) and isinstance(abs_time, (int, float)):
                if abs_time < goodness_threshold * base_time:
                    good_axioms[problem].append(entry)
    return good_axioms

def get_base_timeouts(theory, experiments_dir):
    base_times = get_base_times(experiments_dir)
    tptp_input_dir = Path(project_root) / f"data/TPTP/{theory}_UEQ_UNSAT"
    tptp_files = sorted(tptp_input_dir.glob("*.p"), key=lambda p: p.name)
    timeouts = [str(p.name) for p in tptp_files if p.stem not in base_times.keys()] # base_times contains all and only problems that did not timeout (after 1000s)
    return timeouts


def list_hard_problems():
    base_times = get_base_times(Path(script_dir) / "axiom_abs_11-11")
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

def count_terminating_problems(theory=None, non_flattened=True, flattened=False):
    experiments_dir = Path(script_dir) / "axiom_abs_11-11"
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
    experiments_dir = Path("data/experiments/axiom_abs_11-11")
    # base_times = compile_base_times(experiments_dir)
    # with open(experiments_dir / "base_times.json", "w") as f:
    #     json.dump(base_times, f, indent=2)
    # m = compile_base_output_locations(experiments_dir)
    # json_path = os.path.join(experiments_dir, "base_output_locations.json")
    # with open(json_path, "w") as f:
    #     json.dump(m, f, indent=4)
    # compile_base_proof_lengths(experiments_dir)
    # compile_hint_proof_lengths(Path("data/experiments/hints_17-11"))
    # compile_axiom_proof_lengths(Path("data/experiments/axiom_abs_11-11"))
    # by_config = compile_results_by_config(experiments_dir)

    # output_path = experiments_dir / "by_config.json"
    # with open(output_path, "w") as f:
    #     json.dump(by_config, f, indent=2)
    # print(f"written to {output_path}")
    # s = get_last_nonempty_line("/Users/guya/Projects/Twee/twee_abstractions/src/stitch/sample_proof.out")
    pass