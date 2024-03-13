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
	return_code=$?
	if [[ ${return_code} -ne 0 ]]; then
		echo "[ERROR] Command failed: 'mono-service LightgunMono.exe joystick'"
	else
		echo "[INFO] Sinden USB device successfully started at $(date)"
	fi
	echo "[INFO] Return code was ${return_code}"
	exit
}
main 2>&1 | tee -a "/tmp/sinden-lightgun.log"

