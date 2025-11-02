#!/bin/sh
fastfetch --structure OS | grep -oP 'OS: \K.*'
