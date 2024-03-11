#!/bin/bash

${HOME}/.local/bin/sindenlightgun-p2-remove.sh

cd LINUX_FILES
sudo mono LightgunMono2.exe sdl 30

${HOME}/.local/bin/sindenlightgun-p2-remove.sh
