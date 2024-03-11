#!/bin/bash

set -e -o pipefail

# https://sindenlightgun.com/drivers/
RELEASE="Beta"
VERSION="2.05c"
DRIVERS_URL="https://www.sindenlightgun.com/software/Linux${RELEASE}${VERSION}.zip"
GIT_ROOT=$(git rev-parse --show-toplevel)
SOFTWARE_ROOT="${HOME}/software/sinden"
TS=$(date +%s)
BIN_DIR="${HOME}/.local/bin"
CONFIG_BACKUP="${HOME}/.config/sinden/backups"

# Get OS type
OS_TYPE=$(cat /etc/*release* | awk -F'=' '/ID_LIKE/ {print $2}')
if [[ "${OS_TYPE}" == "arch" ]]; then
	OS_LIKE="arch"

elif [[ "${OS_TYPE}" =~ "debian" ]]; then
	OS_LIKE="debian"
fi

# Get Arch
ARCH=$(uname -m)
if [[ "$ARCH" == *"arm"* ]]; then
    ARCH="Pi-ARM"
fi

# Cleanup anything from a previous install
echo -e "\n[INFO] Cleaning previous Sinden Border Overlays"
rm -rf ${SOFTWARE_ROOT}

# Folders
mkdir -p ${BIN_DIR}
mkdir -p "${SOFTWARE_ROOT}"
mkdir -p "${CONFIG_BACKUP}"

# remove udev rules
echo -e "\n[INFO] Cleaning Sinden udev rules"
sudo rm -rf /etc/udev/rules.d/*sinden-lightgun*

# Download latest drivers
echo "[INFO] Downloading ${DRIVERS_URL} to ${SOFTWARE_ROOT}"
curl -Lo "${SOFTWARE_ROOT}/sinden.zip" "${DRIVERS_URL}"
unzip "${SOFTWARE_ROOT}/sinden.zip" -d "${SOFTWARE_ROOT}"
LINUX_FILES="$(find "${SOFTWARE_ROOT}" -name "SteamdeckVersion")/Lightgun"

# Linux Scripts
echo "[INFO] Copying Sinden Utilities to ${SOFTWARE_ROOT}"
cp -v ${GIT_ROOT}/scripts/*.sh ${HOME}/.local/bin

# Update bin paths in scripts
find ${HOME}/.local/bin -name "*.sh" -exec sed -i "s|LINUX_FILES|${LINUX_FILES}|g" {} \;
find ${HOME}/.local/bin -name "*.sh" -exec sed -i "s|SOFTWARE_ROOT|${SOFTWARE_ROOT}|g" {} \;
find ${HOME}/.local/bin -name "*.sh" -exec sed -i "s|LINUX_FILES|${LINUX_FILES}|g" {} \;
find ${HOME}/.local/bin -name "*.sh" -exec chmod +x {} \;

# pre-req software
if [[ "${OS_TYPE}" == "arch" ]]; then
	echo "[INFO] Installing prerequisite packages for Arch Linux"
	sudo pacman -Sy --noconfirm mono sdl12-compat sdl_image sdl

elif [[ "${OS_TYPE}" =~ "debian" ]]; then
	echo "[INFO] Installing prerequisite packages for Arch Linux"
	sudo pacman -Sy --noconfirm mono sdl12-compat sdl_image sdl
fi

# Borders
echo -e "\nCopying Sinden Border Overlays for Retroarch"
if [[ -d "${HOME}/.var/app/org.libretro.RetroArch" ]]; then
	retroarch_overlays_dir=/"${HOME}/.var/app/org.libretro.RetroArch/config/retroarch/overlays"
else
	retroarch_overlays_dir="${HOME}/.config/retroarch/overlay"
fi
cp -v ${GIT_ROOT}/borders/retroarch-borders/* ${retroarch_overlays_dir}

# Binary Directory Configs
echo -e "\n[INFO] Copying Configurations."
cp -v "${GIT_ROOT}/configs/test.bmp" ${BIN_DIR}

HAS_BACKUPS=0
for configfile in ${GIT_ROOT}/configs/*.config; do
    CONFIG=$(basename $configfile)
    if [[ -f ${BIN_DIR}/${CONFIG} ]]; then
        echo "[INFO] ${CONFIG} Configurations already exist. Creating backup."
        cp -v ${BIN_DIR}/${CONFIG} ${CONFIG_BACKUP}/${CONFIG}.bak.${VERSION}.${TS}
        HAS_BACKUPS=1
    else
        cp -v ${configfile} ${BIN_DIR}
    fi
done

if [[ ${HAS_BACKUPS} -eq 1 ]]; then
    echo -e "\n[INFO] All backups:"
    ls -la ${CONFIG_BACKUP}/*bak*
fi

# Sinden udev rules
echo -e "\n[INFO] Copying Sinden udev rules."
sudo cp -v "${GIT_ROOT}/device-scripts/99-sinden-lightgun.rules" "/etc/udev/rules.d/"
sudo sed -i "s|BIN_SCRIPTS|${BIN_DIR}|g" "/etc/udev/rules.d/99-sinden-lightgun.rules"
sudo sudo udevadm control --reload-rules
sudo udevadm trigger

# Copy per-arch Binaries

if [[ -e ${GIT_ROOT}/arch/${ARCH} ]]; then
    echo "Copying ${ARCH} binaries."
    cp -rv ${GIT_ROOT}/arch/${ARCH}/* ${BIN_DIR}/
fi


# Leave this out of the above just to make sure stuff was copied
if [[ -f ${BIN_DIR}/LightgunMono.exe ]]; then
    echo "[INFO] Properly copied arch/${ARCH} binaries."
    echo "[INFO] Sinden Lightgun sucessfully installed for this operating system."
    echo "[INFO] You will need to configure per emulator as needed."
else
    echo -e "\n[INFO] Could not properly determine your system architecture [${ARCH}]."
    echo "[INFO] Follow the README to copy the proper files to the 'bin/' folder"
fi
