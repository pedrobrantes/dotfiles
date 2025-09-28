#!/usr/bin/env bash
set -euo pipefail

echo "--> Testing: iproute2 module"

# Build the home-manager configuration
arch=$(uname -m)
config_path=$(nix-build .#brantes-${arch}-linux --no-out-link)

# 1. Check for package binary
if [ ! -f "$config_path/bin/ss" ] || [ ! -f "$config_path/bin/ip" ]; then
    echo "FAIL: ss or ip (iproute2) binary not found in the built environment." >&2
    exit 1
fi
echo "OK: iproute2 package is installed."

# 2. Check for aliases
generated_bashrc="$config_path/home-files/.bashrc"

output_netstat=$(bash -c "source $generated_bashrc; alias netstat" 2>&1)
if ! echo "$output_netstat" | grep -q "netstat=ss"; then
    echo "FAIL: 'netstat' alias for ss is not correctly set." >&2
    echo "OUTPUT WAS: $output_netstat" >&2
    exit 1
fi

output_ips=$(bash -c "source $generated_bashrc; alias ips" 2>&1)
if ! echo "$output_ips" | grep -q "ips='ip -c -br a'"; then
    echo "FAIL: 'ips' alias is not correctly set." >&2
    echo "OUTPUT WAS: $output_ips" >&2
    exit 1
fi

output_ifconfig=$(bash -c "source $generated_bashrc; alias ifconfig" 2>&1)
if ! echo "$output_ifconfig" | grep -q "ifconfig=ip"; then
    echo "FAIL: 'ifconfig' alias is not correctly set." >&2
    echo "OUTPUT WAS: $output_ifconfig" >&2
    exit 1
fi

echo "OK: iproute2 aliases are correct."