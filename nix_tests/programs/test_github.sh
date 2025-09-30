#!/usr/bin/env bash
set -euo pipefail

echo "--> Testing: gh module"

arch=$(uname -m)
config_path=$(nix build .#homeConfigurations.brantes-${arch}-linux.activationPackage --no-link --print-out-paths)

if [ ! -f "$config_path/bin/gh" ]; then
    echo "FAIL: gh binary not found in the built environment." >&2
    exit 1
fi
echo "OK: gh package is installed."

gh_config_file="$config_path/home-files/.config/gh/config.yml"
if ! grep -q "git_protocol: ssh" "$gh_config_file"; then
    echo "FAIL: 'git_protocol' is not set to 'ssh' in gh config." >&2
    cat "$gh_config_file" >&2
    exit 1
fi
echo "OK: gh git_protocol is correctly set."
