#!/usr/bin/env bash

# Kill running polybar instances
killall -q polybar

# Wait until processes are gone
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.5; done

# Launch bar
polybar top &

echo "Polybar launched"
