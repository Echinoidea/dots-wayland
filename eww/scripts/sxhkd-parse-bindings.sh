#!/usr/bin/env bash

# Parse sxhkd config and extract keychords for a given mode
# Usage: ./sxhkd-parse-bindings.sh <mode>

MODE="${1:-normal}"

# Manually define mode bindings based on your sxhkdrc
# This is cleaner than parsing since sxhkd doesn't have structured modes
case "$MODE" in
    "space")
        # After pressing super + space, show available second keys
        cat <<EOF
{"bindings":[
  {"key": "d", "desc": "+dmenu"},
  {"key": "e", "desc": "+emacs"},
  {"key": "l", "desc": "+layout"},
  {"key": "o", "desc": "+open"},
  {"key": "y", "desc": "+dirvish"}
]}
EOF
        ;;
    "d")
        # dmenu submenu
        cat <<EOF
{"bindings":[
  {"key": "t", "desc": "todo"},
  {"key": "m", "desc": "mpc"},
  {"key": "p", "desc": "power"},
  {"key": "c", "desc": "config"},
  {"key": "w", "desc": "wallpaper"},
  {"key": "r", "desc": "record"},
  {"key": "g", "desc": "goto window"},
  {"key": "b", "desc": "books"},
  {"key": "a", "desc": "soundcard"},
  {"key": "e", "desc": "+emacs"},
  {"key": "n", "desc": "notes"},
  {"key": "Print", "desc": "screenshot"}
]}
EOF
        ;;
    "e")
        # emacs submenu
        cat <<EOF
{"bindings":[
  {"key": "a", "desc": "org agenda"},
  {"key": "c", "desc": "calendar"},
  {"key": "u", "desc": "url"}
]}
EOF
        ;;
    "l")
        # layout submenu
        cat <<EOF
{"bindings":[
  {"key": "t", "desc": "tall layout"},
  {"key": "w", "desc": "wide layout"},
  {"key": "e", "desc": "even layout"},
  {"key": "g", "desc": "grid layout"},
  {"key": "k", "desc": "tiled layout"}
]}
EOF
        ;;
    "o")
        # open submenu
        cat <<EOF
{"bindings":[
  {"key": "e", "desc": "emacs"},
  {"key": "f", "desc": "firefox"},
  {"key": "d", "desc": "discord"},
  {"key": "m", "desc": "music"}
]}
EOF
        ;;
    "y")
        # dirvish submenu
        cat <<EOF
{"bindings":[
  {"key": "w", "desc": "wallpapers"},
  {"key": "d", "desc": "documents"},
  {"key": "p", "desc": "pictures"},
  {"key": "b", "desc": "books"},
  {"key": "v", "desc": "videos"}
]}
EOF
        ;;
    *)
        # Normal mode or unknown - no bindings to show
        echo '{"bindings":[]}'
        ;;
esac
