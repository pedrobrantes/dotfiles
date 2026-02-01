#!/usr/bin/env bash
set -euo pipefail

echo "--> Testing: Git Configuration"
git config --global user.name | grep -q 'PedroBrantes'
echo "OK: Git user name is correct."
