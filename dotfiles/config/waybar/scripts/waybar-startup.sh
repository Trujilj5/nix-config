#!/usr/bin/env bash

# Waybar startup script with notification workspace highlighting

# Wait for waybar to start
sleep 2

# Initialize notification highlighting based on current state
~/.config/waybar/scripts/highlight-notification-workspace.sh auto

echo "Waybar notification workspace highlighting initialized"
