#!/bin/bash
cd "${HOME}/software/sinden"

# Prefer Proton AppImage route, mono is glitchy for this use-case
#mono-service LightgunMono.exe sdl steam joystick
./launch-with-wine.sh windows-binaries/Lightgun.exe sdl steam joystick
exit

