#!/usr/bin/env bash
set -euo pipefail

info() { echo -e "\033[0;34m[INFO]\033[0m $1"; }
warn() { echo -e "\033[0;33m[WARNING]\033[0m $1"; }
success() { echo -e "\033[0;32m[SUCCESS]\033[0m $1"; }
error() { echo -e "\033[0;31m[ERROR]\033[0m $1" >&2; exit 1; }

evaluate_nix_closure() {
    local target_attr=".#homeConfigurations.\"${target}\".activationPackage"
    
    info "Evaluating Nix closure size for ${target}..."
    local closure_size
    closure_size=$(nix path-info -Sh --extra-experimental-features "nix-command flakes" "$target_attr" 2>/dev/null | awk '{print $2}' || true)
    if [ -n "$closure_size" ]; then
        info "Total closure size: ${closure_size}"
    fi

    info "Evaluating required downloads and build footprint..."
    local dry_run_output
    dry_run_output=$(nix build --dry-run --extra-experimental-features "nix-command flakes" "$target_attr" 2>&1 || true)
    
    if echo "$dry_run_output" | grep -q "will be fetched"; then
        local fetch_info
        fetch_info=$(echo "$dry_run_output" | grep -iE "will be fetched" | head -n 1)
        info "Fetch metrics: ${fetch_info}"
    else
        info "All dependencies already present in local /nix/store."
    fi
}

handle_build_error() {
    warn "Build or test step encountered an error."
    warn "If storage allocation failed in Termux, purge old Home-Manager generations:"
    warn "home-manager expire-generations \"-0 days\" && nix-store --gc"
    error "Execution aborted."
}

arch=$(uname -m)
os="linux"
device="desktop"

if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

if [ -d "/data/data/com.termux" ] || [ -f "/system/build.prop" ]; then
    os="android"
    device="smartphone"
elif grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null; then
    os="wsl"
    device="desktop"
fi

target="brantes@${arch}.${os}.${device}"

info "Environment Detected: ${arch} | ${os} | ${device}"

evaluate_nix_closure

info "Running configuration tests (via Pytest)..."
if ! nix-shell -p python3Packages.pytest --run "pytest tests/"; then
    handle_build_error
fi
success "All tests passed."

info "Applying target: .#${target}"

if ! home-manager switch --flake ".#${target}" -b backup; then
    handle_build_error
fi

if [[ "$os" == "android" ]]; then
    if [ -d "/homeless-shelter" ]; then
        warn "Cleaning up /homeless-shelter..."
        rm -rf /homeless-shelter
        home-manager switch --flake ".#${target}" -b backup
    fi
    export HOME="/home/brantes"
fi
