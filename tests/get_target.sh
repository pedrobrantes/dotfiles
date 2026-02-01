#!/usr/bin/env bash
set -euo pipefail

# This script detects the current environment and outputs the correct flake target
# for use in tests.

arch=$(uname -m)
os="linux"
device="desktop"

if [ -d "/data/data/com.termux" ] || [ -f "/system/build.prop" ]; then
    os="android"
    device="smartphone"
elif grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null; then
    os="wsl"
    device="desktop"
fi

echo "homeConfigurations.\"brantes@${arch}.${os}.${device}\""
