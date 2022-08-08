# Android / adb / etc related aliases + helpers.

# Android (ADB)
adb_all () {
  # execute adb command on all connected devices.
  adb devices | tail -n +2 | cut -sf -1 | xargs -I X adb -s X $@
}
alias adba=adb_all
alias adba-clear="adb_all shell pm clear ${ANDROID_PKG:-$1}"
alias adba-start="adba shell am start ${ANDROID_PKG:-$1}/.MainActivity"
alias adba-rm="adba shell uninstall ${ANDROID_PKG:-$1}"
alias adba-ls="adb_all shell list packages -3"

# ADB Event Replay
adb-rec() {
  record_path="${@: -1}"
  adb_args="${@: 1:-1}"
  echo "Recording events to: $record_path"
  echo $adb_args
  adb $adb_args shell getevent | grep --line-buffered ^/ | tee "$record_path"
}

adb-replay() {
  record_path="${@: -1}"
  adb_args="${@: 1:-1}"
  awk '{printf "%s %d %d %d\n", substr($1, 1, length($1) -1), strtonum("0x"$2), strtonum("0x"$3), strtonum("0x"$4)}' $record_path | xargs -l adb $adb_args shell sendevent
}

# Android Sim
androidsim () {
    local APP_ID
    if [[ $1 == "-c" ]]; then
        printf "Clearing App Data... \n"
        APP_ID="${ANDROID_APP_ID:-${$?You must set or provide an app id!}}"
        adb shell pm clear $
        printf "App Data Cleared \n"
    else
        printf "Starting Emulator... \n"
	if ! type optirun 2>/dev/null; then
        	emulator -netdelay none -netspeed full -gpu host -accel on -avd Pixel2_29
	else
		optirun emulator -netdelay none -netspeed full -gpu host -accel on -avd Nexus_28
	fi
    fi
}
