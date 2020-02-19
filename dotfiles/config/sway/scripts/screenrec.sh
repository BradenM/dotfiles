#!/usr/bin/env bash

###
## Create Screen Recording
###

output="/tmp/screenrecord_$(date +'%Y-%m-%dT%H-%M-%S').mp4"


swaymsg exec "swaynag -t warning -m 'Screen Recording Active: $output' -B 'End' '~/.config/sway/scripts/stopscreenrec.sh $output'"
wf-recorder -f "$output" -g "$(slurp)" &


