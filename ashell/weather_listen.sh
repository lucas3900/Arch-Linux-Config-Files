#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="/home/lucas/.config/ashell"

# Output immediately on start, then continuously every 15 minutes
while true; do
    "$SCRIPT_DIR/weather.sh"
    # sleep 900
    sleep 600
done
