#!/usr/bin/env bash
set -euo pipefail

echo "--> Testing: programs/bitwarden.nix"

arch=$(uname -m)
nix-build .#brantes-${arch}-linux --out-link result-bitwarden-test

# Check if bitwarden is present in the environment packages
if ! grep -q "bitwarden" "result-bitwarden-test/home-path/manifest.json"; then
    echo "FAIL: bitwarden not found in the package manifest." >&2
    rm -f result-bitwarden-test
    exit 1
fi
echo "OK: bitwarden is included in the environment."

rm -f result-bitwarden-test
