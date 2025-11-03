#!/bin/sh

WALLPAPER_PATH="$1"
COLORSPACE="${2:-lab}"
PALETTE="${3:-dark}"
LIGHT_MODE="${4:-false}"

# Validate inputs
if [ -z "$WALLPAPER_PATH" ] || [ ! -f "$WALLPAPER_PATH" ]; then
    notify-send -u critical "Wallpaper Error" "Invalid wallpaper path"
    exit 1
fi

# Build wallust command
CMD="wallust run \"$WALLPAPER_PATH\" --colorspace $COLORSPACE --palette $PALETTE"

# # Add light mode flag if needed
# if [ "$LIGHT_MODE" = "true" ]; then
#     CMD="$CMD -l"
# fi

# Run wallust
eval $CMD;
# Set wallpaper with swww
echo "$WALLPAPER_PATH"
swww img "$WALLPAPER_PATH" --transition-fps 180

# Run postrun script
"$HOME/.config/wal/postrun"

# Send notification
BASENAME=$(basename "$WALLPAPER_PATH")
DIRNAME=$(dirname "$WALLPAPER_PATH" | xargs basename)
notify-send -t 3000 "Wallpaper Set" "$DIRNAME/$BASENAME\nPalette: $PALETTE | Colorspace: $COLORSPACE"

# Close the wallpaper picker
# eww update show_wallpaper_picker=false
# eww close wallpaper-picker-window
