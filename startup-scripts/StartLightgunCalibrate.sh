#!/bin/bash
cd "${HOME}/software/sinden"

echo "[INFO] Calibrating Sinden lightgun"
sleep 2
mono-service LightgunMono.exe sdl steam joystick
if [[ $? -eq 0 ]]; then
        echo "Calibration complete"
else    
        echo "Failed to calibrate Sinden lighgun!" 
fi
exit

