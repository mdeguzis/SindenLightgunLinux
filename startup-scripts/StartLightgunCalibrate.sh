#!/bin/bash

main () {
	cd SOFTWARE_ROOT
	echo "[INFO] Calibrating Sinden lightgun"
	sleep 2
	mono-service LightgunMono.exe sdl steam joystick
	if [[ $? -eq 0 ]]; then
		echo "Calibration complete"
	else    
		echo "Failed to calibrate Sinden lighgun!" 
	fi
}
main 2>&1 | tee -a "/tmp/sinden-lightgun.log"

