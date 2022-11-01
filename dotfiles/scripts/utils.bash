#!/usr/bin/env bash

##
## Color utilities.
##

make_colors() {
	local -n color="$1"

	[[ ${TERM} == "" ]] && export TERM="xterm-256color"
	[[ ${TERM} == "dumb" ]] && export TERM="xterm-256color"

	# foreground colors
	color["white"]=$(tput setaf 7)
	color["red"]=$(tput setaf 1)
	color["green"]=$(tput setaf 2)
	color["cyan"]=$(tput setaf 6)
	color["orange"]=$(tput setaf 4)
	color["magenta"]=$(tput setaf 9)

	# modifiers
	color["bold"]=$(tput bold)
	color["dim"]=$(tput dim)
	color["under"]=$(tput smul)
	color["reset"]=$(tput sgr0)

	# aliases
	color["bright_white"]="${color['bold']}${color['white']}"
	color["bright_red"]="${color['bold']}${color['red']}"
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
	printf "\n%s%s%s\n" "${c['bright_white']}${c['under']}" "$*" "${c['reset']}"
}

log_info() {
	local -A c
	make_colors c
	printf "%s%s%s\n" "${c['cyan']}" "$*" "${c['reset']}"
}

log_success() {
	local -A c
	make_colors c
	printf "%s%s%s\n" "${c['bold']}${c['green']}" "$*" "${c['reset']}"
}
