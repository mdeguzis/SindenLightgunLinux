#!/bin/bash

cd SOFTWARE_ROOT
echo "[INFO] Calibrating Sinden lightgun"
sleep 2
# For some reason mono-serviec won't start successfully here, use mono and update systemd servic
#mono-service LightgunMono.exe sdl steam joystick

# The mono application will still toss exit code 0 when it does not find a lightgun
# Use PID to see if it ran ok for now
mono LightgunMono.exe sdl steam joystick
PID=$!
if [[ -z ${PID} ]]; then
	echo "[INFO] Calibration complete"
	echo "[INFO] PID: ${PID}"
	echo 
else    
	echo "[ERROR] Failed to calibrate Sinden lighgun!" 
	exit 1
fi

