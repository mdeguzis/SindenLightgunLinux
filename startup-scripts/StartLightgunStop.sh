#!/bin/bash

main () {
	pkill "mono"
	pkill "mono-service"
	rm /tmp/LightgunMono* -f
	echo "Stopping Sinden lightgun"
	echo "stopped" > /tmp/sinden-lightgun.state
	echo "Wrote state to /tmp/sinden-lightgun.state"
	exit
}
main 2>&1 | tee -a "/tmp/sinden-lightgun.log"

