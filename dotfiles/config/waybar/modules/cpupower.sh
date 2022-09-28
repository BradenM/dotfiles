#!/usr/bin/env bash

text=""
class=""

get_current() {
  cpupower frequency-info --proc | awk -F'-' '/CPU  0/ {print $3}' | sed 's/ //g'
}

current="$(get_current)"

if [[ "$current" = "powersave" ]]; then
  text=" powersave"
  class="critical"
fi


echo -e "{\"text\":\""$text"\", \"class\":\""$class"\"}"
