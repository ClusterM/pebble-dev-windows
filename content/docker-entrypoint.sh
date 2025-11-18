#!/usr/bin/sh

# Use STOP_AFTER in minutes, default 30
# Convert minutes to seconds
STOP_AFTER_MIN="${STOP_AFTER:-30}"
STOP_AFTER=$((STOP_AFTER_MIN * 60))

FILE="/tmp/pebble_flag"

# Touch the flag file before doing anything
touch "$FILE"

if [ "$#" -gt 0 ]; then
    # Fallback
    exec pebble "$@"
fi

echo Staring main loop, will stop after $STOP_AFTER_MIN mins of inactivity

# Main loop: run while file modification time is recent
while true; do
    # Get current timestamp
    now=$(date +%s)

    # Get file modification time
    mtime=$(stat -c %Y "$FILE" 2>/dev/null)

    # If file disappeared, stop
    if [ -z "$mtime" ]; then
        echo "Flag file not found, stopping..."
        break
    fi

    # Calculate age
    age=$((now - mtime))

    # Stop if file is too old
    if [ "$age" -ge "$STOP_AFTER" ]; then
        echo "Stopping due to inactivity"
        break
    fi

    sleep 1
done
