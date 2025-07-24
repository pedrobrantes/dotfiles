#!/usr/bin/env bash
set -euo pipefail

# Source the environment setup script
/app/tests/load_nix_env.sh

echo "--- DEBUGGING SHELL ENVIRONMENT ---"

# Display shell information BEFORE the loop
echo -e "\n[BEFORE LOOP] Shell PID: $$"
echo "[BEFORE LOOP] Subshell Level: $BASH_SUBSHELL" 
echo "[BEFORE LOOP] PATH: $PATH"
echo "[BEFORE LOOP] EDITOR: ${EDITOR:-'NOT SET'}"

echo -e "\n--- Starting 'find' loop ---"

# The 'find' command will locate one test file for the example
find "/app/tests/env" -type f -name "*.sh" | while read -r test_script; do
  echo ""
  # Display information from INSIDE the loop
  # We use `$$` for the PID and `$BASH_SUBSHELL` to see if we're in a subshell
  echo "[INSIDE WHILE] Process PID: $$"
  echo "[INSIDE WHILE] Subshell Level: $BASH_SUBSHELL"
  echo "[INSIDE WHILE] PATH: $PATH"
  echo "[INSIDE WHILE] EDITOR: ${EDITOR:-'NOT SET'}"
done

echo -e "\n--- End of debug script ---"
