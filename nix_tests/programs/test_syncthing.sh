#!/usr/bin/env bash
set -euo pipefail

echo "--> Testing: programs/syncthing.nix"

arch=$(uname -m)
nix-build .#brantes-${arch}-linux --out-link result-syncthing-test

# Check if the systemd service file for Syncthing is created
SERVICE_PATH="result-syncthing-test/home-files/.config/systemd/user/syncthing.service"
if [[ ! -f "$SERVICE_PATH" ]]; then
    echo "FAIL: Syncthing systemd service file not found at $SERVICE_PATH." >&2
    rm -f result-syncthing-test
    exit 1
fi
echo "OK: Syncthing systemd service is correctly configured."

rm -f result-syncthing-test
