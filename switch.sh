#!/usr/bin/env bash

ARCH=$(uname -m)
KERNEL_RELEASE=$(uname -r)
VERSION_INFO=$(cat /proc/version 2>/dev/null)

if echo "$KERNEL_RELEASE" | grep -q "Microsoft" || echo "$VERSION_INFO" | grep -q "Microsoft"; then
    OS="wsl"
    DEVICE="desktop"

elif echo "$KERNEL_RELEASE" | grep -qi "proot" || [ -n "$TERMUX_VERSION" ]; then
    OS="android"
    DEVICE="smartphone"

else
    OS="linux"
    CURRENT_HOSTNAME=$(hostname)
    if [ "$CURRENT_HOSTNAME" == "localhost" ]; then
        echo "Warning: Hostname is localhost. Please set a hostname."
        DEVICE="unknown"
    else
        DEVICE="$CURRENT_HOSTNAME"
    fi
fi

FLAKE_URI="brantes@${ARCH}.${OS}.${DEVICE}"

echo "Environment Detected:"
echo "   Arch:   $ARCH"
echo "   OS:     $OS"
echo "   Device: $DEVICE"
echo "Applying: .#${FLAKE_URI}"

home-manager switch --flake ".#${FLAKE_URI}"
