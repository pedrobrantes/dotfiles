#!/usr/bin/env bash
set -euo pipefail

echo "--- Running All Container Tests ---"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

. "$SCRIPT_DIR/load_nix_env.sh"

find "$SCRIPT_DIR" -type f -name "*.sh" -not -name "$(basename "$0")" | while read -r test_script; do
  echo ""
  echo ">>> Executing test: ${test_script}"
  bash "$test_script"
done

echo ""
echo "--- All Tests Passed Successfully ---"
