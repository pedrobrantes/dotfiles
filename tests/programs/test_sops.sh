#!/usr/bin/env bash
set -euo pipefail

echo "--> Testing: programs/sops.nix"

arch=$(uname -m)
nix-build .#brantes-${arch}-linux --out-link result-sops-test

# Check that the age key file is created
SOPS_AGE_KEY_PATH="result-sops-test/home-files/.config/sops/age/keys.txt"
if [[ ! -f "$SOPS_AGE_KEY_PATH" ]]; then
    echo "FAIL: SOPS age key file not found at $SOPS_AGE_KEY_PATH." >&2
    rm -f result-sops-test
    exit 1
fi
echo "OK: SOPS age key file is created."

rm -f result-sops-test
