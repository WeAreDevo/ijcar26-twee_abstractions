#!/bin/sh
set -eu
case "${1:-}" in
    krympa)
        shift
        exec python /opt/twitch/scripts/run_krympa.py "$@"
        ;;
    twitch)
        shift
        exec python /opt/twitch/src/stitch/pipeline/worker.py "$@"
        ;;
    "")
        echo 'Usage: apptainer run IMAGE.sif {krympa|twitch} [arguments]'
        echo 'Or:    apptainer exec IMAGE.sif COMMAND [arguments]'
        ;;
    *) exec "$@" ;;
esac
