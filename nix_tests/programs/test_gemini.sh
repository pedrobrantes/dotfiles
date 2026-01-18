#!/usr/bin/env bash
set -euo pipefail

echo "--> Testing: Gemini CLI"
if ! command -v gemini &> /dev/null; then
    echo "FAIL: gemini command not found." >&2
    exit 1
fi
echo "OK: gemini command is available in PATH."
