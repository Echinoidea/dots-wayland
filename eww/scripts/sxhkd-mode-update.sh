#!/usr/bin/env bash

# Update the current mode and bindings
# Usage: ./sxhkd-mode-update.sh <mode>

MODE="$1"
FIFO="/tmp/sxhkd-status"
BINDINGS_FILE="/tmp/sxhkd-bindings.json"

# Ensure fifo exists
[[ -p $FIFO ]] || mkfifo "$FIFO"

# Write mode to fifo
echo "$MODE" > "$FIFO"

# Update bindings JSON
~/.config/eww/scripts/sxhkd-parse-bindings.sh "$MODE" > "$BINDINGS_FILE"

# Update eww variables
eww update swhkd="$MODE"
eww update swhkd_keys="$(cat $BINDINGS_FILE)"

# Auto-reset to normal after 3 seconds if not in normal mode
if [[ "$MODE" != "normal" ]]; then
    (sleep 3 && echo "normal" > "$FIFO" && \
     ~/.config/eww/scripts/sxhkd-parse-bindings.sh "normal" > "$BINDINGS_FILE" && \
     eww update swhkd="normal" && \
     eww update swhkd_keys="$(cat $BINDINGS_FILE)") &
fi
