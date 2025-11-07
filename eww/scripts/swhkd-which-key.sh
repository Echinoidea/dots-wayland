#!/bin/sh

# Path to the swhkd mode file and config
SWHKD_MODE_FILE="$HOME/.config/waybar/swhkd-mode"
SWHKDRC="$HOME/.config/swhkd/swhkdrc"

# Function to parse keybindings for a given mode
parse_keys() {
    MODE="$1"
    
    # If mode is "normal" or empty, output empty JSON
    if [ "$MODE" = "normal" ] || [ "$MODE" = "swhkd off" ] || [ -z "$MODE" ]; then
        echo '{"bindings":[]}'
        return
    fi
    
    # Parse the mode block and extract keybindings
    awk -v mode="$MODE" '
    BEGIN {
        in_mode = 0
        print "{\"bindings\":["
        first = 1
        last_comment = ""
    }
    # Match mode declaration
    /^mode / {
        if ($2 == mode) {
            in_mode = 1
        }
    }
    # Match endmode
    /^endmode/ {
        if (in_mode) {
            in_mode = 0
            exit
        }
    }
    # Capture comments when in mode
    in_mode && /^#/ {
        last_comment = $0
        sub(/^#[ \t]*/, "", last_comment)
        next
    }
    # When in the right mode, capture key and description
    in_mode && /^[^#\t ]/ && !/^mode/ && !/^endmode/ {
        # This is a key binding line
        key = $0
        gsub(/^[ \t]+|[ \t]+$/, "", key)
        
        # Use the last comment as description if available
        if (last_comment != "") {
            description = last_comment
            last_comment = ""
        } else {
            # Read next line to get command
            getline
            desc = $0
            
            # Try to extract a meaningful description from the command
            # Skip echo commands and look for actual commands
            if (match(desc, /emacsclient/)) {
                description = "emacs"
            } else if (match(desc, /dmenu-/)) {
                match(desc, /dmenu-[^.]+/)
                description = substr(desc, RSTART, RLENGTH)
                gsub(/dmenu-/, "", description)
            } else if (match(desc, /@enter ([^ ]+)/, arr)) {
                description = "enter " arr[1]
            } else if (match(desc, /@escape/)) {
                description = "escape/exit"
            } else {
                # Simplify command
                description = desc
                gsub(/^[ \t]+|[ \t]+$/, "", description)
                # Remove echo commands
                gsub(/&& echo.*$/, "", description)
                gsub(/echo.*&&/, "", description)
                gsub(/^[ \t]+|[ \t]+$/, "", description)
                if (length(description) > 30) {
                    description = substr(description, 1, 27) "..."
                }
            }
        }
        
        # Output JSON object
        if (!first) print ","
        first = 0
        printf "  {\"key\":\"%s\",\"desc\":\"%s\"}", key, description
    }
    END {
        print "\n]}"
    }
    ' "$SWHKDRC"
}

# Function to handle mode changes
handle_mode_change() {
    current_mode=$(cat "$SWHKD_MODE_FILE" 2>/dev/null || echo "normal")
    
    if [ "$current_mode" = "normal" ] || [ "$current_mode" = "swhkd off" ]; then
        eww close which-key-popup-edp1 2>/dev/null
        eww close which-key-popup-dp1 2>/dev/null
    else
        eww update swhkd_keys="$(parse_keys "$current_mode")" 2>/dev/null
        eww open which-key-popup-edp1 2>/dev/null
        eww open which-key-popup-dp1 2>/dev/null
    fi
}

# Initial check
handle_mode_change

# Watch for changes
inotifywait -m -e modify "$SWHKD_MODE_FILE" 2>/dev/null | while read -r _; do
    handle_mode_change
done
