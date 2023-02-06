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

log_header() {
	local -A c
	local len line1len line2len bar
	make_colors c
	line1len=$(echo -n "$1" | wc -c)
	line2len=$(echo -n "$2" | wc -c)
	len=$line2len
	[ $line1len -gt $line2len ] && len=$line1len
	len=$((len + 2))
	bar=$(printf "%${len}s" | tr ' ' '*')
	echo "$bar" 1>&2
	echo -n " ${c[bright_white]}${1}${c[reset]} "
	[ "$2" ] && log_subtitle " ${c[white]}${c[dim]}$2${c[reset]} "
	echo "$bar" 1>&2
}
