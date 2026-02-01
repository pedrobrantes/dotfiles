#!/usr/bin/env bash
set -euo pipefail

echo "--> Testing: dust module"

# Build the home-manager configuration
arch=$(uname -m)
config_path=$(nix-build .#brantes-${arch}-linux --no-out-link)

# 1. Check for package binary (executable is dust, package is du-dust)
if [ ! -f "$config_path/bin/dust" ]; then
    echo "FAIL: dust binary not found in the built environment." >&2
    exit 1
fi
echo "OK: du-dust package is installed."

# 2. Check for alias
generated_bashrc="$config_path/home-files/.bashrc"
output=$(bash -c "source $generated_bashrc; alias du" 2>&1)

if ! echo "$output" | grep -q "du='dust --depth 10'"; then
    echo "FAIL: 'du' alias for dust is not correctly set." >&2
    echo "OUTPUT WAS: $output" >&2
    exit 1
fi
echo "OK: du alias is correct."
