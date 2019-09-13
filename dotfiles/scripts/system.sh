#!/usr/bin/env bash

# system.sh
# Various System Related Functions

# Refresh Icon Cache
refresh_app_icons() {
    local root=(`sudo find /usr/share/icons -name "*.cache" -exec dirname {} \;`)
    local usr=(`find ~/.local -name "*.cache" -exec dirname {} \;`)
    local paths=("${root[@]}" "${usr[@]}")
    for p in $paths; do
        local base=`basename $p`
        printf "Clearing ${base} Icons...\n"
        sudo gtk-update-icon-cache -f -t $p/*
        gtk-update-icon-cache ~/.local/share/icons/hicolor/**/* -t -f
        update-mime-database ~/.local/share/mime
        update-desktop-database ~/.local/share/applications
        sudo update-mime-database /usr/share/mime
        sudo update-desktop-database /usr/share/applications
        xdg-desktop-menu forceupdate
        printf "\n"
    done
    printf "Done. Refresh your session now please.\n"

}

# Set CPU Freq Energy Perf Pref
cpu_energy () {
  CURRENT=$(cat /sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference | head -n1)
  OPTIONS=("balance_power" "power" "performance")
  BOLT="${BRIGHT}${YELLOW}🗲 ${NORMAL}"
  SET_PERF=""
  for arg in "$@"
  do
    case $arg in
     "performance" ) SET_PERF=$OPTIONS[3];;
     "perf" ) SET_PERF=$OPTIONS[3];;
     "power" ) SET_PERF=$OPTIONS[2];;
     "pwr" ) SET_PERF=$OPTIONS[2];;
     "balance" ) SET_PERF=$OPTIONS[1];;
     "balance_power" ) SET_PERF=$OPTIONS[1];;
    esac
  done

  if [ $SET_PERF ]; then 
    printf "\n${BOLT}${POWDER_BLUE} Updating CPU Energy Preference ${MAGENTA}(${CURRENT} => ${SET_PERF})${NORMAL}\n"
    echo $SET_PERF | sudo tee /sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference
    CURRENT=$(cat /sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference | head -n1)
  fi
  printf "\n ${BOLT} ${GREEN}Active Energy Preference: ${NORMAL}${CURRENT}\n"

  unset CURRENT SET_PERF OPTIONS
}

# Kill process on port
kill-port () {
    sudo lsof -t -i tcp:$1 | xargs kill
}

# List Processes on a Port
list-port () {
    sudo lsof -i :$1
}

# List USB Devices
list-usb() {
        for sysdevpath in $(find /sys/bus/usb/devices/usb*/ -name dev); do
                syspath="${sysdevpath%/dev}"
                devname="$(udevadm info -q name -p $syspath)"
                [[ "$devname" == "bus/"* ]] && continue
                eval "$(udevadm info -q property --export -p $syspath)"
                [[ -z "$ID_SERIAL" ]] && continue
                echo "/dev/$devname - $ID_SERIAL"
        done
}

# Clear Font Cache
clear-fc-cache() {
	echo "Clearing Font Cache..."
	sudo fc-cache -rfv && fc-cache -rv
	echo "Font Cache Cleared. You should reboot soon!"
}
