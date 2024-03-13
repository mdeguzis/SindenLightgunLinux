#!/bin/bash

main () {
	cd /opt/sinden-lightgun
	echo "[INFO] Calibrating Sinden lightgun"
	sleep 2
	sudo mono-service LightgunMono.exe sdl steam joystick
	if [[ $? -eq 0 ]]; then
		echo "Calibration complete"
	else    
		echo "Failed to calibrate Sinden lighgun!" 
	fi
}
main 2>&1 | tee -a "/tmp/sinden-lightgun.log"

