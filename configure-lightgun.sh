#!/bin/bash

set -e -o pipefail

echo "[INFO] Configuring/calibrating lightgun"
cd ${HOME}/software/sinden
mono LightgunMono.exe steam joystick sdl

