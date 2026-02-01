#!/usr/bin/env bash
set -euo pipefail

# Initialize the variable to prevent 'unbound variable' error from set -u
export __HM_SESS_VARS_SOURCED="${__HM_SESS_VARS_SOURCED:-0}"

echo Checking nix environment...
if [ -f /root/.nix-profile/etc/profile.d/nix.sh ]; then
  echo Loading nix profile
  . /root/.nix-profile/etc/profile.d/nix.sh
  echo Loaded!
fi

if [ -f /root/.nix-profile/etc/profile.d/hm-session-vars.sh ]; then
  echo "Loading home-manager session vars..."
  . /root/.nix-profile/etc/profile.d/hm-session-vars.sh
  echo "Loaded!"
else
  # If the file doesn't exist, run home-manager switch to generate it
  echo "Session variables file not found. Running home-manager switch to generate it..."
  home-manager switch
  
  # Source the file after generating it
  if [ -f /root/.nix-profile/etc/profile.d/hm-session-vars.sh ]; then
    . /root/.nix-profile/etc/profile.d/hm-session-vars.sh
    echo "Loaded after generation!"
  else
    echo "Warning: home-manager switch did not create the session variables file."
  fi
fi

echo --------------------------------
