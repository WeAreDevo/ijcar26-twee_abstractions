from functools import reduce
import re
import sys
from pathlib import Path
import yaml
from datetime import datetime
import os
import concurrent.futures
project_root = Path(__file__).resolve().parents[3]
sys.path.append(project_root.as_posix())
os.chdir(project_root.as_posix())

from src.stitch.Abstractions import Stitch_Abstractions
from src.utils import as_cnf_axiom, as_cnf_hint, extract_strategy_1, extract_terms, filter_out_higer_order_abstractions, filter_out_uninteresting, normalize_fof_term, run_twee_on_file, expand_abstractions, validate_abstraction
from stitch.domain_abstractions import domain_hints_across_experiments, domain_hints_for_problem, domain_hints_from_hints_stage
from data.experiments.util import compile_base_output_locations, compile_base_times, get_base_timeouts, get_base_times_with_flag
import json
import argparse

from dotenv import load_dotenv
import random
load_dotenv()

base_times = {}
hints_dir = None
base_dir = None

def init_worker(base_data, hints_data, base_directory):
    global base_times
    base_times = base_data
    global hints_dir
    hints_dir = hints_data
    global base_dir
    base_dir = base_directory


def base_stage(args):
    tptp_file, configs, log_dir = args
    result_dict = {}
    result_dict["problem"] = tptp_file.stem
    try:
        print(f"Processing file: {tptp_file}")
        print(f"Running Twee on {tptp_file}")
        
        twee_result = run_twee_on_file(tptp_file, timeout=configs["twee"].get("timeout", 30), flags=configs["twee"].get("flags", ""))
        result_dict["base_status"] = twee_result["status"]
        result_dict["error"] = twee_result["error"]
        
        if twee_result["status"] != "success":
            print(f"Twee failed for {tptp_file}: {twee_result['error']}")
            return result_dict
        output = twee_result["output"]
        twee_output_path = log_dir / f"{tptp_file.stem}_base_output.txt"
        with open(twee_output_path, "w") as f:
            f.write(output)
        # get the last line of output that is not empty
        last_line = ""
        for line in reversed(output.splitlines()):
            if line.strip():
                last_line = line.strip()
                break
        if "GaveUp" in last_line:
            print(f"Twee gave up for {tptp_file}")
            result_dict["base_status"] = "timeout"
            return result_dict

        result_dict["base_time_user"] = twee_result["user_cpu"]
        result_dict["base_time_sys"] = twee_result["system_cpu"]
        result_dict["base_time"] = twee_result["total_cpu"]
        return result_dict
    except Exception as e:
        print(f"Error processing {tptp_file}: {e}")
        result_dict["status"] = "error"
        result_dict["error"] = str(e)
        return result_dict
    

