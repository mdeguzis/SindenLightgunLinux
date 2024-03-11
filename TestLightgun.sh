#!/bin/bash
cd "${HOME}/software/sinden"

echo "[INFO] Testing Sinden lightgun"
sleep 2
mono LightgunMono.exe sdl 30
exit

