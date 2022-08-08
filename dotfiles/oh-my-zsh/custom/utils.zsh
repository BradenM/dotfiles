# Various utils for other shell scripts.

make_chars() {
  local -n chars="$1"
  chars['ARROW_RIGHT']="→"
  chars['ARROW_DBL_RIGHT']="⇒"
}


make_colors() {
  local -n color="$1"

  [[ ${TERM} == "" ]] && export TERM="xterm-256color"
  [[ ${TERM} == "dumb" ]] && export TERM="xterm-256color"

  color["red"]=$(tput setaf 1)
  color["green"]=$(tput setaf 2)
  color["cyan"]=$(tput setaf 6)
  color["bold"]=$(tput bold)
  color["dim"]=$(tput dim)
  color["under"]=$(tput smul)
  color["white"]=$(tput setaf 7)
  color["reset"]=$(tput sgr0)
  color["bright_white"]="${color['bold']}${color['white']}"
  color["bright_red"]="${color['bold']}${color['red']}"
}