def local_abs_stage(args):
    tptp_file, configs, log_dir = args
    result_dict = {}
    problem = tptp_file.stem
    try:
        result_dict["problem"] = problem
        if "--flatten-goal" in configs["twee"].get("flags", ""):
            base_times_f = get_base_times_with_flag(base_times, "--flatten-goal")
        elif "--no-flatten-goal" in configs["twee"].get("flags", ""):
            base_times_f = get_base_times_with_flag(base_times, "--no-flatten-goal")
        
        result_dict["problem"] = problem
        base_times_for_problem = base_times_f.get(problem, [])
        if not base_times_for_problem:
            result_dict["status"] = "base timeout"
            return result_dict
        avg_base_time = sum(entry["user_time"] for entry in base_times_for_problem) / len(base_times_for_problem)
        min_base_time_entry = min(base_times_for_problem, key=lambda x: x["user_time"])
        result_dict["mean_base_user_time"] = avg_base_time
        result_dict["min_base_user_time"] = min_base_time_entry["user_time"]
        result_dict["min_base_dir"] = min_base_time_entry["experiment"]
        base_dir = Path(os.getenv("LOG_DIR")) / min_base_time_entry["experiment"]
        base_output_path = base_dir / f"{problem}_base_output.txt"
        with open(base_output_path, "r") as f:
            base_output = f.read()

        extracted_terms = extract_terms(base_output, configs.get("extraction", None))
        abstractions = Stitch_Abstractions(extracted_terms, configs["stitch"].get("iterations", 10), configs["stitch"].get("max_arity", 10)).fo_abstractions
        del extracted_terms
        del base_output
        expanded_abstractions = expand_abstractions(filter_out_uninteresting(filter_out_higer_order_abstractions(abstractions)))
        if not expanded_abstractions:
            result_dict["status"] = "no valid abstractions produced by Stitch"
            return result_dict

        result_dict["abstractions"] = abstractions
        result_dict["expanded_abstractions"] = expanded_abstractions
        hints = [abstraction.split('=', 1)[1].strip() for abstraction in expanded_abstractions]
        print(f"Adding abstraction hints to {tptp_file}")
        cnf_hints = "\n".join([as_cnf_hint(hint, id) for id, hint in enumerate(hints, start=1)])
        with open(tptp_file, "r") as orig_f:
            orig_content = orig_f.read()
        tptp_with_hints = log_dir / f"{tptp_file.stem}_with_hints.p"
        with open(tptp_with_hints, "x") as out_f:
            out_f.write(orig_content)
            out_f.write("\n\n")
            out_f.write(cnf_hints)
        print(f"Running Twee on {tptp_with_hints}")
        
        twee_result = run_twee_on_file(tptp_with_hints, timeout=configs["twee"].get("timeout", 30), flags=configs["twee"].get("flags", ""))
        result_dict["hints_status"] = twee_result["status"]
        
        if twee_result["status"] != "success":
            print(f"Twee failed for {tptp_with_hints}: {twee_result['error']}")
            result_dict["error"] = twee_result["error"]
            return result_dict
        
        result_dict["hints_time_user"] = twee_result["user_cpu"]
        result_dict["hints_time_sys"] = twee_result["system_cpu"]
        result_dict["hints_time"] = twee_result["total_cpu"]
        twee_with_hints_output_path = log_dir / f"{tptp_file.stem}_with_hints_output.txt"
        with open(twee_with_hints_output_path, "w") as f:
            f.write(twee_result["output"])
        return result_dict
    
    except Exception as e:
        print(f"Error processing {tptp_file}: {e}")
        result_dict["status"] = "error"
        result_dict["error"] = str(e)
        return result_dict
    
def domain_abs_stage(args):
    """
    Runs Twee on a problem by using domain abstractions gathered according to the config.
    args: (problem, configs, problem_dir, log_dir)
    """
    tptp_file, configs, log_dir = args
    problem = tptp_file.stem
    result_dict = {"problem": problem}
    try:
        # Collect hints
        ################################
        hints = set()
        if configs["abstractions"]["use_domain_abstractions"]:
            if configs["abstractions"]["domain_abstractions_source"] == "theory":
                domain_hints = domain_hints_from_hints_stage(configs["abstractions"]["goodness_threshold"], hints_dir)
                
            domain_hints = [abs for abs in domain_hints if validate_abstraction(abs, tptp_file)]
            # result_dict["domain_hints"] = domain_hints
            hints.update(domain_hints)
        if configs["abstractions"]["compress_domain_abstractions"] and hints:
            abstractions = Stitch_Abstractions(list(hints), configs["stitch"].get("iterations", 10), configs["stitch"].get("max_arity", 10)).fo_abstractions
            expanded_abstractions = expand_abstractions(filter_out_uninteresting(filter_out_higer_order_abstractions(abstractions)))
            hints = set([abstraction.split('=', 1)[1].strip() for abstraction in expanded_abstractions])
        if configs["abstractions"]["use_partial_proof_lemmas"]:
             # load base_dir/base_output_locations.json
            with open(Path(f"{base_dir}/base_output_locations.json"), "r") as f:
                base_outputs = json.load(f)
            if problem in base_outputs:
                base_output_entry = [e for e in base_outputs[problem] if ("--flatten-goal" in e["config"]["twee"]["flags"]) == ("--flatten-goal" in configs["twee"].get("flags", ""))][0]
                base_output_path = Path(os.getenv("LOG_DIR")) / base_output_entry['output_file']
                with open(base_output_path, "r") as f:
                    partial_proof_text = f.read()
            else:
                result_dict["error"] = f"No base output {problem} found for partial proof lemmas."
                return result_dict
            interesting_lemmas = extract_strategy_1(partial_proof_text)[:configs["abstractions"]["lemma_abstraction"].get("topk", 20)]
            del partial_proof_text
            # TODO: 
            extracted_terms = reduce(lambda acc, lemma: acc + lemma[1]['proof_terms'], interesting_lemmas, [])
            if configs["abstractions"]["lemma_abstraction"].get("use_all_lemma_peak_terms", False):
                peak_terms = [normalize_fof_term(t) for t in extracted_terms if "peak" in t]
                peak_terms = list(set(peak_terms))
                hints.update(peak_terms)
            
            # normalize terms
            extracted_terms_norm = [normalize_fof_term(t) for t in extracted_terms]
            # remove duplicates
            extracted_terms_norm = list(set(extracted_terms_norm))
            # Generate abstractions from the extracted terms
            partial_proof_abstractions = Stitch_Abstractions(extracted_terms_norm, configs["abstractions"]["lemma_abstraction"].get("stitch_iterations", 10), configs["abstractions"]["lemma_abstraction"].get("max_arity", 2)).fo_abstractions
            expanded_partial_proof_abstractions = expand_abstractions(filter_out_uninteresting(filter_out_higer_order_abstractions(partial_proof_abstractions)))
            # if not expanded_partial_proof_abstractions:
            #     result_dict["status"] = "no valid partial proof abstractions"
            #     return result_dict

            result_dict["expanded_partial_proof_abstractions"] = expanded_partial_proof_abstractions
            to_hints = [normalize_fof_term(abstraction.split('=', 1)[1].strip()) for abstraction in expanded_partial_proof_abstractions]
            hints.update(to_hints)
        ###################################
        if not hints:
            result_dict["error"] = "No hints collected."
            return result_dict
        result_dict["final_hints"] = list(hints)
        # Prepare hints for tptp input
        cnf_hints = "\n".join([as_cnf_hint(hint, id) for id, hint in enumerate(hints, start=1)])
        # Read original file
        with open(tptp_file, "r") as orig_f:
            orig_content = orig_f.read()
        # Write new file with abstraction
        tptp_with_hint = log_dir / f"{tptp_file.stem}_with_hints.p"
        with open(tptp_with_hint, "w") as out_f:
            out_f.write(orig_content)
            out_f.write("\n\n")
            out_f.write(cnf_hints)

        # Run Twee and log time
        print(f"Running Twee on {tptp_with_hint}")
        twee_result = run_twee_on_file(tptp_with_hint, timeout=configs["twee"].get("timeout", 30), flags=configs["twee"].get("flags", ""))
        result_dict["status"] = twee_result["status"]
        
        if twee_result["status"] != "success":
            print(f"Twee failed for {tptp_file}: {twee_result['error']}")
            result_dict["error"] = twee_result["error"]
            return result_dict
        result_dict["hint_time_user"] = twee_result["user_cpu"]
        result_dict["hint_time_sys"] = twee_result["system_cpu"]
        result_dict["hint_time"] = twee_result["total_cpu"]
        # twee_with_abs_output_path = log_dir / f"{tptp_file.stem}_with_hint_output.txt"
        # with open(twee_with_abs_output_path, "w") as f:
        #     f.write(twee_result["output"])
        return result_dict
    except Exception as e:
        result_dict["error"] = str(e)
        return result_dict


