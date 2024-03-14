#!/bin/bash

set -e -o pipefail

main() {
	echo "[INFO] Configuring/calibrating lightgun"
	cd /opt/sinden-lightgun
	# Stop systemd service before starting this, as it conflicts with 
	echo "[INFO] Halting systemd service to start configuration"
	sudo systemctl stop sinden-lightgun.service
	mono LightgunMono.exe steam joystick sdl
	echo "[INFO] Starting systemd service for Sinden lightgun"
	sudo systemctl start sinden-lightgun.service
}
main 2>&1 | tee -a "/tmp/sinden-lightgun.user.log"

