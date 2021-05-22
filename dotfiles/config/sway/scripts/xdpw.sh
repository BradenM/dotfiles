#!/usr/bin/env bash

# Terminate already running autotiling instances
#killall -q xdg-desktop-por

# Wait until the processes have been shut down
#while pgrep -x xdg-desktop-por >/dev/null; do sleep 1; done

# Launch
/usr/lib/xdg-desktop-portal -r & /usr/lib/xdg-desktop-portal-wlr

systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK
hash dbus-update-activation-environment 2>/dev/null
dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK


