#!/usr/bin/env bash

# Zed Project Picker using Yazi
# This script opens Yazi file manager to select a project directory,
# then opens that directory in Zed Editor.

set -e

# Default starting directory (you can customize this)
START_DIR="${1:-$HOME}"

# Temporary file to store the selected directory
TEMP_FILE=$(mktemp)

# Function to cleanup temp file on exit
cleanup() {
    rm -f "$TEMP_FILE"
}
trap cleanup EXIT

# Launch Yazi and capture the selected directory
yazi "$START_DIR" --cwd-file="$TEMP_FILE"

# Check if a directory was selected
if [[ -f "$TEMP_FILE" ]]; then
    SELECTED_DIR=$(cat "$TEMP_FILE")
    
    # Only proceed if a directory was actually selected (different from start)
    if [[ -n "$SELECTED_DIR" && -d "$SELECTED_DIR" ]]; then
        echo "Opening $SELECTED_DIR in Zed..."
        zed-fhs "$SELECTED_DIR"
    else
        echo "No directory selected or invalid directory."
        exit 1
    fi
else
    echo "No directory selected."
    exit 1
fi