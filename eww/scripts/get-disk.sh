#!/bin/sh
fastfetch --structure Disk | grep -oP ': \K.*' 
