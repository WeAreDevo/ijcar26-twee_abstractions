#!/usr/bin/env bash
#SBATCH --account=c3se2026-1-12
#SBATCH --partition=vera
#SBATCH --job-name=goal_proof_only_local_abs
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64
#SBATCH --time=0-05:00:00
#SBATCH --array=0-1
#SBATCH --output=/cephyr/users/guya/Vera/Projects/ijcar26-twee_abstractions/vera_jobs/goal_proof_only/slurm_%x_%A_%a.out
set -euo pipefail
cd /cephyr/users/guya/Vera/Projects/ijcar26-twee_abstractions
export TWEE_PATH=/usr/local/bin/twee_hints_v3
export RAYON_NUM_THREADS=1
export LOG_DIR=/cephyr/NOBACKUP/groups/c3se2026-1-96/guy/proof_outputs
export SLURM_CPUS_PER_TASK="${SLURM_CPUS_PER_TASK:?Submit this script using sbatch}"
case "${SLURM_ARRAY_TASK_ID:?Submit this script as a Slurm array}" in
  0)
    exec bash containers/run.sh twitch --stage local_abs --stage_config /cephyr/users/guya/Vera/Projects/ijcar26-twee_abstractions/src/stitch/configs/goal_proof_only/local_abs.yaml --input_dir /cephyr/users/guya/Vera/Projects/ijcar26-twee_abstractions/data/TPTP/GRP_UEQ_UNSAT --output_dir /cephyr/users/guya/Vera/Projects/ijcar26-twee_abstractions/data/experiments/goal_proof_only/local_abs/GRP --base_dir /cephyr/users/guya/Vera/Projects/ijcar26-twee_abstractions/data/experiments/goal_proof_only/base/GRP --job_id goal_proof_only_local_abs_GRP_local_abs_"${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}"
    ;;
  1)
    exec bash containers/run.sh twitch --stage local_abs --stage_config /cephyr/users/guya/Vera/Projects/ijcar26-twee_abstractions/src/stitch/configs/goal_proof_only/local_abs.yaml --input_dir /cephyr/users/guya/Vera/Projects/ijcar26-twee_abstractions/data/TPTP/LAT_UEQ_UNSAT --output_dir /cephyr/users/guya/Vera/Projects/ijcar26-twee_abstractions/data/experiments/goal_proof_only/local_abs/LAT --base_dir /cephyr/users/guya/Vera/Projects/ijcar26-twee_abstractions/data/experiments/goal_proof_only/base/LAT --job_id goal_proof_only_local_abs_LAT_local_abs_"${SLURM_ARRAY_JOB_ID}_${SLURM_ARRAY_TASK_ID}"
    ;;
  *) echo "Invalid array task: $SLURM_ARRAY_TASK_ID" >&2; exit 2 ;;
esac
