#!/bin/bash
# Description: This script launches any of the Windows EXE's with Proton

WINDOWS_EXE=$1
APP_ROOT="${HOME}/Applications"
PROTON_VERSION="wine-staging_ge-proton_8-26-x86_64.AppImage"
PROTON_APPIMAGE="${APP_ROOT}/Proton/${PROTON_VERSION}"
mkdir -p "${APP_ROOT}"

update_binary ()
{
	name=$1;
	folder_target=$2
	filename=$3
	URL=$4
	dl_type=$5
	curl_options="-LO --output-dir /tmp"

	echo "[INFO] Fetching latet Git release from ${URL}"
	if ! echo "${URL}" | grep -q "latest"; then
		collected_urls=$(curl -s "${URL}" | jq -r 'map(select(.prerelease)) | first | .assets[] | .browser_download_url')
	else
		collected_urls=$(curl -s "${URL}" | jq -r '.assets[] | .browser_download_url')
	fi

	for this_url in ${collected_urls};
	do
		# Filename / regex to match above all else?
		if [[ -n "${filename}" ]]; then
			if echo "${this_url}" | grep -qE ${filename}; then
				dl_url="${this_url}"
				break
			fi
		else
			# Auto find if no filename given...
			# Prefer AppImage
			if echo "${this_url}" | grep -qE "http.*AppImage$"; then
				dl_url="${this_url}"
				break
			elif echo  "${this_url}" | grep -qE "http.*x.*64.*AppImage$"; then
				dl_url="${this_url}"
				break
			elif echo "${this_url}" | grep -qE "http.*${name}-.*linux.*x64.*tar.gz$"; then
				dl_url="${this_url}"
				break
			fi
		fi
	done

	if [[ -z "${dl_url}" ]]; then
		# https://docs.github.com/en/rest/using-the-rest-api/rate-limits-for-the-rest-api?apiVersion=2022-11-28
		echo "[ERROR] Could not get a download url for ${URL}!"
		exit 1
	fi


	# Download
	echo "[INFO] Downloading ${dl_url}"
	cmd="curl ${curl_options} ${dl_url}"
	eval "${cmd}"

	app_image=$(ls -ltr /tmp/${name}*AppImage | tail -n 1 | awk '{print $9}')
	if [[ -n "${folder_target}" ]]; then
		mkdir -p "${APP_ROOT}/${folder_target}"
		mv -v "${app_image}" "${APP_ROOT}/${folder_target}"
	else
		mv -v "${app_image}" "${APP_ROOT}"
	fi

}

# Fetch Proton Appimage if we need to
if [[ ! -f "${PROTON_APPIMAGE}" ]]; then
	echo "[INFO] Missing Proton AppImage, fetching..."
	update_binary "wine-staging_ge-proton" "Proton" "" "https://api.github.com/repos/mmtrt/WINE_AppImage/releases/latest" "AppImage"
else
	echo "[INFO] Found Proton AppImage: ${PROTON_APPIMAGE}"
fi

# Create our prefix in a predictable spot?

# Run the windows EXE with the prefix
echo "[INFO] Executing '${WINDOWS_EXE}' with Proton"
${PROTON_APPIMAGE} "${WINDOWS_EXE}"
echo "[INFO] Done!"
