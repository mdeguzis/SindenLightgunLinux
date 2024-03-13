#!/bin/bash

main () {
	cd "/opt/sinden-lightgun"
	echo "[INFO] Testing Sinden lightgun"
	sleep 2
	mono LightgunMono.exe sdl 30
	exit
}
main 2>&1 | tee -a "/tmp/sinden-lightgun.user.log"

