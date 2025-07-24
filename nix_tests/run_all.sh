#!/usr/bin/env bash
set -euo pipefail

echo "--- Running All Container Tests ---"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

find "$SCRIPT_DIR" -type f -name "*.sh" -not -name "$(basename "$0")" | while read -r test_script; do
  echo ""
  echo ">>> Executing test: ${test_script}"
  /usr/local/bin/docker_entrypoint.sh "$test_script"
done

echo ""
echo "--- All Tests Passed Successfully ---"
