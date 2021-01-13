#!/bin/sh

class=$(playerctl metadata --player=spotify --format '{{lc(status)}}')
#class=$(mpc status | awk '{if (NR == 2) print $1}' | tr -d '[]')
icon=""

if [[ $class == "playing" ]]; then
  #info=$(mpc current)
  info=$(playerctl metadata --player=spotify --format '{{artist}} - {{title}}')
  if [[ ${#info} > 40 ]]; then
    info=$(echo $info | cut -c1-40)"..."
  fi
  text=$info" "$icon
elif [[ $class == "paused" ]]; then
  text=$icon
elif [[ $class == "" ]]; then
  text=""
fi

echo -e "{\"text\":\""$text"\", \"class\":\""$class"\"}"
