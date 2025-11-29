#!/usr/bin/env bash

# Watch sxhkd status and update eww bindings accordingly
# This script reads the mode from sxhkd-status-watch.sh and updates eww

while IFS= read -r mode; do
    # Get bindings for current mode
    bindings=$(~/.config/eww/scripts/sxhkd-parse-bindings.sh "$mode")
    
    # Update BOTH eww variables
    eww update swhkd="$mode" || true
    eww update swhkd_keys="$bindings" || true
done < <(~/.config/eww/scripts/sxhkd-status-watch.sh)
