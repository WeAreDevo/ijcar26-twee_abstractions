import argparse
import os
import shlex
import subprocess
import sys
from pathlib import Path

import yaml

project_root = Path(__file__).resolve().parents[3]
sys.path.append(project_root.as_posix())
os.chdir(project_root.as_posix())
from src.stitch.pipeline import workers as worker_module

WORKER_SCRIPT = Path(__file__).resolve().parent / "workers.py"
SUPPORTED_STAGES = {"base", "hints", "hard"}

from dotenv import load_dotenv
load_dotenv()
slurm_mail = os.getenv("SLURM_MAIL", None)
mail_args = []
if slurm_mail:
    mail_args = [f"--mail-user={slurm_mail}", "--mail-type=ALL"]


def _require(cfg, key, stage_name, desc):
    value = cfg.get(key)
    if value is None:
        raise ValueError(f"Stage '{stage_name}' missing required setting '{key}' ({desc})")
    return value


def _collect_config_paths(stage_name, config_dir):
    config_dir = Path(config_dir)
    try:
        config_paths = [str(path.resolve()) for path in sorted(config_dir.glob("*.yaml"))]
    except OSError as exc:
        print(f"Error listing configs for stage {stage_name}: {exc}")
        return []

    if not config_paths:
        print(f"No config files found for stage {stage_name} in {config_dir}. Skipping.")
    return config_paths



def _write_stage_script(stage_name, stage_cfg, config_paths, master_job_id, experimental):
    header_lines = f"""#!/usr/bin/env bash
#SBATCH -A C3SE2026-1-12 -p vera
#SBATCH -J TweeAbstractions
#SBATCH -n 1
#SBATCH --cpus-per-task=64
#SBATCH -t 0-05:00:00
#SBATCH --output=vera_jobs/slurm_%A_%a.out
"""
    input_dir = str(Path(_require(stage_cfg, "input_dir", stage_name, "path to TPTP problems")).resolve())
    output_dir = str(Path(_require(stage_cfg, "output_dir", stage_name, "experiment output directory")).resolve())
    base_dir = ""
    hints_dir = ""
    if stage_name == "hints" or stage_name == "hard":
        base_dir = str(Path(_require(stage_cfg, "base_dir", stage_name, "directory containing base stage results")).resolve())
    if stage_name == "hard":
        hints_dir = str(Path(_require(stage_cfg, "hints_dir", stage_name, "directory containing hints stage results")).resolve())

    config_entries = "\n".join(f"    \"{path}\"" for path in config_paths)
    experimental_flag = "true" if experimental else "false"
    script_dir = project_root / "vera_jobs"
    script_dir.mkdir(parents=True, exist_ok=True)
    script_path = script_dir / f"pipeline_{stage_name}.sh"

    worker_script_path = str(WORKER_SCRIPT.resolve())
    body = f"""
MASTER_JOB_ID="{master_job_id}"
PROJECT_ROOT="{project_root}"
WORKER_SCRIPT="{worker_script_path}"
INPUT_DIR="{input_dir}"
OUTPUT_DIR="{output_dir}"
BASE_DIR="{base_dir}"
HINTS_DIR="{hints_dir}"
EXPERIMENTAL="{experimental_flag}"

CONFIG_FILES=(
{config_entries}
)

TASK_ID=${{SLURM_ARRAY_TASK_ID:-0}}
CONFIG_PATH=${{CONFIG_FILES[$TASK_ID]}}

cd "$PROJECT_ROOT"
source env.sh
PYTHON_BIN="{sys.executable}"

CMD=( "$PYTHON_BIN" "$WORKER_SCRIPT" \
      "--stage" "{stage_name}" \
      "--config" "$CONFIG_PATH" \
      "--stage-input-dir" "$INPUT_DIR" \
      "--stage-output-dir" "$OUTPUT_DIR" \
      "--job_id" "$MASTER_JOB_ID" )

if [ -n "$BASE_DIR" ]; then
    CMD+=( "--stage-base-dir" "$BASE_DIR" )
fi

if [ -n "$HINTS_DIR" ]; then
    CMD+=( "--stage-hints-dir" "$HINTS_DIR" )
fi

if [ "$EXPERIMENTAL" = "true" ]; then
    CMD+=( "--experimental" )
fi
echo "Running command: ${{CMD[*]}}"
"${{CMD[@]}}"
"""

    script_contents = header_lines + "\n\n" + body + "\n"
    script_path.write_text(script_contents)
    script_path.chmod(0o755)
    return script_path


