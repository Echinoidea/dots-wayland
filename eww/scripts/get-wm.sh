#!/bin/sh
fastfetch --structure WM | grep -oP ': \K.*'
