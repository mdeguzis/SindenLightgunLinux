#!/bin/bash
# Runs as root user (udev rule invocation)

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
# For some reason mono-serviec won't start successfully here, use mono and update systemd service
#mono-service LightgunMono.exe joystick

# The Lightgun mono application still throws exit status 0 when it doesn't find a lightgun
# Check for active PID instead
mono LightgunMono.exe joystick
PID=$!
if [[ -z ${PID} ]]; then
	echo "[ERROR] Command failed: 'mono LightgunMono.exe joystick'"
	echo "[ERROR] Could not find PID for started process!"
	ps -auwwx | grep LightgunMono
	exit 1
else
	echo "[INFO] Sinden USB device successfully started at $(date)"
	echo "[INFO] PID: ${PID}"
	exit 0
fi

