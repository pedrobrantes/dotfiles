#!/usr/bin/env bash
set -euo pipefail

echo "--> Testing: htop module"

# Build the home-manager configuration
arch=$(uname -m)
config_path=$(nix-build .#brantes-${arch}-linux --no-out-link)

# 1. Check for package binary
if [ ! -f "$config_path/bin/htop" ]; then
    echo "FAIL: htop binary not found in the built environment." >&2
    exit 1
fi
echo "OK: htop package is installed."

# 2. Check for alias
generated_bashrc="$config_path/home-files/.bashrc"
output=$(bash -c "source $generated_bashrc; alias top" 2>&1)

if ! echo "$output" | grep -q "top=htop"; then
    echo "FAIL: 'top' alias for htop is not correctly set." >&2
    echo "OUTPUT WAS: $output" >&2
    exit 1
fi
echo "OK: top alias is correct."
