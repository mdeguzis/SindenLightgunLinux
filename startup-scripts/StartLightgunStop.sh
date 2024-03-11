#!/bin/bash
pkill "mono"
pkill "mono-service"
rm /tmp/LightgunMono* -f
echo "Stopping Sinden lightgun"
echo "stopped" > /tmp/sinden-lightgun.state
echo "Wrote state to /tmp/sinden-lightgun.state"
exit

