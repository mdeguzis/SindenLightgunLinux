#!/bin/bash

##
# Currently not implemented for auto-detect until
# I can figure out how to distinguish the two devices in UDEV
#
echo ${HOME}/.local/bin/sindenlightgun-p1-start.sh | at -t `date --date='5 seconds' "+%m%d%H%M.%S"`
