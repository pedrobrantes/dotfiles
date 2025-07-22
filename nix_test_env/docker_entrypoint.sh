#!/usr/bin/env bash
set -euo pipefail

export __HM_SESS_VARS_SOURCED="${__HM_SESS_VARS_SOURCED:-0}"

ls -R /root/.nix-profile
cat /root/.nix-channels 
ls -R /root/.config

source /root/.nix-profile/etc/profile.d/nix.sh

if command -v home-manager &>/dev/null; then
  home-manager switch || echo "home-manager switch fail"
fi

source /root/.nix-profile/etc/profile.d/hm-session-vars.sh

export PATH="/root/.nix-profile/bin:$PATH"

if [[ $# -eq 0 ]]; then
  set -- tail -f /dev/null
fi

ls -R /root/.nix-profile
cat /root/.nix-channels 
ls -R /root/.config

exec "$@"
