#!/bin/bash
cd "${HOME}/software/sinden"

echo "[INFO] Starting Sinden lightgun"
sleep 2
mono-service LightgunMono.exe joystic
exit

