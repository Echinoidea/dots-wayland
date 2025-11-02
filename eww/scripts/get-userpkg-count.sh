#!/bin/sh

fastfetch --structure Packages | grep -oP '\d+(?= \()' | tail -n 1
