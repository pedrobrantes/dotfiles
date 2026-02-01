#!/usr/bin/env bash
set -euo pipefail

echo "--> Testing: programs/bash.nix"

# Build the home-manager configuration for a specific architecture
target=$($(dirname "$0")/../get_target.sh)
nix-build .#${target}.activationPackage --out-link result-bash-test

# Check if the BASH_IT export is in the generated bashrc
BASHRC_PATH="result-bash-test/home-files/.bashrc"
if ! grep -q 'export BASH_IT=' "$BASHRC_PATH"; then
    echo "FAIL: 'export BASH_IT=' not found in the generated .bashrc" >&2
    rm -f result-bash-test
    exit 1
fi
echo "OK: BASH_IT export is correctly set in .bashrc."

rm -f result-bash-test
