#!/bin/bash

main () {
	cd "${HOME}/software/sinden"
	echo "[INFO] Calibrating Sinden lightgun"
	sleep 2
	mono-service LightgunMono.exe sdl steam joystick
	if [[ $? -eq 0 ]]; then
		echo "Calibration complete"
	else    
		echo "Failed to calibrate Sinden lighgun!" 
	fi
	exit
}
main 2>&1 | tee -a "/tmp/sinden-lightgun.log"

