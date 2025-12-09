#!/usr/bin/env bash

##
## See:
##  https://wiki.archlinux.org/title/Power_management#SATA_Active_Link_Power_Management
##

while IFS= read -r i; do
	busdir=${i%/*}
	busnum=$(<"$busdir"/busnum)
	devnum=$(<"$busdir"/devnum)
	title=$(lsusb -s "$busnum":"$devnum")

	printf "\n\n+++ %s\n  -%s\n" "$title" "$busdir"

	while IFS= read -r ff; do
		v=$(cat "$ff" 2>/dev/null|tr -d "\n")
		[[ ${#v} -gt 0 ]] && echo -e " ${ff##*/}=$v";
		v=;
	done < <(find "$busdir"/power -type f ! -empty 2>/dev/null) | sort -g;
done < <(find /sys/devices -name "bMaxPower");

printf "\n\n\n+++ %s\n" "Kernel Modules"
for mod in $(lspci -k | sed -n '/in use:/s,^.*: ,,p' | sort -u)
do
	echo "+ $mod";
	systool -v -m "$mod" 2> /dev/null | sed -n "/Parameters:/,/^$/p";
done
