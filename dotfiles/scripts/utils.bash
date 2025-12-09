#!/usr/bin/env bash

##
## Color utilities.
##

make_colors() {
	# shellcheck disable=SC2178
	local -n color="$1"

	[[ ${TERM} == "" ]] && export TERM="xterm-256color"
	[[ ${TERM} == "dumb" ]] && export TERM="xterm-256color"

	# foreground colors
	color["black"]=$(tput setaf 0)
	color["red"]=$(tput setaf 1)
	color["green"]=$(tput setaf 2)
	color["yellow"]=$(tput setaf 3)
	color["blue"]=$(tput setaf 4)
	color["magenta"]=$(tput setaf 5)
	color["cyan"]=$(tput setaf 6)
	color["white"]=$(tput setaf 7)
	color["bright_black"]=$(tput setaf 8)
	color["bright_red"]=$(tput setaf 9)
	color["bright_green"]=$(tput setaf 10)
	color["bright_yellow"]=$(tput setaf 11)
	color["bright_blue"]=$(tput setaf 12)
	color["bright_magenta"]=$(tput setaf 13)
	color["bright_cyan"]=$(tput setaf 14)
	color["bright_white"]=$(tput setaf 15)

	# modifiers
	color["bold"]=$(tput bold)
	color["dim"]=$(tput dim)
	color["under"]=$(tput smul)
	color["reset"]=$(tput sgr0)

	# aliases
	color["black_bold"]="${color['bold']}${color['black']}"
	color["red_bold"]="${color['bold']}${color['red']}"
	color["green_bold"]="${color['bold']}${color['green']}"
	color["yellow_bold"]="${color['bold']}${color['yellow']}"
	color["blue_bold"]="${color['bold']}${color['blue']}"
	color["magenta_bold"]="${color['bold']}${color['magenta']}"
	color["cyan_bold"]="${color['bold']}${color['cyan']}"
	color["white_bold"]="${color['bold']}${color['white']}"

	# todo: find and get rid of this.
	color["grey"]=$(tput setaf 0)
}

make_truecolors() {
	# shellcheck disable=SC2178
	local -n color="$1"

	[[ ${TERM} == "" ]] && export TERM="xterm-truecolor"
	[[ ${TERM} == "dumb" ]] && export TERM="xterm-truecolor"

	color_set() {
		printf "\033[38;2;%s;%s;%sm" "$1" "$2" "$3"
	}

	color["red"]=$(color_set 255 0 0)
	color["green"]=$(color_set 0 255 0)
	color["yellow"]=$(color_set 255 255 0)
	color["blue"]=$(color_set 0 0 255)
	color["magenta"]=$(color_set 255 0 255)
	color["cyan"]=$(color_set 0 255 255)
	color["white"]=$(color_set 255 255 255)
	color["black"]=$(color_set 0 0 0)
	color["bright_red"]=$(color_set 255 85 85)
	color["bright_green"]=$(color_set 85 255 85)
	color["bright_yellow"]=$(color_set 255 255 85)
	color["bright_blue"]=$(color_set 85 85 255)
	color["bright_magenta"]=$(color_set 255 85 255)
	color["bright_cyan"]=$(color_set 85 255 255)
	color["bright_white"]=$(color_set 255 255 255)

	color["bold"]=$(tput bold)
	color["dim"]=$(tput dim)
	color["under"]=$(tput smul)
	color["reset"]=$(tput sgr0)

	color["black_bold"]="${color['bold']}${color['black']}"
	color["red_bold"]="${color['bold']}${color['red']}"
	color["green_bold"]="${color['bold']}${color['green']}"
	color["yellow_bold"]="${color['bold']}${color['yellow']}"
	color["blue_bold"]="${color['bold']}${color['blue']}"
	color["magenta_bold"]="${color['bold']}${color['magenta']}"
	color["cyan_bold"]="${color['bold']}${color['cyan']}"
	color["white_bold"]="${color['bold']}${color['white']}"
}

fail() {
	local -A c
	make_colors c
	printf "%s%s%s\n" "${c['bright_red']}" "$*" "${c['reset']}" 1>&2
	exit 1
}

log_title() {
	local -A c
	make_colors c
	printf "\n%s%s%s\n" "${c['bright_white']}${c['under']}" "$*" "${c['reset']}" 1>&2
}

log_subtitle() {
	local -A c
	make_colors c
	printf "\n%s%s%s\n" "${c['white']}" "$*" "${c['reset']}" 1>&2
}

log_info() {
	local -A c
	make_colors c
	printf "%s%s%s\n" "${c['cyan']}" "$*" "${c['reset']}" 1>&2
}

log_success() {
	local -A c
	make_colors c
	printf "%s%s%s\n" "${c['bold']}${c['green']}" "$*" "${c['reset']}" 1>&2
}

log_debug() {
	local -A c
	make_colors c
	printf "%s%s%s\n" "${c[grey]}" "$*" "${c[reset]}" 1>&2
}

log_header() {
	local -A c
	local len line1len line2len bar
	make_colors c
	line1len=$(echo -n "$1" | wc -c)
	line2len=$(echo -n "$2" | wc -c)
	len=$line2len
	[ "$line1len" -gt "$line2len" ] && len=$line1len
	len=$((len + 2))
	bar=$(printf "%${len}s" | tr ' ' '*')
	echo "$bar" 1>&2
	echo -n " ${c[bright_white]}${1}${c[reset]} "
	[ "$2" ] && log_subtitle " ${c[white]}${c[dim]}$2${c[reset]} "
	echo "$bar" 1>&2
}

 do_confirm() {
 	 local msg
 	 msg="${1:-Confirm? (y/n): }"
 	 read -rp "$msg" yn
   case $yn in
       [Yy]* ) return;;
       [Nn]* ) exit;;
       * ) echo "Please answer yes or no.";;
   esac
 }
