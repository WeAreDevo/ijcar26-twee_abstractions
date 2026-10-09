#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REV=7c19dec495a0271c1981c0e84e57ce3777415aeb
DEST="$ROOT/third_party/Krympa"

if [ ! -d "$DEST" ]; then
    git clone https://github.com/kondylidou/Krympa.git "$DEST"
    git -C "$DEST" checkout --detach "$REV"
fi
if [ "$(git -C "$DEST" rev-parse HEAD)" != "$REV" ]; then
    echo "Expected Krympa revision $REV; refusing to change an existing checkout." >&2
    exit 1
fi
command -v cargo >/dev/null
command -v dune >/dev/null
# Build natively on each machine; Cargo also builds the OCaml parser via dune.
cp "$ROOT/scripts/krympa.Cargo.lock" "$DEST/rust/Cargo.lock"
cd "$DEST/rust"
cargo build --release --locked --bin krympa
