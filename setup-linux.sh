#!/bin/bash

set -e -o pipefail

# https://sindenlightgun.com/drivers/
LINUX_VERSION="LinuxBeta2.05c.zip"
WINDOWS_VERSION="SindenLightgunWindowsSoftwareV2.05beta.zip"
GIT_ROOT=$(git rev-parse --show-toplevel)
SOFTWARE_ROOT="${HOME}/software/sinden"
TS=$(date +%s)
BIN_DIR="${HOME}/.local/bin"
CONFIG_BACKUP="${HOME}/.config/sinden/backups"

############################
# Pre-requisites
############################

# Get OS type
# This may not be needed anymore with how the Beta release works
OS_TYPE=$(cat /etc/*release* | awk -F'=' '/ID_LIKE/ {print $2}')
if [[ "${OS_TYPE}" == "arch" ]]; then
	OS_LIKE="arch"

elif [[ "${OS_TYPE}" =~ "debian" ]]; then
	OS_LIKE="debian"
fi

# Get Arch
# This may not be needed anymore with how the Beta release works
ARCH=$(uname -m)
if [[ "$ARCH" == *"arm"* ]]; then
    ARCH="Pi-ARM"
fi

# Cleanup anything from a previous install
rm -rf ${SOFTWARE_ROOT}

# Folders
mkdir -p ${BIN_DIR}
mkdir -p "${SOFTWARE_ROOT}"
mkdir -p "${CONFIG_BACKUP}"

# Linux Scripts
echo "[INFO] Copying Sinden software to ${SOFTWARE_ROOT}"
cp -v ${GIT_ROOT}/* "${SOFTWARE_ROOT}"
find "${SOFTWARE_ROOT}" -name "*.sh" -exec chmod +x {} \;

# Unlock the OS if we are using ChimeraOS/Steam Deck
if which frzr-unlock &> /dev/null; then
	echo "[INFO] unlocking immutable OS"
	sudo frzr-unlock
	sudo pacman-key --init
	sudo pacman-key --populate archlinux
elif which steamos-readonly &> /dev/null; then
	echo "[INFO] unlocking immutable OS"
	sudo frzr-unlock
	sudo steamos-readonly disable
	sudo pacman-key --init
	sudo pacman-key --populate holo
fi

# pre-req software
if [[ "${OS_TYPE}" == "arch" ]]; then
	echo "[INFO] Installing prerequisite packages for Arch Linux systems"
	sudo pacman -Sy --noconfirm mono sdl12-compat sdl_image sdl

elif [[ "${OS_TYPE}" =~ "debian" ]]; then
	echo "[INFO] Installing prerequisite packages for Debian-like systems"
	sudo pacman -Sy --noconfirm mono sdl12-compat sdl_image sdl
fi

# Relock OS if using SteamOS/Steam Deck
if which steamos-readonly &> /dev/null; then
	echo "[INFO] Relocking SteamOS"
	sudo steamos-readonly enable
fi

############################
# usermod
############################
# This is a bit hacky (from shipped the readme)
echo -e "\n[INFO] Configuring user groups"
group_found=0
for group in serial uucp uucm dialout;
do
	if groups | grep -q "${group}"; then
		echo "[INFO] Found group ${group}, adding ${USER} to it"
		usermod -a -G "${group}" "${USER}"
		group_found=1
	fi
done
if [[ ${group_found} -ne 1 ]]; then 
	echo "[WARN] Could not find a valid group to add ${USER} to"
fi

############################
# Borders
############################
echo -e "\nCopying Sinden Border Overlays for Retroarch"
if [[ -d "${HOME}/.var/app/org.libretro.RetroArch" ]]; then
	retroarch_overlays_dir=/"${HOME}/.var/app/org.libretro.RetroArch/config/retroarch/overlays"
else
	retroarch_overlays_dir="${HOME}/.config/retroarch/overlay"
fi
cp -v ${GIT_ROOT}/overlays/retroarch/* ${retroarch_overlays_dir}

# For the time being, assume ES-DE-compliant MAME dir
# This also assumes internal storage...TODO to fix this... or add more folder detection
echo -e "\nCopying Sinden Border Overlays for any available MAME systems"
if [[ -d "${HOME}/Emulation/roms/mame/" ]]; then
	cp -v ${GIT_ROOT}/overlays/mame/* "${HOME}/Emulation/roms/mame/"
fi


############################
# Finish
############################

echo -e "\n[INFO] Done!"
echo "[INFO] Now run ${SOFTWARE_ROOT}/configure-lightgun.sh to complete setup and calibration of the lightgun"
