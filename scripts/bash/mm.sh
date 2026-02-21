#!/usr/bin/env bash

# Media Source Manager Script
# Receives the source list as an environment variable or argument

SOURCE_LIST="$1"
ACTION="$2"

case "$ACTION" in
    "list")
        echo -e "\033[1;34m--- Saved Media Sources ---\033[0m"
        echo "${SOURCE_LIST}" | column -t -s "-"
        ;;
    "go")
        # Ensure fzf is available in the shell that calls this
        source=$(echo "${SOURCE_LIST}" | fzf --prompt="Select Source: " | awk '{print $NF}')
        if [ -n "$source" ]; then
            echo -e "\033[1;32mURL available:\033[0m $source"
        fi
        ;;
    *)
        echo "Usage: mm [list|go]"
        ;;
esac
