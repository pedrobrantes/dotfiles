#!/usr/bin/env bash
set -euo pipefail

export __HM_SESS_VARS_SOURCED="${__HM_SESS_VARS_SOURCED:-0}"

source /root/.nix-profile/etc/profile.d/nix.sh

if command -v home-manager &>/dev/null; then
  home-manager switch || echo "home-manager switch fail"
fi

source /root/.nix-profile/etc/profile.d/hm-session-vars.sh

export PATH="/root/.nix-profile/bin:$PATH"

if [[ $# -eq 0 ]]; then
  set -- tail -f /dev/null
fi

exec "$@"
