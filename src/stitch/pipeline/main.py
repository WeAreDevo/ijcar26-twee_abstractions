"""Prepare reviewable Slurm scripts for the current container-backed worker.

This entry point only writes scripts. Run the generated submit.sh explicitly
when ready to submit; stages are chained with Slurm afterok dependencies.
"""
import argparse
import shlex
from pathlib import Path

import yaml

PROJECT_ROOT = Path(__file__).resolve().parents[3]
STAGES = ("base", "local_abs", "domain_abs", "partial_abs")


def resolve_path(value):
    path = Path(value)
    return path.resolve() if path.is_absolute() else (PROJECT_ROOT / path).resolve()


def stage_tasks(stage, cfg, theories):
    if "config" in cfg:
        configs = [resolve_path(cfg["config"])]
    else:
        configs = sorted(resolve_path(cfg["configs_dir"]).glob("*.yaml"))
    if not configs:
        raise ValueError(f"No configs for {stage}")
    tasks = []
    for theory in theories:
        for config in configs:
            if not config.is_file():
                raise ValueError(f"Missing config: {config}")
            task = {"stage_config": str(config)}
            required = ["input_dir", "output_dir"]
            if stage in ("local_abs", "domain_abs"):
                required.append("base_dir")
            if stage == "domain_abs":
                required.append("local_abs_dir")
            for key in required:
                task[key] = str(resolve_path(cfg[key].format(theory=theory, config=config.stem)))
            if not any(Path(task["input_dir"]).glob("*.p")):
                raise ValueError(f"No TPTP inputs in {task['input_dir']}")
            task["label"] = f"{stage}_{theory}_{config.stem}"
            tasks.append(task)
    # The base worker compiles an index after each task. Sharing an output
    # directory between concurrent tasks would race on those index files.
    if len({t["output_dir"] for t in tasks}) != len(tasks):
        raise ValueError(f"{stage}: use {{theory}}/{{config}} for distinct task output directories")
    return tasks


def write_stage_script(stage, tasks, settings, script_dir, job_id, environment):
    q = shlex.quote
    cpus = int(settings.get("cpus_per_task", 64))
    if cpus < 1:
        raise ValueError("cpus_per_task must be positive")
    lines = [
        "#!/usr/bin/env bash",
        f"#SBATCH --account={settings['account']}",
        f"#SBATCH --partition={settings.get('partition', 'vera')}",
        f"#SBATCH --job-name={job_id}_{stage}",
        "#SBATCH --ntasks=1",
        f"#SBATCH --cpus-per-task={cpus}",
        f"#SBATCH --time={settings.get('time', '0-05:00:00')}",
        f"#SBATCH --array=0-{len(tasks) - 1}",
        f"#SBATCH --output={script_dir}/slurm_%x_%A_%a.out",
        "set -euo pipefail",
        f"cd {q(str(PROJECT_ROOT))}",
    ]
    for key, value in environment.items():
        if key not in {"TWEE_PATH", "TPTP_ROOT", "LOG_DIR", "CONTAINER_IMAGE", "RAYON_NUM_THREADS", "TWITCH_MAX_WORKERS"}:
            raise ValueError(f"Unsupported run environment setting: {key}")
        lines.append(f"export {key}={q(str(value))}")
    lines += ['export SLURM_CPUS_PER_TASK="${SLURM_CPUS_PER_TASK:?Submit this script using sbatch}"',
              'case "${SLURM_ARRAY_TASK_ID:?Submit this script as a Slurm array}" in']
    for index, task in enumerate(tasks):
        command = ["bash", "containers/run.sh", "twitch", "--stage", stage]
        for key, value in task.items():
            if key != "label":
                command.extend([f"--{key}", value])
        # Include stage and task identity in LOG_DIR run names, independently
        # of the output directory used for the lightweight summaries.
        label = q(f"{job_id}_{task['label']}")
        lines += [f"  {index})",
                  f"    exec {shlex.join(command)} --job_id {label}_\"${{SLURM_ARRAY_JOB_ID}}_${{SLURM_ARRAY_TASK_ID}}\"",
                  "    ;;"]
    lines += ['  *) echo "Invalid array task: $SLURM_ARRAY_TASK_ID" >&2; exit 2 ;;', "esac", ""]
    path = script_dir / f"pipeline_{stage}.sh"
    path.write_text("\n".join(lines))
    path.chmod(0o755)
    return path


def prepare_pipeline(config, script_dir, job_id):
    stages = config["stages"]
    unknown = set(stages) - set(STAGES)
    if unknown:
        raise ValueError(f"Unsupported stages: {sorted(unknown)}")
    if not stages:
        raise ValueError("No stages configured")
    theories = config.get("theories", [""])
    tasks = {stage: stage_tasks(stage, stages[stage], theories) for stage in STAGES if stage in stages}
    if "base" in tasks:
        base_dirs = {task["output_dir"] for task in tasks["base"]}
        for stage in ("local_abs", "domain_abs"):
            if stage in tasks and any(task["base_dir"] not in base_dirs for task in tasks[stage]):
                raise ValueError(f"{stage} base_dir must match a prepared base output_dir")
    script_dir = resolve_path(script_dir)
    script_dir.mkdir(parents=True, exist_ok=True)
    scripts = [write_stage_script(stage, entries, config["slurm"], script_dir, job_id,
                                  config.get("environment", {})) for stage, entries in tasks.items()]
    lines = ["#!/usr/bin/env bash", "# Explicit submission step: review pipeline_*.sh before running this file.",
             "set -euo pipefail", 'dependency=()', ""]
    for script in scripts:
        lines += [f'job_id=$(sbatch --parsable "${{dependency[@]}}" {shlex.quote(str(script))})',
                  'job_id="${job_id%%;*}"',
                  f'echo "Submitted {script.stem}: $job_id"',
                  'dependency=("--dependency=afterok:$job_id")', ""]
    submit = script_dir / "submit.sh"
    submit.write_text("\n".join(lines))
    submit.chmod(0o755)
    return scripts + [submit]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--config", required=True, help="Pipeline YAML, relative to checkout or absolute")
    parser.add_argument("--scripts_dir", default="vera_jobs", help="Where to write scripts (no submission)")
    parser.add_argument("--job_id", help="Run label; defaults to pipeline config filename")
    args = parser.parse_args()
    config_path = resolve_path(args.config)
    config = yaml.safe_load(config_path.read_text())
    for path in prepare_pipeline(config, args.scripts_dir, args.job_id or config_path.stem):
        print(path)
    print("Prepared scripts only. No jobs submitted.")


if __name__ == "__main__":
    main()
