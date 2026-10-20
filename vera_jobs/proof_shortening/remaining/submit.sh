#!/usr/bin/env bash
# Prepared only; running this script submits the remaining arrays.
set -euo pipefail
cd /cephyr/users/guya/Vera/Projects/ijcar26-twee_abstractions
parallel=${PROOF_PARALLEL_TASKS:-2}
[[ "$parallel" =~ ^[1-9][0-9]*$ ]] || { echo "PROOF_PARALLEL_TASKS must be positive" >&2; exit 1; }
bash containers/run.sh python scripts/proof_shortening.py check --suite /cephyr/users/guya/Vera/Projects/ijcar26-twee_abstractions/data/experiments/proof_shortening
sbatch --array="35,37-130%$parallel" /cephyr/users/guya/Vera/Projects/ijcar26-twee_abstractions/vera_jobs/proof_shortening/remaining/krympa.sh
sbatch --array="40,42-130%$parallel" /cephyr/users/guya/Vera/Projects/ijcar26-twee_abstractions/vera_jobs/proof_shortening/remaining/twitch_no_flatten.sh
sbatch --array="40,42-130%$parallel" /cephyr/users/guya/Vera/Projects/ijcar26-twee_abstractions/vera_jobs/proof_shortening/remaining/twitch_flatten.sh
