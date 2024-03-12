#!/bin/bash

main () {
	cd "${HOME}/software/sinden"
	echo "[INFO] Testing Sinden lightgun"
	sleep 2
	mono LightgunMono.exe sdl 30
	exit
}
main 2>&1 | tee -a "/tmp/sinden-lightgun.log"

