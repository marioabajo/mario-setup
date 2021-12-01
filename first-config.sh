#!/bin/bash

# Common variables
export CONFIG=~/.config/mario
export DONWLOADS=$(xdg-user-dir DOWNLOAD)

# Versions
export ARDUINO_VERSION=1.8.16


# Various checks
if [ ! -e "${CONFIG}" ]; then
	mkdir ${CONFIG}
fi
[ -z "DOWNLOADS" ] && echo "ERROR: no download directory set" && exit 1

# Arduino
./tasks/arduino.sh
