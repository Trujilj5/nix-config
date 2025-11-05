#!/usr/bin/env bash

# Monitor profile switcher for Hyprland
# Cycles between office -> home -> mobile -> office...

MONITORS_DIR="$HOME/nixos/dotfiles/config/hypr/monitors"
STATE_FILE="/tmp/hyprland_monitor_profile"

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
