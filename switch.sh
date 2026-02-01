#!/usr/bin/env bash
set -euo pipefail

info() { echo -e "\033[0;34m[INFO]\033[0m $1"; }
warn() { echo -e "\033[0;33m[WARNING]\033[0m $1"; }
success() { echo -e "\033[0;32m[SUCCESS]\033[0m $1"; }
error() { echo -e "\033[0;31m[ERROR]\033[0m $1" >&2; exit 1; }

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

target="brantes@${arch}.${os}.${device}"

info "Environment Detected: ${arch} | ${os} | ${device}"

# --- Test Enforcement ---
info "Running configuration tests..."
if [ -x "./tests/run_all.sh" ]; then
    if ! ./tests/run_all.sh; then
        error "Tests failed! Aborting switch to prevent broken configuration."
    fi
    success "All tests passed."
else
    warn "Test runner (./tests/run_all.sh) not found or not executable."
fi
# ------------------------

info "Applying target: .#${target}"

home-manager switch --flake ".#${target}"

if [[ "$os" == "android" ]]; then
    if [ -d "/homeless-shelter" ]; then
        warn "Cleaning up /homeless-shelter..."
        rm -rf /homeless-shelter
	home-manager switch --flake ".#${target}"
    fi
    export HOME="/home/brantes"
fi

