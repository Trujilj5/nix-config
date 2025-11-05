#!/usr/bin/env bash

# Monitor profile switcher for Hyprland
# Cycles between office -> home -> mobile -> office...
# Auto-detects connected monitors and falls back to mobile if none found

MONITORS_DIR="$HOME/nixos/dotfiles/config/hypr/monitors"
STATE_FILE="/tmp/hyprland_monitor_profile"

# Check which external monitors are connected
has_dp3=$(hyprctl monitors | grep -q "DP-3" && echo "yes" || echo "no")
has_dp1=$(hyprctl monitors | grep -q "DP-1" && echo "yes" || echo "no")
has_hdmi=$(hyprctl monitors | grep -q "HDMI-A-1" && echo "yes" || echo "no")

# If no external monitors detected, force mobile mode
if [ "$has_dp3" = "no" ] && [ "$has_dp1" = "no" ] && [ "$has_hdmi" = "no" ]; then
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
