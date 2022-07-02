#!/usr/bin/env sh

# Terminate already running autotiling instances
killall -q autotiling

# Wait until the processes have been shut down
while pgrep -x autotiling >/dev/null; do sleep 1; done

# Launch
autotiling
