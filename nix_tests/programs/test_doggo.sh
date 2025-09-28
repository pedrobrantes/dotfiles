#!/usr/bin/env bash
set -euo pipefail

echo "--> Testing: doggo module"

# Build the home-manager configuration
arch=$(uname -m)
config_path=$(nix-build .#brantes-${arch}-linux --no-out-link)

# 1. Check for package binary
if [ ! -f "$config_path/bin/doggo" ]; then
    echo "FAIL: doggo binary not found in the built environment." >&2
    exit 1
fi
echo "OK: doggo package is installed."

# 2. Check for aliases
generated_bashrc="$config_path/home-files/.bashrc"
output_nslookup=$(bash -c "source $generated_bashrc; alias nslookup" 2>&1)
output_dig=$(bash -c "source $generated_bashrc; alias dig" 2>&1)

if ! echo "$output_nslookup" | grep -q "nslookup=doggo"; then
    echo "FAIL: 'nslookup' alias for doggo is not correctly set." >&2
    echo "OUTPUT WAS: $output_nslookup" >&2
    exit 1
fi

if ! echo "$output_dig" | grep -q "dig=doggo"; then
    echo "FAIL: 'dig' alias for doggo is not correctly set." >&2
    echo "OUTPUT WAS: $output_dig" >&2
    exit 1
fi
echo "OK: doggo aliases are correct."
