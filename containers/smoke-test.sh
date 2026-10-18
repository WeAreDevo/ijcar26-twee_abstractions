#!/usr/bin/env bash
# Exercise native extensions, Rust, Twitch/Twee, and all four Krympa stages.
set -euo pipefail
cd "$(dirname "$0")/.."
image=$(realpath "${1:-containers/images/krympa-twitch.sif}")
run_dir=$(mktemp -d "$PWD/containers/images/smoke-XXXXXX")
mkdir -p "$run_dir/input"
cat > "$run_dir/input/Equation1024_implies_Equation424.p" <<'EOF'
fof(a1, axiom, ! [X0, X1, X2] :
    (X0 = op(X0,op(op(X0,op(X0,X1)),X2)))).
fof(conjecture0, conjecture, ! [X0, X1, X2] :
    (X0 = op(X0,op(X0,op(X1,op(X2,X2)))))).
EOF
cat > "$run_dir/base.yaml" <<'EOF'
twee:
  flags:
    - --flatten-goal
    - --all-lemmas
    - --show-peaks
    - --proof-on-saturation
    - --hint-skel-factor 0.2
    - --hint-skel-cost 0
    - --max-time 20
  timeout: 30
EOF
apptainer test --cleanenv "$image"
apptainer exec --cleanenv "$image" python /opt/twitch/src/stitch/test_translation.py
apptainer exec --cleanenv "$image" python -c \
  'from stitch_core import compress; r = compress(["(f (g a))", "(f (g b))"], iterations=1); print(r)'
echo 'fn main() { println!("Rust compilation OK"); }' > "$run_dir/hello.rs"
apptainer exec --cleanenv "$image" rustc "$run_dir/hello.rs" -o "$run_dir/hello"
apptainer exec --cleanenv "$image" "$run_dir/hello"
apptainer run --cleanenv --env "TPTP_ROOT=$run_dir/input" \
  --env "LOG_DIR=$run_dir/logs" "$image" twitch \
  --stage base --stage_config "$run_dir/base.yaml" --input_dir "$run_dir/input" \
  --output_dir "$run_dir/twitch" --debug
apptainer exec --cleanenv "$image" python - "$run_dir" <<'PY'
import json
import pathlib
import sys
root = pathlib.Path(sys.argv[1])
summary, = (root / "twitch").glob("*/summary.json")
results = json.loads(summary.read_text())
assert len(results) == 1 and results[0]["base_status"] == "success", results
proof, = (root / "logs").glob("*/*_base_output.txt")
assert "RESULT: Theorem" in proof.read_text(), proof.read_text()
PY
apptainer run --cleanenv --env RAYON_NUM_THREADS=2 "$image" krympa \
  "$run_dir/input/Equation1024_implies_Equation424.p" \
  --output-dir "$run_dir/krympa" --timeout 90 --sequential
echo "Smoke tests passed. Logs and proofs: $run_dir"
