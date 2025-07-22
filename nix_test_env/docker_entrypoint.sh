#!/usr/bin/env bash
set -euo pipefail

export __HM_SESS_VARS_SOURCED="${__HM_SESS_VARS_SOURCED:-0}"

source /root/.nix-profile/etc/profile.d/nix.sh
source /root/.nix-profile/etc/profile.d/hm-session-vars.sh

if [[ $# -eq 0 ]]; then
  set -- tail -f /dev/null
fi

exec "$@"
