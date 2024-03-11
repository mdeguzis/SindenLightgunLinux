#!/bin/bash
cd "${HOME}/software/sinden"

echo "[INFO] Calibrating Sinden lightgun"
sleep 2
mono-service LightgunMono.exe sdl steam joystick
exit

