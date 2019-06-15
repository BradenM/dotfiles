#!/usr/bin/env bash

# Get State
if [ ! -f "/tmp/kitty_active.dat" ] ; then
  KITTY_ACTIVE='0'
else
  KITTY_ACTIVE=`cat /tmp/kitty_active.dat`
fi

pids=()
pids=(`ps -ef | grep kitty | awk '{print $2}'`)
if [ "${#pids[@]}" -eq '3' ]; then 
    echo "Starting kitty"
    kitty -o allow_remote_control=yes --listen-on=unix:@mykitty --detach
else
    if test ! "$KITTY_ACTIVE" == '1'; then
        echo "Focusing kitty"
        kitty @ --to=unix:@mykitty focus-window --match env:KITTY_WINDOW_ID=1
        KITTY_ACTIVE='1'
    else
        echo "Focusing code"
        wmctrl -v -R code
        KITTY_ACTIVE='0'
    fi
fi

# Update
echo "${KITTY_ACTIVE}" > /tmp/kitty_active.dat
