#!/usr/bin/env bash

###
## Create Screen Recording
###

output="/tmp/screenrecord_$(date +'%Y-%m-%dT%H-%M-%S').mp4"

wf-recorder -f "$output" -g "$(slurp)"
notify-send "Success!" "Screen recording saved to: $output"