def partial_abs_stage(args):
    """
    Timeslice Twee on a problem by using abstractions gathered by partial proof
    """
    tptp_file, configs, log_dir = args
    problem = tptp_file.stem
    result_dict = {"problem": problem}
    try:
        ###############################
        # First run Twee for timeslice without hints to get partial proof
        ###############################
        timeslice_timeout = configs.get("timeslice", 50) + 20
        twee_result = run_twee_on_file(tptp_file, timeout=timeslice_timeout, flags=configs["twee"].get("flags", ""))
        result_dict["base_status"] = twee_result["status"]
        result_dict["error"] = twee_result["error"]
        
        if twee_result["status"] != "success":
            print(f"Twee failed for {tptp_file}: {twee_result['error']}")
            return result_dict
        output = twee_result["output"]
        # get the last line of output that is not empty
        last_line = ""
        for line in reversed(output.splitlines()):
            if line.strip():
                last_line = line.strip()
                break
        if "Unsatisfiable" in last_line:
            result_dict["base_time_user"] = twee_result["user_cpu"]
            return result_dict

        base_output_path = log_dir / f"{tptp_file.stem}_base_output.txt"
        with open(base_output_path, "w") as f:
            f.write(output)
        ################################
        # Collect abstractions
        ################################
        hints = set()
        # load data/experiments/base_output_locations.json
        
        partial_proof_text = output
        interesting_lemmas = extract_strategy_1(partial_proof_text)[:configs["abstractions"]["lemma_abstraction"].get("topk", 50)]
        extracted_terms = reduce(lambda acc, lemma: acc + lemma[1]['proof_terms'], interesting_lemmas, [])
        # normalize terms
        extracted_terms_norm = [normalize_fof_term(t) for t in extracted_terms]
        # remove duplicates
        extracted_terms_norm = list(set(extracted_terms_norm))
        # Generate abstractions from the extracted terms
        partial_proof_abstractions = Stitch_Abstractions(extracted_terms_norm, configs["abstractions"]["lemma_abstraction"].get("stitch_iterations", 20), configs["abstractions"]["lemma_abstraction"].get("max_arity", 5)).fo_abstractions
        expanded_partial_proof_abstractions = expand_abstractions(filter_out_uninteresting(filter_out_higer_order_abstractions(partial_proof_abstractions)))
        if not expanded_partial_proof_abstractions:
            result_dict["status"] = "no valid partial proof abstractions"
            return result_dict

        result_dict["expanded_partial_proof_abstractions"] = expanded_partial_proof_abstractions
        to_hints = [normalize_fof_term(abstraction.split('=', 1)[1].strip()) for abstraction in expanded_partial_proof_abstractions]
        hints.update(to_hints)
        ###################################
        if not hints:
            result_dict["error"] = "No hints collected."
            return result_dict
        result_dict["final_hints"] = list(hints)
        # Prepare hints for tptp input
        cnf_hints = "\n".join([as_cnf_hint(hint, id) for id, hint in enumerate(hints, start=1)])
        # Read original file
        with open(tptp_file, "r") as orig_f:
            orig_content = orig_f.read()
        # Write new file with abstraction
        tptp_with_hint = log_dir / f"{tptp_file.stem}_with_hints.p"
        with open(tptp_with_hint, "w") as out_f:
            out_f.write(orig_content)
            out_f.write("\n\n")
            out_f.write(cnf_hints)

        # Run Twee and log time
        print(f"Running Twee on {tptp_with_hint}")
        second_slice = configs["twee"].get("timeout", 1000) - configs.get("timeslice", 150)
        twee_result = run_twee_on_file(tptp_with_hint, timeout=second_slice, flags=configs["hints_twee"].get("flags", ""))
        result_dict["status"] = twee_result["status"]
        
        if twee_result["status"] != "success":
            print(f"Twee failed for {tptp_file}: {twee_result['error']}")
            result_dict["error"] = twee_result["error"]
            return result_dict
        result_dict["hint_time_user"] = twee_result["user_cpu"]
        # twee_with_abs_output_path = log_dir / f"{tptp_file.stem}_with_hint_output.txt"
        # with open(twee_with_abs_output_path, "w") as f:
        #     f.write(twee_result["output"])
        return result_dict
    except Exception as e:
        result_dict["error"] = str(e)
        return result_dict
    
