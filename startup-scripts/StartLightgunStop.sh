#!/bin/bash
# Runs as root user (udev invocation)

main () {
	echo -e "\n============================================="
	echo "Sinden lightgun log (stop action)"
	echo "Date: $(date)"
	echo "============================================="
	echo "Stopping Sinden lightgun"
	pkill "mono"
	pkill "mono-service"
	rm /tmp/LightgunMono* -f
	echo "Done!"
	exit
}
main 2>&1 | tee -a "/tmp/sinden-lightgun.log"

