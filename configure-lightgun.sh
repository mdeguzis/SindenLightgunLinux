#!/bin/bash

set -e -o pipefail

echo "[INFO] Configuring/calibrating lightgun"
cd ${HOME}/software/sinden

function run_config () {
	rm -f "${HOME}/software/sinden/lightgun.configured"
	./launch-with-proton.sh windows-binaries/Lightgun.exe steam joystick sdl
	touch "${HOME}/software/sinden/lightgun.configured"
}

# If configured once already (use a touch file), skip / ask with Zenity
# This is good for users launching in SteamOS GameMode.
if [[ -f "${HOME}/software/sinden/lightgun.configured" ]]; then
	zenity --question --text "It appears the Sinden lightgun is already configured, configure again?"
	case $? in
		0)
			run_config
		;;
		1)
			return
		;;
	esac
else
	run_config
fi

# Prefer using Proton, mono is glitchy...
#mono LightgunMono.exe steam joystick sdl

