#!/usr/bin/env bash
# Scripts for wayland/sway

# Vars
ISO_DATE=$(date +"%Y-%m-%dT%H-%M-%S")

# Take Screenshot
sshot () {
  local file_name=${1="/tmp/screenshot_$ISO_DATE.png"}
  grim -g "$(slurp)" "$file_name"
  echo "Screenshot saved to: $file_name"
}

# Take video
srecord () {
  local file_name=${1="/tmp/recording_$ISO_DATE.mp4"}
  wf-recorder -f "${file_name}" -g "$(slurp)"
  echo "Recording saved to: $file_name"
}
