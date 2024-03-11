#!/bin/bash

set -e -o pipefail

echo "[INFO] Configuring/calibrating lightgun"
cd ${HOME}/software/sinden

# Prefer using Proton, mono is glitchy...
#mono LightgunMono.exe steam joystick sdl
./launch-with-proton.sh windows-binaries/Lightgun.exe steam joystick sdl
