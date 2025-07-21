#!/usr/bin/env bash
set -euo pipefail

echo "--> Testing: Editor Environment Variable"
printenv EDITOR | grep -q 'nvim'
echo "OK: EDITOR is set to nvim."
