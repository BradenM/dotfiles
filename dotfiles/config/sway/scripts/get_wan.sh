#!/usr/bin/env bash
# Get WAN IP Address

# Speedtest
speedtest_host="www.google.com"

# Get State
if [ -f "/tmp/get_wan.dat" ]; then
    exit
else
    echo 1 >/tmp/get_wan.dat
    while [ 1 ]; do
        wanip=$(curl -s -X GET https://checkip.amazonaws.com)
        echo "$wanip" >/tmp/swaybar_wanip
        current_ping=$(ping -c 1 $speedtest_host | tail -1 | awk '{print $4}' | cut -d '/' -f 2 | cut -d '.' -f 1)
        echo "$current_ping" >/tmp/swaybar_curping
        sleep 60
    done
fi

rm /tmp/get_wan.dat
