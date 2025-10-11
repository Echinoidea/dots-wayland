#!/usr/bin/env sh

swhks &
sleep 1
pkexec env XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR XDG_CONFIG_HOME=$XDG_CONFIG_HOME swhkd -c ~/.config/swhkd/swhkdrc
