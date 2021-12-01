#!/bin/bash

# Arduino
set -e
#ARDUINO_VERSION=1.8.16

echo "Setting up Arduino ${ARDUINO_VERSION}"

# Security checks
[ -z "${ARDUINO_VERSION}" ] && echo "ERROR: ARDUINO_VERSION not set" && exit 1
case $(uname -m) in
	"x86_64")
		ARDUINO_ARCH=linux64
		;;
	"aarch64")
		ARDUINO_ARCH=linuxaarch64
		;;
	"armv6l"|"armv7l")
		ARDUINO_ARCH=linuxarm
		;;
	default)
		echo "ERROR: Unsupported architecture $(uname -m)"
		exit 1;
esac


# Download arduino
if [ ! -e "${CONFIG}"/arduino.downloaded ] || [ "$( cat "${CONFIG}"/arduino.downloaded )" != "${ARDUINO_VERSION}" ]; then
	echo "====> Downloading arduino-${ARDUINO_VERSION}-${ARDUINO_ARCH}.tar.xz"
	curl "https://downloads.arduino.cc/arduino-${ARDUINO_VERSION}-${ARDUINO_ARCH}.tar.xz" -o "${DONWLOADS}/arduino-${ARDUINO_VERSION}-${ARDUINO_ARCH}.tar.xz"
	echo "${ARDUINO_VERSION}" > "${CONFIG}"/arduino.downloaded
fi

# Uninstall arduino if older version
if [ -e "${CONFIG}"/arduino.installed ] && [[ "${ARDUINO_VERSION}" > "$( cat "${CONFIG}"/arduino.installed )" ]]; then
	echo "====> Uninstalling older version $( cat "${CONFIG}"/arduino.installed )"
	cd ~/arduino-"${ARDUINO_VERSION}"
	./uninstall.sh
	cd -
	rm -rf ~/arduino-"${ARDUINO_VERSION}"
	rm -f "${CONFIG}"/arduino.installed
fi

# Install version
if [ ! -e "${CONFIG}"/arduino.installed ] || [ "$( cat "${CONFIG}"/arduino.installed )" != "${ARDUINO_VERSION}" ]; then
	echo "====> Installing version ${ARDUINO_VERSION}"
	pushd .
	cd ~
	tar -Jxpf "${DONWLOADS}/arduino-${ARDUINO_VERSION}-${ARDUINO_ARCH}.tar.xz"
	cd arduino-${ARDUINO_VERSION}
	./install.sh
	popd
	echo "${ARDUINO_VERSION}" > "${CONFIG}"/arduino.installed
fi

