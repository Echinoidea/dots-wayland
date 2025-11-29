#!/usr/bin/env bash

# Watch sxhkd status FIFO and output mode for eww
# The FIFO path should match what sxhkd was started with

XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/1000}"
FIFO="$XDG_RUNTIME_DIR/sxhkd.fifo"

# Initial state
echo "normal"

# Read from the FIFO and parse keychord state
while IFS= read -r line; do
    # SXHKD outputs lines like:
    # H<hotkey>  - when a chord is being built (e.g., "Hsuper + space ")
    # B<message> - Begin chain message
    # E<message> - End chain message  
    # C<command> - Command being executed
    
    if [[ "$line" =~ ^H ]]; then
        # Extract the hotkey being built
        hotkey="${line#H}"
        
        # Parse the mode from the hotkey
        if [[ "$hotkey" =~ super\ \+\ space\ \;\ ([^\ ]+)\ \;\ ([^\ ]+) ]]; then
            # Third level chord: "super + space ; d ; e" -> mode "d-e"
            mode1="${BASH_REMATCH[1]}"
            mode2="${BASH_REMATCH[2]}"
            echo "$mode1-$mode2"
        elif [[ "$hotkey" =~ super\ \+\ space\ \;\ ([^\ ]+) ]]; then
            # Second level chord: "super + space ; d" -> mode "d"
            mode="${BASH_REMATCH[1]}"
            echo "$mode"
        elif [[ "$hotkey" =~ super\ \+\ space\ ?$ ]]; then
            # First level: just "super + space " pressed
            echo "space"
        fi
    elif [[ "$line" =~ ^B ]]; then
        # Begin chain - we're starting a keychord
        continue
    elif [[ "$line" =~ ^E ]] || [[ "$line" =~ ^C ]]; then
        # Command executed or chord ended - return to normal
        echo "normal"
    fi
done < "$FIFO"
