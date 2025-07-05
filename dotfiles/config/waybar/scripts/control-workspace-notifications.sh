#!/usr/bin/env bash

# Simple workspace notification control script
# Manages workspace notification tracking without complex CSS modifications

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
TRACKER="$SCRIPT_DIR/workspace-notifications.py"

case "${1:-}" in
    "on"|"enable"|"start")
        echo "Starting workspace notification tracking..."
        # Kill any existing tracker
        pkill -f "workspace-notifications.py watch" 2>/dev/null || true
        # Start new tracker in background
        nohup "$TRACKER" watch > /tmp/workspace-notifications.log 2>&1 &
        echo "Workspace notification tracking started (PID: $!)"
        ;;
    "off"|"disable"|"stop")
        echo "Stopping workspace notification tracking..."
        pkill -f "workspace-notifications.py watch" 2>/dev/null
        echo "Workspace notification tracking stopped"
        ;;
    "clear")
        echo "Clearing all workspace notifications..."
        "$TRACKER" clear-all
        ;;
    "test")
        echo "Adding test notification to current workspace..."
        "$TRACKER" test
        echo "Test notification added"
        ;;
    "status")
        echo "Current workspace notification status:"
        "$TRACKER" status
        ;;
    "add")
        workspace="${2:-}"
        if [[ -n "$workspace" ]]; then
            echo "Adding notification to workspace $workspace..."
            "$TRACKER" add "$workspace"
        else
            echo "Adding notification to current workspace..."
            "$TRACKER" add
        fi
        ;;
    "clear-workspace")
        workspace="$2"
        if [[ -z "$workspace" ]]; then
            echo "Usage: $0 clear-workspace <workspace_number>"
            exit 1
        fi
        echo "Clearing notifications for workspace $workspace..."
        "$TRACKER" clear "$workspace"
        ;;
    *)
        echo "Usage: $0 {on|off|clear|test|status|add|clear-workspace}"
        echo ""
        echo "Commands:"
        echo "  on/start           - Start workspace notification tracking"
        echo "  off/stop           - Stop workspace notification tracking"
        echo "  clear              - Clear all workspace notifications"
        echo "  test               - Add test notification to current workspace"
        echo "  status             - Show current notification status"
        echo "  add [workspace]    - Add notification to workspace (current if not specified)"
        echo "  clear-workspace N  - Clear notifications for workspace N"
        exit 1
        ;;
esac
