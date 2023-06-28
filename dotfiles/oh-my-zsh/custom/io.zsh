# IO related items.

# Frequent lsof aliases

## Kill process(es) listening on tcp port
kill-port() {
  sudo lsof -t -i tcp:$1 | xargs kill -9
}

## List processes listening on a tcp port
list-port() {
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
