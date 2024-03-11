#!/bin/bash
# Description: This script launches any of the Windows EXE's with Wine

WINDOWS_EXE=$1
APP_ROOT="${HOME}/Applications"
PREFIX="${HOME}/software/sinden/pfx"
mkdir -p "${APP_ROOT}"
mkdir -p "${PREFIX}"

# Env
export WINEARCH="win64"
export WINEPREFIX=${PREFIX}
export WINEDEBUG=-all
unset DISPLAY

if ! which wine &> /dev/null; then
	echo "[INFO] Wine seems to be missing. Did you run the setup already?"
	exit 1
fi

echo -e "\n[INFO] Creating Wineprefix at ${PREFIX}"
wine sh "[INFO] Creating prefix..."

# Install winetricks bits
# Per https://www.sindenwiki.org/wiki/Sinden_Troubleshooting#Unhandled_Exception_Errors, it's likely we 
# need Visual C++ and .NET Framework 
# https://github.com/Winetricks/winetricks
echo -e "\n[INFO] Installing dependencies into Proton prefix"
winetricks vcrun2019 dotnet48
exit 0

# Run the windows EXE with the prefix
echo "[INFO] Executing '${WINDOWS_EXE}' with Proton"
WINEPREFIX=${PREFIX} ${PROTON_APPIMAGE} "${WINDOWS_EXE}"
echo "[INFO] Done!"
