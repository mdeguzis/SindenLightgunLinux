#!/bin/bash
cd "${HOME}/software/sinden"

# Prefer Proton AppImage route, mono is glitchy for this use-case
mono-service LightgunMono.exe joystic
exit

