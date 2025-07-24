#!/usr/bin/env bash
set -euo pipefail

echo Checking nix enviroment
if [ -f /root/.nix-profile/etc/profile.d/nix.sh ]; then
  echo Loading nix profile
  . /root/.nix-profile/etc/profile.d/nix.sh
  echo Loaded!
fi

if [ -f /root/.nix-profile/etc/profile.d/hm-session-vars.sh ]; then
  echo Loading home-manager session vars
  . /root/.nix-profile/etc/profile.d/hm-session-vars.sh
  echo Loaded!
fi

echo --------------------------------
