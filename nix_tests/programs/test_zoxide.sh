#!/usr/bin/env bash
set -euo pipefail

echo "--> Testing: zoxide module"

# Build the home-manager configuration
arch=$(uname -m)
config_path=$(nix-build .#brantes-${arch}-linux --no-out-link)

# 1. Check for zoxide binary
if [ ! -f "$config_path/bin/zoxide" ]; then
    echo "FAIL: zoxide binary not found in the built environment." >&2
    exit 1
fi
echo "OK: zoxide package is installed."

# 2. Check for init script in bashrc
generated_bashrc="$config_path/home-files/.bashrc"
if ! grep -q "zoxide init bash" "$generated_bashrc"; then
    echo "FAIL: zoxide init script not found in generated .bashrc." >&2
    exit 1
fi
echo "OK: zoxide init script is present."

# 3. Check for alias
# The zoxide module automatically creates the 'cd' alias.
output=$(bash -c "source $generated_bashrc; alias cd" 2>&1)
if ! echo "$output" | grep -q "cd=z"; then
    echo "FAIL: 'cd' alias for zoxide is not correctly set." >&2
    echo "OUTPUT WAS: $output" >&2
    exit 1
fi
echo "OK: zoxide 'cd' alias is correct."
