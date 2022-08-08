# Sway related items.

# Take Screenshot
sshot () {
  local ISO_DATE=$(date +"%Y-%m-%dT%H-%M-%S")
  local file_name=${1="/tmp/screenshot_$ISO_DATE.png"}
  if [ "$1" = "-e" ]; then
	grim -g "$(slurp)" - | swappy -f -
  else
  	grim -g "$(slurp)" "$file_name"
	echo "Screenshot saved to: $file_name"
  fi
}


scolorpick() {
    result=$(grim -g "$(slurp -p)" -t ppm - | convert - -format '%[pixel:p{0,0}]' txt:- | tail -n 1 | cut -d ' ' -f 4)
    echo "Color: $result"
    wl-copy -n <<<"$result"
    echo "Copied to clipboard!"
}
