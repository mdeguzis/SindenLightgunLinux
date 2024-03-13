#!/bin/bash

set -e -o pipefail

main() {
	echo "[INFO] Configuring/calibrating lightgun"
	cd /opt/sinden-lightgun
	mono LightgunMono.exe steam joystick sdl
}
main 2>&1 | tee -a "/tmp/sinden-lightgun.user.log"

