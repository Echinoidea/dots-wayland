#!/bin/sh

fastfetch --structure Packages | grep -oP '\d+(?= \()' | head -n 1
