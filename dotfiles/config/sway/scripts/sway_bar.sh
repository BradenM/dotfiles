#!/usr/bin/env bash

# Change this according to your device
################
# Variables
################

# Start background scripts
/home/bradenmars/.config/sway/scripts/get_wan.sh &
/home/bradenmars/.config/sway/scripts/get_weather.sh &

# Keyboard input name
keyboard_input_name="6940:6968:ckb1:_Corsair_Gaming_K70_RGB_RAPIDFIRE_Keyboard_vKB"

# Date and time
# current_date=$(date "+%Y/%m/%d (w%-V)")
# current_date=$(date "+%Y/%m/%d")
current_date=$(date +"%a %b %m")
# current_time=$(date "+%H:%M")
current_time=$(date +"%I:%M %P (%H:%M)")

#############
# Commands
#############

# Battery or charger
# battery_charge=$(upower --show-info $(upower --enumerate | grep 'BAT') | egrep "percentage" | awk '{print $2}')
# battery_status=$(upower --show-info $(upower --enumerate | grep 'BAT') | egrep "state" | awk '{print $2}')
battery_charge="$(upsc ups battery.charge)%"
battery_status=""

# Audio and multimedia
audio_volume=$(pamixer --sink $(pactl list sinks short | grep RUNNING | awk '{print $1}') --get-volume)
audio_is_muted=$(pamixer --sink $(pactl list sinks short | grep RUNNING | awk '{print $1}') --get-mute)
media_artist=$(playerctl metadata artist)
media_song=$(playerctl metadata title)
player_status=$(playerctl status)
player_status=${player_status:-""}
audio_volume=$(pulseaudio-ctl | grep Volume | awk '{print $4}' | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g")

# Network
network=$(ip route get 1.1.1.1 | grep -Po '(?<=dev\s)\w+' | cut -f1 -d ' ')
# interface_easyname grabs the "old" interface name before systemd renamed it
# interface_easyname=$(dmesg | grep $network | grep renamed | awk 'NF>1{print $NF}')
interface_easyname="LAN"
# ping=$(ping -c 1 $speedtest_host | tail -1 | awk '{print $4}' | cut -d '/' -f 2 | cut -d '.' -f 1)
ping=$(cat /tmp/swaybar_curping)
interface_wan=$(cat /tmp/swaybar_wanip)

# Others
language=$(swaymsg -r -t get_inputs | awk '/1:1:AT_Translated_Set_2_keyboard/;/xkb_active_layout_name/' | grep -A1 '\b1:1:AT_Translated_Set_2_keyboard\b' | grep "xkb_active_layout_name" | awk -F '"' '{print $4}')
loadavg_5min=$(cat /proc/loadavg | awk -F ' ' '{print $2}')

# Removed weather because we are requesting it too many times to have a proper
# refresh on the bar
#weather=$(curl -Ss 'https://wttr.in/Pontevedra?0&T&Q&format=1')
weather=$(cat /tmp/swaybar_weather)

if [ $battery_status = "discharging" ]; then
    battery_pluggedin='⚠'
else
    battery_pluggedin='⚡'
fi

if ! [ $network ]; then
    network_active="⛔"
else
    network_active="⇆"
fi

if [ $player_status = "Playing" ]; then
    song_status='▶'
elif [ $player_status = "Paused" ]; then
    song_status='⏸'
else
    song_status='⏹'
fi

if [ $audio_is_muted = "true" ]; then
    audio_active='🔇'
else
    audio_active='🔊'
fi

echo "🎧 $song_status $media_artist - $media_song │ $network_active $interface_wan ($ping ms) │ 🏋 $loadavg_5min │ $audio_active $audio_volume% │ $battery_pluggedin $battery_charge │ $weather │ $current_date 🕘 $current_time"
