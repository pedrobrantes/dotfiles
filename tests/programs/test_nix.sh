#!/usr/bin/env bash
set -euo pipefail

echo "--> Testing: programs/nix.nix"

arch=$(uname -m)
nix-build .#brantes-${arch}-linux --out-link result-nix-test

# Check for experimental-features in nix.conf
NIX_CONF_PATH="result-nix-test/home-files/.config/nix/nix.conf"
if ! grep -q "experimental-features = nix-command flakes" "$NIX_CONF_PATH"; then
    echo "FAIL: 'experimental-features' not correctly set in nix.conf." >&2
    rm -f result-nix-test
    exit 1
fi
echo "OK: Nix experimental-features are correctly configured."

rm -f result-nix-test