def spawn_processes(process, config, output_dir, input_file_paths, job_id, debug=False, experimental=False, initializer=None, initargs=()):

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    dirname = f"{timestamp}_{job_id}"
    experiment_dir = output_dir / dirname
    experiment_dir.mkdir(parents=True, exist_ok=False)

    log_dir = Path(os.getenv("LOG_DIR")) / dirname
    log_dir.mkdir(parents=True, exist_ok=False)

    config_output_paths = [experiment_dir / "config.yaml" , log_dir / "config.yaml"]
    for config_output_path in config_output_paths:
        with open(config_output_path, "w") as f:
            yaml.dump(config, f)
    
    summary_data = []
    summary_output_paths = [experiment_dir / "summary.json", log_dir / "summary.json"]
    tptp_files = input_file_paths
    print(f"Experiment output at: {experiment_dir}\n" + "#" * 50)
    args_list = [(tptp_file, config, log_dir) for tptp_file in tptp_files]
    max_workeers = 1 if debug else os.cpu_count() - 2
    print(max_workeers)
    with concurrent.futures.ProcessPoolExecutor(max_workers=max_workeers, initializer=initializer, initargs=initargs) as executor:
        for result_dict in executor.map(process, args_list):
            summary_data.append(result_dict)

    for summary_output_path in summary_output_paths:
        with open(summary_output_path, "w") as f:
            json.dump(summary_data, f, indent=4)

def _run_base_stage(input_dir, output_dir, experiment_config, job_id, debug, experimental):
    input_path = Path(input_dir)
    output_path = Path(output_dir)
    input_files = sorted(input_path.glob("*.p"))
    if not input_files:
        print(f"Warning: no input problems found in {input_path}")
    spawn_processes(base_stage, experiment_config, output_path, input_files, job_id=job_id, debug=debug, experimental=experimental)

    # After running base stage, compile base times to output_dir/base_times.json for use in hints stage
    base_times_new = compile_base_times(output_path, id="base")
    with open(output_path / "base_times.json", "w") as f:
        json.dump(base_times_new, f, indent=2)
    # Compile base output locations
    base_output_locations = compile_base_output_locations(output_path)
    json_path = os.path.join(output_path, "base_output_locations.json")
    with open(json_path, "w") as f:
        json.dump(base_output_locations, f, indent=2)


def _run_partial_abs_stage(input_dir, output_dir, experiment_config, job_id, debug, experimental):
    input_path = Path(input_dir)
    output_path = Path(output_dir)
    input_files = sorted(input_path.glob("*.p"))
    if not input_files:
        print(f"Warning: no input problems found in {input_path}")
    spawn_processes(partial_abs_stage, experiment_config, output_path, input_files, job_id=job_id, debug=debug, experimental=experimental)

    # After running base stage, compile base times to output_dir/base_times.json for use in hints stage
    base_times_new = compile_base_times(output_path, id="base")
    with open(output_path / "base_times.json", "w") as f:
        json.dump(base_times_new, f, indent=2)
    # Compile base output locations
    base_output_locations = compile_base_output_locations(output_path)
    json_path = os.path.join(output_path, "base_output_locations.json")
    with open(json_path, "w") as f:
        json.dump(base_output_locations, f, indent=2)


def _run_local_abs_stage(input_dir, output_dir, base_dir, experiment_config, job_id, debug, experimental):
    base_times_path = Path(base_dir) / "base_times.json"
    if not base_times_path.exists():
        raise SystemExit(f"Missing base_times.json at {base_times_path}")
    with open(base_times_path, "r") as f:
        loaded_base_times = json.load(f)
    input_files = sorted(Path(input_dir).glob("*.p"))
    spawn_processes(
        local_abs_stage,
        experiment_config,
        Path(output_dir),
        input_files,
        job_id=job_id,
        debug=debug,
        experimental=experimental,
        initializer=init_worker,
        initargs=(loaded_base_times, None, None,)
    )


