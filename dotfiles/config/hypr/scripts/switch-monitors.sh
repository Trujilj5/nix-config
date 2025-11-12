#!/usr/bin/env bash

# Monitor profile switcher for Hyprland
# Cycles between office -> home -> mobile -> office...
# Auto-detects connected monitors and falls back to mobile if none found

MONITORS_DIR="$HOME/nixos/dotfiles/config/hypr/monitors"
STATE_FILE="/tmp/hyprland_monitor_profile"

# Check if there are any external monitors (including disabled ones)
# Use "monitors all" to see disabled monitors that might be connected
monitor_count=$(hyprctl monitors all | grep -c "^Monitor")

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

# Set workspace rules and move workspaces based on profile
case "$NEXT" in
    office)
        # Set workspace rules for office
        hyprctl keyword workspace "1,monitor:DP-3,default:true" 2>/dev/null
        hyprctl keyword workspace "2,monitor:DP-3" 2>/dev/null
        hyprctl keyword workspace "5,monitor:DP-3" 2>/dev/null
        # Clear rules for workspaces 3,4,6-10 so they can float
        for i in 3 4 6 7 8 9 10; do
            hyprctl keyword workspace "$i," 2>/dev/null
        done
        # Move workspaces 1-2 and 5 to Samsung (DP-3)
        hyprctl dispatch moveworkspacetomonitor 1 DP-3 2>/dev/null
        hyprctl dispatch moveworkspacetomonitor 2 DP-3 2>/dev/null
        hyprctl dispatch moveworkspacetomonitor 5 DP-3 2>/dev/null
        ;;
    home)
        # Move workspaces 1-4 to BenQ (DP-3)
        for i in {1..4}; do
            hyprctl dispatch moveworkspacetomonitor $i DP-3 2>/dev/null
        done
        # Move workspaces 5-10 to ASUS (DP-5)
        for i in {5..10}; do
            hyprctl dispatch moveworkspacetomonitor $i DP-5 2>/dev/null
        done
        ;;
    mobile)
        # Move all workspaces to laptop screen
        for i in {1..10}; do
            hyprctl dispatch moveworkspacetomonitor $i eDP-2 2>/dev/null
        done
        ;;
esac

# Send notification
notify-send "Monitor Profile" "Switched to: $NEXT" -t 2000
