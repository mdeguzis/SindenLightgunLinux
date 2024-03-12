#!/bin/bash

main() {
	cd "${HOME}/software/sinden"
	echo "[INFO] Starting Sinden lightgun"
	sleep 2
	mono-service LightgunMono.exe joystick
	if [[ $? -eq 0 ]]; then
		echo "started" > /tmp/sinden-lightgun.state
	else
		echo "Failed to start Sinden lighgun!"
	fi
	echo "Wrote state to /tmp/sinden-lightgun.state"
	exit
}
main 2>&1 | tee -a "/tmp/sinden-lightgun.log"

