#!/usr/bin/env sh

# Terminate already running autotiling instances
killall -q swaywsr

# Wait until the processes have been shut down
while pgrep -x swaywsr >/dev/null; do sleep 1; done

# Launch
swaywsr -i awesome -c ~/.config/swaywsr/config.toml --no-names
