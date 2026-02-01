#!/usr/bin/env bash
set -euo pipefail

echo "--> Testing: bootstrap.sh architecture detection"

# Test for x86_64
arch="x86_64"
expected_flake_target=".#brantes-x86_64-linux"
flake_target=".#brantes-${arch}-linux"
if [[ "$flake_target" != "$expected_flake_target" ]]; then
    echo "FAIL: Incorrect flake target for x86_64. Expected '$expected_flake_target', got '$flake_target'" >&2
    exit 1
fi
echo "OK: Flake target for x86_64 is correct."

# Test for aarch64
arch="aarch64"
expected_flake_target=".#brantes-aarch64-linux"
flake_target=".#brantes-${arch}-linux"
if [[ "$flake_target" != "$expected_flake_target" ]]; then
    echo "FAIL: Incorrect flake target for aarch64. Expected '$expected_flake_target', got '$flake_target'" >&2
    exit 1
fi
echo "OK: Flake target for aarch64 is correct."
