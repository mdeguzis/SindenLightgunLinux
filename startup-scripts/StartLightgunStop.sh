#!/bin/bash

main () {
	echo -e "\n============================================="
	echo "Sinden lightgun log (stop action)"
	echo "Date: $(date)"
	echo "============================================="
	echo "Stopping Sinden lightgun"
	sudo pkill "mono"
	sudo pkill "mono-service"
	sudo rm /tmp/LightgunMono* -f
	echo "Done!"
	exit
}
main 2>&1 | tee -a "/tmp/sinden-lightgun.log"

