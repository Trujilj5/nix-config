#!/usr/bin/env bash

# Monitor autodetection for Hyprland
# Automatically configures monitors based on what's connected

# Wait for monitors to be fully initialized
sleep 2

# Log that script is running
echo "[$(date)] Monitor autodetect script starting" >> /tmp/hyprland-monitor-autodetect.log

# Get list of connected monitors
connected_monitors=$(hyprctl monitors all -j | jq -r '.[].name')

# Check which setup we're in based on connected monitors
if echo "$connected_monitors" | grep -q "DP-5"; then
    # Home setup: DP-3 (BenQ) + DP-5 (ASUS), laptop disabled
    hyprctl keyword monitor "DP-3,3840x2560@60,0x0,2,bitdepth,10"
    hyprctl keyword monitor "DP-5,3840x2160@60,1920x0,2,bitdepth,10"
    hyprctl keyword monitor "eDP-2,disable"

    # Workspace assignments for home
    hyprctl keyword workspace "1,monitor:DP-3,default:true"
    hyprctl keyword workspace "2,monitor:DP-3"
    hyprctl keyword workspace "3,monitor:DP-3"
    hyprctl keyword workspace "4,monitor:DP-3"
    hyprctl keyword workspace "5,monitor:DP-5,default:true"
    hyprctl keyword workspace "6,monitor:DP-5"
    hyprctl keyword workspace "7,monitor:DP-5"
    hyprctl keyword workspace "8,monitor:DP-5"
    hyprctl keyword workspace "9,monitor:DP-5"
    hyprctl keyword workspace "10,monitor:DP-5"

    # Move workspaces to correct monitors
    for i in {1..4}; do
        hyprctl dispatch moveworkspacetomonitor "$i" DP-3 2>/dev/null
    done
    for i in {5..10}; do
        hyprctl dispatch moveworkspacetomonitor "$i" DP-5 2>/dev/null
    done

elif echo "$connected_monitors" | grep -q "DP-3"; then
    # Office setup: DP-3 (Samsung) + laptop
    hyprctl keyword monitor "DP-3,1920x1080@75,auto-right,1,bitdepth,10"
    hyprctl keyword monitor "eDP-2,preferred,0x0,1.6,bitdepth,10"
    hyprctl keyword monitor "DP-5,disable"

    # Workspace assignments for office
    hyprctl keyword workspace "1,monitor:DP-3,default:true"
    hyprctl keyword workspace "2,monitor:DP-3"
    hyprctl keyword workspace "5,monitor:DP-3"

    # Clear rules for other workspaces
    for i in 3 4 6 7 8 9 10; do
        hyprctl keyword workspace "$i,"
    done

    # Move workspaces to Samsung
    hyprctl dispatch moveworkspacetomonitor 1 DP-3 2>/dev/null
    hyprctl dispatch moveworkspacetomonitor 2 DP-3 2>/dev/null
    hyprctl dispatch moveworkspacetomonitor 5 DP-3 2>/dev/null

else
    # Mobile setup: laptop screen only
    hyprctl keyword monitor "eDP-2,preferred,auto,1.6,bitdepth,10"
    hyprctl keyword monitor "DP-1,disable"
    hyprctl keyword monitor "DP-3,disable"
    hyprctl keyword monitor "HDMI-A-1,disable"

    # Move all workspaces to laptop
    for i in {1..10}; do
        hyprctl dispatch moveworkspacetomonitor "$i" eDP-2 2>/dev/null
    done
fi
