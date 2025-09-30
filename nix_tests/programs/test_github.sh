#!/usr/bin/env bash
set -euo pipefail

echo "--> Testing: gh command in current environment"

if ! command -v gh &> /dev/null; then
    echo "FAIL: The 'gh' command was not found in the current environment's PATH." >&2
    exit 1
fi
echo "OK: The 'gh' command is installed and available."

git_protocol=$(gh config get git_protocol 2>/dev/null || true)

if [[ "$git_protocol" != "ssh" ]]; then
    echo "FAIL: 'git_protocol' is '$git_protocol', but 'ssh' was expected." >&2
    exit 1
fi
echo "OK: The gh 'git_protocol' is correctly set to 'ssh'."

