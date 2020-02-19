#!/usr/bin/env bash

# File
path="$1"

# Terminate
killall -INT wf-recorder

# Wait
while pgrep -x wf-recorder >/dev/null; do sleep 1; done

# Notify
notify-send "Success!" "Screen recording saved to: $path"

# Play
mpv "$path"
