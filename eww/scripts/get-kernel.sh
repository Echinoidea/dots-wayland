#!/bin/sh
fastfetch --structure Kernel | grep -oP ': \K.*'