def _run_domain_abs_stage(input_dir, output_dir, base_dir, hints_dir, experiment_config, job_id, debug, experimental):
    base_times_path = Path(base_dir) / "base_times.json"
    if not base_times_path.exists():
        raise SystemExit(f"Missing base_times.json at {base_times_path}")
    with open(base_times_path, "r") as f:
        loaded_base_times = json.load(f)
    input_files = sorted(Path(input_dir).glob("*.p"))
    if experimental:
        # only try on unsolved problems from base stage
        unsolved_problems = [input_file for input_file in input_files if input_file.stem not in loaded_base_times]
        input_files = unsolved_problems
    if debug:
        input_files = [in_file for in_file in input_files if in_file.stem in 
                       [
                           "2_goal_2"
                       ]
                       ]

    spawn_processes(
        domain_abs_stage,
        experiment_config,
        Path(output_dir),
        input_files,
        job_id=job_id,
        debug=debug,
        experimental=experimental,
        initializer=init_worker,
        initargs=(loaded_base_times, hints_dir, base_dir,)
    )


def parse_args():
    parser = argparse.ArgumentParser(description="")
    parser.add_argument(
        "--stage",
        type=str,
        required=True,
        help="Stage to run (base, local_abs, domain_abs, partial_abs).",
        choices=["base", "local_abs", "domain_abs", "partial_abs"]
    )
    parser.add_argument(
        "--stage_config",
        type=str,
        required=True,
        help="Path to a single experiment config YAML file."
    )
    parser.add_argument(
        "--input_dir",
        type=str,
        required=True,
        help="Directory containing input TPTP problems."
    )
    parser.add_argument(
        "--output_dir",
        type=str,
        required=True,
        help="Directory where result summaries will be stored."
    )
    parser.add_argument(
        "--base_dir",
        type=str,
        required=False,
        default=None,
        help="Directory where base stage results are stored."
    )
    parser.add_argument(
        "--local_abs_dir",
        type=str,
        required=False,
        default=None,
        help="Directory where local abstraction stage results are stored."
    )
    parser.add_argument(
        "--debug",
        action="store_true",
        help="If present, runs in debug mode (with only 1 child process for the worker)."
    )
    parser.add_argument(
        "--job_id",
        type=str,
        required=False,
        default="local",
        help="Job ID for this run (defaults to local)."
    )
    parser.add_argument(
        "--experimental",
        action="store_true",
        help="If present, performs experimental features."
    )
    return parser.parse_args()

def run_stage_with_config(stage, config_path, input_dir, output_dir, job_id, debug=False, experimental=False, base_dir=None, local_abs_dir=None):
    config_path = Path(config_path)
    if not config_path.exists():
        raise FileNotFoundError(f"Config file {config_path} does not exist")

    with open(config_path, "r") as f:
        experiment_config = yaml.safe_load(f)

    job_id_full = f"{job_id}_{config_path.stem}"

    if stage == "base":
        _run_base_stage(input_dir, output_dir, experiment_config, job_id_full, debug, experimental)
    elif stage == "local_abs":
        if not base_dir:
            raise SystemExit(f"--base_dir is required for {stage} stage")
        _run_local_abs_stage(input_dir, output_dir, base_dir, experiment_config, job_id_full, debug, experimental)
    elif stage == "domain_abs":
        if not base_dir:
            raise SystemExit(f"--base_dir is required for {stage} stage")
        if not local_abs_dir:
            raise SystemExit(f"--local_abs_dir is required for {stage} stage")
        _run_domain_abs_stage(input_dir, output_dir, base_dir, local_abs_dir, experiment_config, job_id_full, debug, experimental)
    elif stage == "partial_abs":
        _run_partial_abs_stage(input_dir, output_dir, base_dir, local_abs_dir, experiment_config, job_id_full, debug, experimental)
    else:
        raise SystemExit(f"Stage '{stage}' not yet implemented in worker")


def main():
    args = parse_args()
    run_stage_with_config(
        stage=args.stage,
        config_path=args.stage_config,
        input_dir=args.input_dir,
        output_dir=args.output_dir,
        base_dir=args.base_dir,
        local_abs_dir=args.local_abs_dir,
        job_id=args.job_id,
        debug=args.debug,
        experimental=args.experimental
    )


if __name__ == "__main__":
    main()