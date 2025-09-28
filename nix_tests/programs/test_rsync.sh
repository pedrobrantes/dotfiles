#!/usr/bin/env bash
set -euo pipefail

echo "--> Testing: rsync package installation"

# Build the home-manager configuration
arch=$(uname -m)
config_path=$(nix-build .#brantes-${arch}-linux --no-out-link)

# Check if rsync is available in the resulting profile's PATH
if ! NIX_PATH= $config_path/bin/hm-shell 'command -v rsync &> /dev/null'; then
    echo "FAIL: rsync command not found in the built environment." >&2
    exit 1
fi

echo "OK: rsync is available in the environment."
