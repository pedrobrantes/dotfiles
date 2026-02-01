#!/usr/bin/env bash
set -euo pipefail

echo "--> Testing: eza module"

# Build the home-manager configuration
arch=$(uname -m)
config_path=$(nix-build .#brantes-${arch}-linux --no-out-link)

# 1. Check for package binary
if [ ! -f "$config_path/bin/eza" ]; then
    echo "FAIL: eza binary not found in the built environment." >&2
    exit 1
fi
echo "OK: eza package is installed."

# 2. Check for alias
generated_bashrc="$config_path/home-files/.bashrc"
output=$(bash -c "source $generated_bashrc; alias ls" 2>&1)

if ! echo "$output" | grep -q "ls='eza --icons'"; then
    echo "FAIL: 'ls' alias for eza is not correctly set." >&2
    echo "OUTPUT WAS: $output" >&2
    exit 1
fi
echo "OK: eza alias is correct."
