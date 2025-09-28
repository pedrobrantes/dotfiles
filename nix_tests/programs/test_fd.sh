#!/usr/bin/env bash
set -euo pipefail

echo "--> Testing: fd module"

# Build the home-manager configuration
arch=$(uname -m)
config_path=$(nix-build .#brantes-${arch}-linux --no-out-link)

# 1. Check for package binary
if [ ! -f "$config_path/bin/fd" ]; then
    echo "FAIL: fd binary not found in the built environment." >&2
    exit 1
fi
echo "OK: fd package is installed."

# 2. Check for aliases
generated_bashrc="$config_path/home-files/.bashrc"
output_find=$(bash -c "source $generated_bashrc; alias find" 2>&1)
output_fd=$(bash -c "source $generated_bashrc; alias fd" 2>&1)

if ! echo "$output_find" | grep -q "find=fdfind"; then
    echo "FAIL: 'find' alias for fd is not correctly set." >&2
    echo "OUTPUT WAS: $output_find" >&2
    exit 1
fi

if ! echo "$output_fd" | grep -q "fd=fdfind"; then
    echo "FAIL: 'fd' alias for fd is not correctly set." >&2
    echo "OUTPUT WAS: $output_fd" >&2
    exit 1
fi
echo "OK: fd aliases are correct."
