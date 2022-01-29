#!/usr/bin/env bash

# Globals
DEVICE_RESOLUTION="1080x2400"

function main() {

	# Check if given file exist
	if [ -z "${1}" ]; then echo "No file given"; return; fi
	if [ ! -f "${1}" ]; then echo "The file given does not exist"; return; fi

	echo a


}


main "${@}"
