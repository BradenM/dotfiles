#!/usr/bin/env bash
# Get Weather

# Get State
if [ -f "/tmp/get_weather.dat" ]; then
    exit
else
    echo 1 >/tmp/get_weather.dat
    while [ 1 ]; do
        weather=$(curl -Ss 'https://wttr.in/Pontevedra?0&T&Q&format=1')
        echo "$weather" >/tmp/swaybar_weather
        sleep 60
    done
fi

rm /tmp/get_weather.dat
