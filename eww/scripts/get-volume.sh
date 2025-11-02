#!/bin/sh

get_volume() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}'
}

# Initial output
get_volume

# Use pw-mon to watch for property changes
pw-mon 2>/dev/null | grep --line-buffered -i "volume\|mute" | while read -r _; do
    get_volume
done
