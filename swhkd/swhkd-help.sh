#!/usr/bin/env sh

CONFIG="$HOME/.config/swhkd/swhkdrc"
output=""
current_mode="normal"

while IFS= read -r line; do
    # Detect mode changes
    if [[ "$line" =~ ^mode\ ([a-z_]+) ]]; then
        current_mode="${BASH_REMATCH[1]}"
        continue
    fi
    
    # Detect end of mode
    if [[ "$line" =~ ^endmode ]]; then
        current_mode="normal"
        continue
    fi
    
    # Capture comments (descriptions)
    if [[ "$line" =~ ^#\ (.+) ]]; then
        description="${BASH_REMATCH[1]}"
        continue
    fi
    
    # Capture keybindings (lines that start with a key)
    if [[ "$line" =~ ^[a-zA-Z0-9{},._\ +@~-]+$ ]] && [[ ! "$line" =~ ^mode ]] && [[ ! "$line" =~ ^endmode ]]; then
        # Clean up the keybinding
        keybind=$(echo "$line" | xargs)
        
        # Skip lines that are commands (contain @enter, @escape, etc)
        if [[ "$keybind" =~ @(enter|escape) ]]; then
            continue
        fi
        
        # Add mode prefix if not in normal mode
        if [[ "$current_mode" != "normal" ]]; then
            display_key="[$current_mode] $keybind"
        else
            display_key="$keybind"
        fi
        
        # Add to output if we have a description
        if [[ -n "$description" ]]; then
            output+="$display_key\t$description\n"
            description=""
        fi
    fi
done < "$CONFIG"

# Display with fuzzel
echo -e "$output" | column -t -s $'\t' | fuzzel --dmenu --width 80 --lines 25
