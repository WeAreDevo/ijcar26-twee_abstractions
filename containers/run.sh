#!/usr/bin/env bash
# Run the current checkout using the SIF only as its dependency environment.
set -euo pipefail
root=$(cd "$(dirname "$0")/.." && pwd)
image=${CONTAINER_IMAGE:-$root/containers/images/krympa-twitch.sif}
if [[ ! -f "$image" ]]; then
    echo "Missing image: $image (build it with bash containers/build.sh)" >&2
    exit 1
fi
options=(--cleanenv --bind "$root:$root" --pwd "$root"
    --env "PYTHONPATH=$root/src:$root")
overrides=()
# Pass only the settings needed by the tools, not the host module environment.
for name in TWEE_PATH VAMPIRE_PATH TPTP_ROOT LOG_DIR RAYON_NUM_THREADS KRYMPA_ROOT SLURM_CPUS_PER_TASK TWITCH_MAX_WORKERS; do
    if [[ -v $name ]]; then
        options+=(--env "$name=${!name}")
        overrides+=(--preserve "$name")
    fi
done
case "${1:-}" in
    twitch) shift; set -- python -u "$root/src/stitch/pipeline/worker.py" "$@" ;;
    krympa) shift; set -- python "$root/scripts/run_krympa.py" "$@" ;;
    "") set -- bash ;;
esac
exec apptainer exec "${options[@]}" "$image" python "$root/containers/run.py" \
    --root "$root" "${overrides[@]}" -- "$@"
