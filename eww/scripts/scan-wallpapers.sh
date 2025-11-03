#!/bin/sh
# Use a dedicated eww wallpapers directory if it exists, otherwise use main directory
if [ -d "$HOME/Pictures/wallpapers/eww" ]; then
    WALLPAPER_DIR="$HOME/Pictures/wallpapers/eww"
else
    WALLPAPER_DIR="$HOME/Pictures/wallpapers"
fi

PAGE_SIZE=2
PAGE=${1:-0}

# Cache file location
CACHE_FILE="/tmp/eww-wallpapers-cache"
CACHE_AGE=300  # 5 minutes

# Generate or use cached wallpaper list
if [ ! -f "$CACHE_FILE" ] || [ $(( $(date +%s) - $(stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0) )) -gt $CACHE_AGE ]; then
    find "$WALLPAPER_DIR" -type f \
        -regex '.*\.\(jpg\|jpeg\|png\|bmp\|gif\|tif\|tiff\)$' \
        -printf '%p\n' | sort -V > "$CACHE_FILE"
fi

# Read from cache
WALLPAPERS=$(cat "$CACHE_FILE")
TOTAL=$(echo "$WALLPAPERS" | wc -l)
TOTAL_PAGES=$(( (TOTAL + PAGE_SIZE - 1) / PAGE_SIZE ))

# Get wallpapers for current page
START=$((PAGE * PAGE_SIZE))
WALLPAPERS_PAGE=$(echo "$WALLPAPERS" | sed -n "$((START + 1)),$((START + PAGE_SIZE))p")

# Build JSON array (keep your existing JSON building code)
JSON="{"
JSON="$JSON\"wallpapers\":["
FIRST=true
while IFS= read -r wallpaper; do
    [ -z "$wallpaper" ] && continue
    
    if [ "$FIRST" = true ]; then
        FIRST=false
    else
        JSON="$JSON,"
    fi
    
    ESCAPED_PATH=$(echo "$wallpaper" | sed 's/"/\\"/g')
    BASENAME=$(basename "$wallpaper")
    ESCAPED_NAME=$(echo "$BASENAME" | sed 's/"/\\"/g')
    
    JSON="$JSON{\"path\":\"$ESCAPED_PATH\",\"name\":\"$ESCAPED_NAME\"}"
done <<< "$WALLPAPERS_PAGE"

JSON="$JSON],"
JSON="$JSON\"page\":$PAGE,"
JSON="$JSON\"total_pages\":$TOTAL_PAGES,"
JSON="$JSON\"total\":$TOTAL"
JSON="$JSON}"

echo "$JSON"
