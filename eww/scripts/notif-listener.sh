#!/bin/sh

tiramisu -j | while read -r notification; do
    # Parse JSON notification
    app=$(echo "$notification" | jq -r '.app_name // "Notification"')
    summary=$(echo "$notification" | jq -r '.summary // ""')
    body=$(echo "$notification" | jq -r '.body // ""')
    
    # Escape quotes
    app="${app//\"/\\\"}"
    summary="${summary//\"/\\\"}"
    body="${body//\"/\\\"}"
    
    # Update eww
    eww update notif_app="$app"
    eww update notif_summary="$summary"
    eww update notif_body="$body"
    eww update notif_show=true
    
    # Auto-hide after 5 seconds
    (sleep 5 && eww update notif_show=false) &
done
