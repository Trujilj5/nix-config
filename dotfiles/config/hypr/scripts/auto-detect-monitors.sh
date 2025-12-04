#!/usr/bin/env bash

# Auto-detect monitor profile for Hyprland
# Detects which monitors are connected and loads the appropriate profile

MONITORS_DIR="$HOME/nixos/dotfiles/config/hypr/monitors"
STATE_FILE="/tmp/hyprland_monitor_profile"

# Get list of connected monitors
# Wait a moment for monitors to be detected (useful on startup)
sleep 1
connected_monitors=$(hyprctl monitors all -j | jq -r '.[].name' 2>/dev/null || hyprctl monitors all | grep -oP '(?<=Monitor )[\w-]+')

# Convert to array for easier checking
mapfile -t monitors_array <<< "$connected_monitors"

# Function to check if a monitor is connected
is_connected() {
    local monitor_name="$1"
    for monitor in "${monitors_array[@]}"; do
        if [[ "$monitor" == "$monitor_name" ]]; then
            return 0
        fi
    done
    return 1
}

# Determine profile based on connected monitors
PROFILE="mobile"  # Default to mobile

if is_connected "DP-3" && is_connected "DP-5"; then
    # Both BenQ (DP-3) and ASUS (DP-5) detected = Home setup
    PROFILE="home"
elif is_connected "DP-3"; then
    # Only DP-3 detected - could be either Samsung (office) or BenQ (home)
    # We'll check the resolution/model to differentiate
    # Get monitor info for DP-3
    monitor_info=$(hyprctl monitors all | grep -A 20 "Monitor DP-3")

    # Check if it's the Samsung (1920x1080) or BenQ (3840x2560)
    if echo "$monitor_info" | grep -q "1920x1080"; then
        PROFILE="office"
    elif echo "$monitor_info" | grep -q "3840x2560"; then
        # BenQ at home but ASUS not detected - still use home profile
        PROFILE="home"
    else
        # Unknown DP-3 monitor, default to office
        PROFILE="office"
    fi
fi

# Save detected profile to state file
echo "$PROFILE" > "$STATE_FILE"

# Apply the detected monitor configuration
hyprctl keyword source "$MONITORS_DIR/$PROFILE.conf"

# Set workspace rules and move workspaces based on profile
case "$PROFILE" in
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
        # Move workspaces 5-10 to ASUS (DP-5) if it exists
        if is_connected "DP-5"; then
            for i in {5..10}; do
                hyprctl dispatch moveworkspacetomonitor $i DP-5 2>/dev/null
            done
        fi
        ;;
    mobile)
        # Move all workspaces to laptop screen
        for i in {1..10}; do
            hyprctl dispatch moveworkspacetomonitor $i eDP-2 2>/dev/null
        done
        ;;
esac

# Send notification
notify-send "Monitor Profile" "Auto-detected: $PROFILE" -t 2000
