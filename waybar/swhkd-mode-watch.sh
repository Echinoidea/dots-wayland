#!/usr/bin/env sh

MODE_FILE="$HOME/.config/waybar/swhkd-mode"

[ ! -f "$MODE_FILE" ] && echo -n "normal" > "$MODE_FILE"

# Initial output
cat "$MODE_FILE"
echo ""  # Important: newline for waybar

# Watch and output on changes
inotifywait -m -e close_write "$MODE_FILE" 2>/dev/null | while read; do
    cat "$MODE_FILE"
    echo ""  # Important: newline for waybar
done
