#!/usr/bin/env bash
# Review the manifest and the three arrays before submission.
set -euo pipefail
cd /cephyr/users/guya/Vera/Projects/ijcar26-twee_abstractions
bash containers/run.sh python scripts/proof_shortening.py check --suite /cephyr/users/guya/Vera/Projects/ijcar26-twee_abstractions/data/experiments/proof_shortening
sbatch /cephyr/users/guya/Vera/Projects/ijcar26-twee_abstractions/vera_jobs/proof_shortening/krympa.sh
sbatch /cephyr/users/guya/Vera/Projects/ijcar26-twee_abstractions/vera_jobs/proof_shortening/twitch_no_flatten.sh
sbatch /cephyr/users/guya/Vera/Projects/ijcar26-twee_abstractions/vera_jobs/proof_shortening/twitch_flatten.sh
