#!/usr/bin/env sh
MODE_FILE="$HOME/.config/waybar/swhkd-mode"
[ ! -f "$MODE_FILE" ] && echo -n "normal" > "$MODE_FILE"

# Ignore SIGPIPE - just silently stop writing on broken pipe
trap '' PIPE

# Initial output
cat "$MODE_FILE"
echo ""

# Watch and output on changes
inotifywait -m -e close_write "$MODE_FILE" 2>/dev/null | while read; do
    cat "$MODE_FILE"
    echo ""
done
