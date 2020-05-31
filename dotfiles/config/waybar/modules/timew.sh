#!/usr/bin/env sh

icon=""

active="$(timew get dom.active)"
annotation=$(timew get dom.active.json | jq '.annotation' | tr -d '"')

text=""

if [[ ! -z "$annotation" ]]; then
    annotation="# $annotation"
fi

if [[ $active == "1" ]]; then
    tracking="$(timew | awk '/Tracking/{print $NF}')"
    duration="$(timew | awk '/Current/{print $NF}' | cut -d':' -f1,2 )"
    text="$icon $tracking $annotation  - $duration"
fi

# Return 
echo -e "{\"text\":\""$text"\"}"