def _run_stage_serial(stage_name, stage_cfg, config_paths, master_job_id, experimental, debug):
    input_dir = str(Path(_require(stage_cfg, "input_dir", stage_name, "path to TPTP problems")).resolve())
    output_dir = str(Path(_require(stage_cfg, "output_dir", stage_name, "experiment output directory")).resolve())
    base_dir = None
    if stage_name == "hints" or stage_name == "hard":
        base_dir = str(Path(_require(stage_cfg, "base_dir", stage_name, "directory containing base stage results")).resolve())
    if stage_name == "hard":
        hints_dir = str(Path(_require(stage_cfg, "hints_dir", stage_name, "directory containing hints stage results")).resolve())

    for idx, config_path in enumerate(config_paths):
        worker_job_id = f"{master_job_id}_serial_{idx}"
        print(f"[SERIAL] Running {stage_name} config {config_path} as {worker_job_id}")
        worker_module.run_stage_from_config(
            stage=stage_name,
            config_path=config_path,
            stage_input_dir=input_dir,
            stage_output_dir=output_dir,
            job_id=worker_job_id,
            debug=debug,
            experimental=experimental,
            stage_base_dir=base_dir,
            stage_hints_dir=hints_dir,
        )


def _submit_array_job(stage_name, stage_cfg, config_paths, master_job_id, experimental):
    script_path = _write_stage_script(stage_name, stage_cfg, config_paths, master_job_id, experimental)
    array_range = f"0-{len(config_paths)-1}"
    cmd = ["sbatch", *mail_args, f"--array={array_range}", str(script_path)]
    print("Submitting stage", stage_name, "using script", script_path)
    result = subprocess.run(cmd, capture_output=True, text=True, check=False)
    if result.returncode != 0:
        print(result.stdout)
        print(result.stderr)
        raise RuntimeError(f"sbatch submission failed for stage {stage_name}")
    print(result.stdout.strip())


def run_stages(stage_configs, master_job_id, debug=False, experimental=False, serial=False):
    # Running multiple stages will not work when submitting array jobs. For now, require that stages be run separately if using array jobs.
    stages = stage_configs.get("stages", {})
    if not serial and len(stages) > 1:
        print("Multiple stages detected in config. Running with array jobs is not supported for multiple stages. Please run each stage separately or use --serial flag.")
        return
    ordered_names = [name for name in ["base", "hints", "hard"] if name in stages]
    ordered_names.extend([name for name in stages.keys() if name not in ordered_names])
    for stage_name in ordered_names:
        if stage_name not in SUPPORTED_STAGES:
            print(f"Stage '{stage_name}' not yet supported by pipeline. Skipping.")
            continue
        cfg = stages[stage_name]
        config_dir = cfg.get("configs_dir")
        if not config_dir:
            print(f"Stage {stage_name} missing configs_dir; skipping.")
            continue
        config_paths = _collect_config_paths(stage_name, config_dir)
        if not config_paths:
            continue
        master_job_id = f"{master_job_id}_{stage_name}"
        if serial or debug:
            _run_stage_serial(stage_name, cfg, config_paths, master_job_id, experimental, debug)
            continue
        _submit_array_job(stage_name, cfg, config_paths, master_job_id, experimental)


def parse_args():
    parser = argparse.ArgumentParser(description="")
    parser.add_argument(
        "--config",
        type=str,
        required=True,
        help="Path to the Stages YAML config file (relative to project root or absolute)."
    )
    parser.add_argument(
        "--debug",
        action="store_true",
        help="If present, runs in debug mode (with only 1 worker and 1 child process for the worker)."
    )
    parser.add_argument(
        "--job_id",
        type=str,
        required=False,
        default=None,
        help="Master job ID for this pipeline run."
    )
    parser.add_argument(
        "--experimental",
        action="store_true",
        help="If present, performs experimental features."
    )
    parser.add_argument(
        "--serial",
        action="store_true",
        help="Run each worker config serially instead of submitting Slurm array jobs."
    )
    return parser.parse_args()

if __name__ == "__main__":
    args = parse_args()
    master_job_id = args.job_id
    if args.job_id is None:
        master_job_id = args.config.split('/')[-1].rsplit('.', 1)[0]

    with open(args.config, "r") as f:
        stage_configs = yaml.safe_load(f)
    run_stages(
        stage_configs,
        master_job_id,
        debug=args.debug,
        experimental=args.experimental,
        serial=args.serial,
    )