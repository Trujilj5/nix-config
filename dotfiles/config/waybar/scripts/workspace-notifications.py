#!/usr/bin/env python3

import json
import subprocess
import sys
import time
from collections import defaultdict
from pathlib import Path

class WorkspaceNotificationTracker:
    def __init__(self):
        self.notifications_per_workspace = defaultdict(int)
        self.current_workspace = 1
        self.state_file = Path("/tmp/waybar-workspace-notifications.json")
        self.load_state()

    def load_state(self):
        """Load notification state from file"""
        try:
            if self.state_file.exists():
                with open(self.state_file, 'r') as f:
                    data = json.load(f)
                    self.notifications_per_workspace = defaultdict(int, data.get('notifications', {}))
        except Exception:
            pass

    def save_state(self):
        """Save notification state to file"""
        try:
            data = {
                'notifications': dict(self.notifications_per_workspace),
                'current_workspace': self.current_workspace
            }
            with open(self.state_file, 'w') as f:
                json.dump(data, f)
        except Exception:
            pass

    def get_current_workspace(self):
        """Get current workspace from Hyprland"""
        try:
            result = subprocess.run(
                ['hyprctl', 'activewindow', '-j'],
                capture_output=True, text=True, check=True
            )
            data = json.loads(result.stdout)
            return str(data.get('workspace', {}).get('id', 1))
        except Exception:
            return "1"

    def add_notification(self, workspace=None):
        """Add a notification to a workspace"""
        if workspace is None:
            workspace = self.get_current_workspace()

        self.notifications_per_workspace[workspace] += 1
        self.save_state()
        print(f"Added notification to workspace {workspace}")

    def clear_workspace(self, workspace):
        """Clear notifications for a workspace"""
        if workspace in self.notifications_per_workspace:
            del self.notifications_per_workspace[workspace]
            self.save_state()
            print(f"Cleared notifications for workspace {workspace}")

    def clear_all(self):
        """Clear all notifications"""
        self.notifications_per_workspace.clear()
        self.save_state()
        print("Cleared all notifications")

    def get_workspace_info(self):
        """Get workspace information for waybar"""
        current_ws = self.get_current_workspace()

        # Create output for each workspace
        workspaces = []
        for i in range(1, 11):  # Support workspaces 1-10
            ws_str = str(i)
            notification_count = self.notifications_per_workspace.get(ws_str, 0)

            workspace_info = {
                "id": i,
                "name": ws_str,
                "active": ws_str == current_ws,
                "notification_count": notification_count,
                "has_notifications": notification_count > 0
            }
            workspaces.append(workspace_info)

        return {
            "workspaces": workspaces,
            "current": current_ws,
            "total_notifications": sum(self.notifications_per_workspace.values())
        }

    def format_for_waybar(self):
        """Format output for waybar custom module"""
        info = self.get_workspace_info()

        # Simple text output showing notification counts
        parts = []
        for ws in info["workspaces"]:
            if ws["has_notifications"]:
                if ws["active"]:
                    parts.append(f"[{ws['id']}:{ws['notification_count']}]")
                else:
                    parts.append(f"{ws['id']}:{ws['notification_count']}")

        text = " ".join(parts) if parts else ""

        # Create tooltip
        tooltip_parts = []
        for ws in info["workspaces"]:
            if ws["has_notifications"]:
                tooltip_parts.append(f"Workspace {ws['id']}: {ws['notification_count']} notifications")

        tooltip = "\n".join(tooltip_parts) if tooltip_parts else "No notifications"

        output = {
            "text": text,
            "tooltip": tooltip,
            "class": "notifications" if parts else "no-notifications"
        }

        return json.dumps(output)

    def watch_notifications(self):
        """Watch for new notifications using swaync"""
        print("Starting notification watcher...")

        try:
            # Subscribe to swaync events
            proc = subprocess.Popen(
                ['swaync-client', '--subscribe'],
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True
            )

            for line in proc.stdout:
                try:
                    event = json.loads(line.strip())
                    if event.get('type') == 'notification':
                        # New notification received
                        current_ws = self.get_current_workspace()
                        self.add_notification(current_ws)

                        # Output current state for waybar
                        print(self.format_for_waybar(), flush=True)

                except json.JSONDecodeError:
                    continue
                except Exception as e:
                    print(f"Error processing event: {e}", file=sys.stderr)

        except KeyboardInterrupt:
            print("Stopping notification watcher...")
        except Exception as e:
            print(f"Error in notification watcher: {e}", file=sys.stderr)
            return 1

        return 0

def main():
    tracker = WorkspaceNotificationTracker()

    if len(sys.argv) < 2:
        print("Usage: workspace-notifications.py {watch|add|clear|clear-all|status}")
        return 1

    command = sys.argv[1]

    if command == "watch":
        return tracker.watch_notifications()

    elif command == "add":
        workspace = sys.argv[2] if len(sys.argv) > 2 else None
        tracker.add_notification(workspace)

    elif command == "clear":
        if len(sys.argv) < 3:
            print("Usage: workspace-notifications.py clear <workspace>")
            return 1
        tracker.clear_workspace(sys.argv[2])

    elif command == "clear-all":
        tracker.clear_all()

    elif command == "status":
        print(tracker.format_for_waybar())

    elif command == "test":
        # Add a test notification to current workspace
        tracker.add_notification()
        print("Added test notification to current workspace")

    else:
        print(f"Unknown command: {command}")
        return 1

    return 0

if __name__ == "__main__":
    sys.exit(main())
