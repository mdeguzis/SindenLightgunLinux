#!/bin/bash
# Runs as root user (udev rule invocation)

main () {
	echo -e "\n============================================="
	echo "Sinden lightgun log (start action)"
	echo "Date: $(date)"
	echo "============================================="
	cd "SOFTWARE_ROOT"
	ls -la
	echo "[INFO] Executing Sinden lightgun script (Start) in SOFTWARE_ROOT"
	echo "[INFO] Sinden USB device added at $(date)"
	sleep 2
	echo "[INFO] Starting mono-service for Lightgun"
	mono LightgunMono.exe joystick
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

