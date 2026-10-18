#!/usr/bin/env bash
# Explicit submission step: review pipeline_*.sh before running this file.
set -euo pipefail
dependency=()

job_id=$(sbatch --parsable "${dependency[@]}" /cephyr/users/guya/Vera/Projects/ijcar26-twee_abstractions/vera_jobs/goal_proof_only/pipeline_base.sh)
job_id="${job_id%%;*}"
echo "Submitted pipeline_base: $job_id"
dependency=("--dependency=afterok:$job_id")

job_id=$(sbatch --parsable "${dependency[@]}" /cephyr/users/guya/Vera/Projects/ijcar26-twee_abstractions/vera_jobs/goal_proof_only/pipeline_local_abs.sh)
job_id="${job_id%%;*}"
echo "Submitted pipeline_local_abs: $job_id"
dependency=("--dependency=afterok:$job_id")
