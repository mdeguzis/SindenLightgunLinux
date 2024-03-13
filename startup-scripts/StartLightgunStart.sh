#!/bin/bash

main () {
	echo -e "\n============================================="
	echo "Sinden lightgun log (start action)"
	echo "Date: $(date)"
	echo "============================================="
	cd "/opt/sinden-lightgun"
	echo "[INFO] Executing Sinden lightgun script (Start) in /opt/sidnen-lightgun"
	echo "[INFO] Sinden USB device added at $(date)"
	sleep 2
	echo "[INFO] Starting mono-service for Lightgun"
	sudo mono-service LightgunMono.exe joystick
	if [[ $? -ne 0 ]]; then
		echo "[ERROR] Command failed: 'mono-service LightgunMono.exe joystick'"
	fi
	echo "[INFO] Sinden USB device successfully started at $(date)"
	exit
}
main 2>&1 | tee -a "/tmp/sinden-lightgun.log"

