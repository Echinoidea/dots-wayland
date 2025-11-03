#!/bin/sh

FILE=$(GTK_THEME=Adwaita:dark yad --file \
    --title="Select Wallpaper" \
    --filename="$HOME/Pictures/wallpapers/" \
    --file-filter="Images | *.jpg *.jpeg *.png *.bmp *.gif *.tif *.tiff" \
    --width=800 \
    --height=600 \
    2>/dev/null)

# Remove trailing newline and pipe character if present
FILE=$(echo "$FILE" | tr -d '\n' | sed 's/|$//')

# Update eww if file was selected and exists
if [ -n "$FILE" ] && [ -f "$FILE" ]; then
    eww update selected_wallpaper="$FILE"
    echo "Selected: $FILE"
fi
