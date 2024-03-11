#!/bin/bash

${HOME}/.local/bin/sindenlightgun-p1-remove.sh

cd LINUX_FILES
sudo mono LightgunMono.exe sdl 30

${HOME}/.local/bin/sindenlightgun-p1-remove.sh
