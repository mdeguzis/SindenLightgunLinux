#!/bin/bash

set -e -o pipefail

# https://sindenlightgun.com/drivers/
# For some reason, the main download is a different version at the moment (2024-06-09)
MAIN_VERSION="V2.07"
LINUX_VERSION="V2.05"
DOWNLOAD_URL="https://www.sindenlightgun.com/software/SindenLightgunSoftwareRelease${MAIN_VERSION}.zip"
GIT_ROOT=$(git rev-parse --show-toplevel)
SOFTWARE_ROOT="/opt/sinden-lightgun"
TS=$(date +%s)
BIN_DIR="${HOME}/.local/bin"
CONFIG_BACKUP="${HOME}/.config/sinden/backups"

set -e

############################
# Functions
############################
function install () {
	sudo rm -rf ${SOFTWARE_ROOT}
	sudo mkdir -p "${SOFTWARE_ROOT}"
	rm -rf /tmp/SindenLightgunLinux*
	echo "[INFO] Fetching Sinden software from ${DOWNLOAD_URL}"
	curl -Lo "/tmp/sinden-lightgun.zip" "${DOWNLOAD_URL}"
	unzip -o "/tmp/sinden-lightgun.zip" -d "/tmp"
	sudo cp -r ${GIT_ROOT}/* "${SOFTWARE_ROOT}"
	sudo cp /tmp/SindenLightgunLinuxSoftware${LINUX_VERSION}/SteamdeckVersion/Lightgun/*.so "${SOFTWARE_ROOT}"
	sudo cp /tmp/SindenLightgunLinuxSoftware${LINUX_VERSION}/SteamdeckVersion/Lightgun/LightgunMono* "${SOFTWARE_ROOT}"
	sudo chmod +x ${SOFTWARE_ROOT}/LightgunMono*
}

############################
# Pre-requisites
############################

if [[ -f "/etc/os-release" ]]; then
    OS_TYPE=$(cat "/etc/os-release" | awk -F'=' '/ID_LIKE/ {print $2}')
else
    OS_TYPE=$(uname -s)
fi

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

# Folders
mkdir -p ${BIN_DIR}
mkdir -p "${CONFIG_BACKUP}"

# Unlock the OS if we are using ChimeraOS/Steam Deck
if [[ -f "/usr/bin/frzr-unlock" ]]; then
	echo "[INFO] unlocking immutable OS"
	sudo frzr-unlock
	sudo pacman-key --init
	sudo pacman-key --populate archlinux

elif which steamos-readonly &> /dev/null; then
	echo "[INFO] unlocking immutable OS"
	sudo steamos-readonly disable
	sudo pacman-key --init
	sudo pacman-key --populate holo
fi


# Software license notes we cannot distribute the software
# Download from drivers page directly
if [[ -f "${SOFTWARE_ROOT}/LightgunMono.exe" ]]; then
    # Cleanup anything from a previous install
    read -erp "[INFO] It appears the software already exists, overwrite? (y/N): " reinstall
    if [[ "${reinstall}" == "y" ]]; then
        install
    fi
else
    install
fi

# Linux Scripts
echo "[INFO] Copying Sinden software to ${SOFTWARE_ROOT}"
sudo cp -r ${GIT_ROOT}/* "${SOFTWARE_ROOT}"
find "${SOFTWARE_ROOT}" -name "*.sh" -exec sudo chmod +x {} \;
find "${SOFTWARE_ROOT}" -name "*.sh" -exec sudo sed -i "s|SOFTWARE_ROOT|${SOFTWARE_ROOT}|g" {} \;

# Systemd
# Don't start the service during setup, as it will fail if the lightgun is not connected
# The udev rules will handlle this
echo "[INFO] Creating systemd service 'sinden-lightgun.service'"
sudo cp "${GIT_ROOT}/systemd/sinden-lightgun.service" "/usr/lib/systemd/system/"
sudo systemctl daemon-reload
sudo systemctl disable sinden-lightgun.service
sudo systemctl enable sinden-lightgun.service

echo "[INFO] Copying UDEV rules"
sudo cp "${GIT_ROOT}/udev/99-sinden.rules" "/etc/udev/rules.d/"
sudo sed -i "s|SOFTWARE_ROOT|${SOFTWARE_ROOT}|g" "/etc/udev/rules.d/99-sinden.rules"

# This part needs some work...
echo "[INFO] Reloading UDEV rules and service"
sudo udevadm control --reload-rules
sudo udevadm trigger

# pre-req software
if [[ "${OS_TYPE}" == "arch" ]]; then
	echo "[INFO] Installing prerequisite packages for Arch Linux systems"
	sudo pacman -Sy --noconfirm mono sdl12-compat sdl_image sdl

elif [[ "${OS_TYPE}" =~ "debian" ]]; then
	echo "[INFO] Installing prerequisite packages for Debian-like systems"
	sudo apt-get install -y at mono-complete v4l-utils libsdl1.2-dev
fi

############################
# usermod
############################
# This is a bit hacky (from shipped the readme)
echo -e "[INFO] Configuring user groups"
group_found=0
for group in serial uucp uucm dialout;
do
	echo "[INFO] Checking group ${group}"
	if grep -q "${group}" /etc/group; then
		echo "[INFO] Found group ${group}, adding ${USER} to it"
		sudo usermod -a -G "${group}" "${USER}"
		group_found=1
	fi
done

# reload the groups
# Doing this in the loop seems stops the group checks, sicn newgrp does some kind of interactive login
# TODO fix...

if [[ ${group_found} -ne 1 ]]; then 
	echo "[WARN] Could not find a valid group to add ${USER} to"
fi

############################
# Borders
############################
if [[ -d "${HOME}/.var/app/org.libretro.RetroArch" ]]; then
	retroarch_overlays_dir="$(find ${HOME}/.local/share/flatpak/app/org.libretro.RetroArch -regex ".*libretro/overlays")/borders"
else
	retroarch_overlays_dir="${HOME}/.config/retroarch/overlays/borders"
fi

echo -e "[INFO] Copying Sinden Border Overlays for Retroarch to: ${retroarch_overlays_dir}"
cp -r ${GIT_ROOT}/overlays/retroarch/* ${retroarch_overlays_dir}

# For the time being, assume ES-DE-compliant MAME dir
# This also assumes internal storage...TODO to fix this... or add more folder detection
echo "[INFO] Copying Sinden Border Overlays for any available MAME systems"
if [[ -d "${HOME}/Emulation/roms/mame/" ]]; then
	cp -r ${GIT_ROOT}/overlays/mame/* "${HOME}/Emulation/roms/mame/"
fi

############################
# Finish
############################

# Relock OS if using SteamOS/Steam Deck
if which steamos-readonly &> /dev/null; then
	echo "[INFO] Relocking SteamOS"
	sudo steamos-readonly enable
fi

echo -e "[INFO] Done!"
echo "[INFO] Please log out and back in to apply group permission updates"
echo "[INFO] After this, run ${SOFTWARE_ROOT}/configure-lightgun.sh to complete setup and calibration of the lightgun"
echo "[INFO] You can test your lightgun at any time after this with '${SOFTWARE_ROOT}/TestLightgun.sh'"
