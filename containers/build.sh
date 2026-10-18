#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p containers/images
mkdir -p containers/inputs
cp "${TWEE_BINARY:-$HOME/.local/bin/twee_hints_v3}" containers/inputs/twee_hints_v3
cp "${VAMPIRE_BINARY:-$HOME/.local/bin/vampire}" containers/inputs/vampire
# Local temporary storage avoids network-filesystem limitations during builds.
export APPTAINER_TMPDIR="${APPTAINER_TMPDIR:-/tmp}"
export APPTAINER_CACHEDIR="${APPTAINER_CACHEDIR:-$PWD/containers/.cache}"
apptainer build --mksquashfs-args '-processors 2' \
    "${1:-containers/images/krympa-twitch.sif}" containers/krympa-twitch.def
