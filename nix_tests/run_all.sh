#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

#echo "--- Loading Nix Environment ---"
#. "$SCRIPT_DIR/load_nix_env.sh"
#echo "--- Environment Loaded ---"

echo "--- Running All Container Tests ---"

for test_script in $(find "$SCRIPT_DIR" -type f -name "*.sh" -not -name "$(basename "${BASH_SOURCE[0]}")" -not -name "load_nix_env.sh"); do
  echo ""
  echo ">>> Executing test: ${test_script}"
  
  . "$test_script"
done

echo ""
echo "--- All Tests Passed Successfully ---"
