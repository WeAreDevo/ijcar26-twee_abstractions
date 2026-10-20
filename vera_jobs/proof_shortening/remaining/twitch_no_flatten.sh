#!/usr/bin/env bash
#SBATCH --account=c3se2026-1-12
#SBATCH --partition=vera
#SBATCH --job-name=proof_shortening_twitch_no_flatten_remaining
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=64G
#SBATCH --time=0-03:00:00
#SBATCH --signal=B:TERM@180
#SBATCH --array=40,42-130%2
#SBATCH --output=/cephyr/users/guya/Vera/Projects/ijcar26-twee_abstractions/vera_jobs/proof_shortening/remaining/slurm_%x_%A_%a.out
set -euo pipefail
cd /cephyr/users/guya/Vera/Projects/ijcar26-twee_abstractions
export TWEE_PATH=/usr/local/bin/twee_hints_v3
export VAMPIRE_PATH=/usr/local/bin/vampire
export RAYON_NUM_THREADS=1
export LOG_DIR=/cephyr/NOBACKUP/groups/c3se2026-1-96/guy/proof_outputs
export TPTP_ROOT=/cephyr/users/guya/Vera/TPTP-v9.3.1
export TWITCH_MAX_WORKERS="${TWITCH_MAX_WORKERS:-4}"
exec bash containers/run.sh python -u scripts/proof_shortening.py run-shard --suite /cephyr/users/guya/Vera/Projects/ijcar26-twee_abstractions/data/experiments/proof_shortening --method twitch_no_flatten --retry-storage-errors --shard "${SLURM_ARRAY_TASK_ID:?Submit using sbatch}"
