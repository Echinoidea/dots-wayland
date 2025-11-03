#!/bin/sh

LAST_PAGE=-1

while true; do
    CURRENT_PAGE=$(eww get wallpaper_page 2>/dev/null || echo "0")
    
    if [ "$CURRENT_PAGE" != "$LAST_PAGE" ]; then
        ~/.config/eww/scripts/scan-wallpapers.sh "$CURRENT_PAGE"
        LAST_PAGE=$CURRENT_PAGE
    fi
    
    sleep 0.5
done
