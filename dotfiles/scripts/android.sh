#!/usr/bin/env bash

# android.sh
# Android sdk related functions

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
