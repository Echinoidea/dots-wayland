#!/bin/sh

# Usage: ./workspace-monitor.sh <output-name>
# Example: ./workspace-monitor.sh DP-1

OUTPUT="${1:-eDP-1}"  # Default to eDP-1 if no argument provided

# Get workspaces for specific output and format for eww
format_workspaces() {
    niri msg --json workspaces | jq -c --arg output "$OUTPUT" '{
        workspaces: [.[] | select(.output == $output) | {
            idx: .idx,
            name: .name,
            is_active: .is_active,
            is_focused: .is_focused
        }] | sort_by(.idx)
    }'
}

# Initial output
format_workspaces

# Listen for changes
niri msg --json event-stream | jq --unbuffered -c '
    select(.WorkspaceActivated != null or .WorkspacesChanged != null)
' | while read -r event; do
    format_workspaces
done
