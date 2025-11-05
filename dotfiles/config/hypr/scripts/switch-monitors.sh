#!/usr/bin/env bash

# Monitor profile switcher for Hyprland
# Cycles between office -> home -> mobile -> office...
# Auto-detects connected monitors and falls back to mobile if none found

MONITORS_DIR="$HOME/nixos/dotfiles/config/hypr/monitors"
STATE_FILE="/tmp/hyprland_monitor_profile"

# Check if there are any external monitors (more than just the laptop screen)
monitor_count=$(hyprctl monitors | grep -c "^Monitor")

# If only 1 monitor (laptop screen only), force mobile mode
if [ "$monitor_count" -le 1 ]; then
    NEXT="mobile"
    echo "$NEXT" > "$STATE_FILE"
    hyprctl keyword source "$MONITORS_DIR/$NEXT.conf"
    notify-send "Monitor Profile" "No external monitors detected - switched to: $NEXT" -t 2000
    exit 0
fi

# Determine current profile from state file, default to mobile
if [ -f "$STATE_FILE" ]; then
    CURRENT=$(cat "$STATE_FILE")
else
    CURRENT="mobile"
fi

# Determine next profile
case "$CURRENT" in
    office)
        NEXT="home"
        ;;
    home)
        NEXT="mobile"
        ;;
    mobile)
        NEXT="office"
        ;;
    *)
        NEXT="mobile"
        ;;
esac

# Save new state
echo "$NEXT" > "$STATE_FILE"

# Apply the new monitor configuration
hyprctl keyword source "$MONITORS_DIR/$NEXT.conf"

# Send notification
notify-send "Monitor Profile" "Switched to: $NEXT" -t 2000
