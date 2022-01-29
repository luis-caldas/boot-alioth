#!/usr/bin/env bash


# Globals
DEVICE_RESOLUTION="1080x2400"


# Function to get real script dir
function get_folder() {

    # get the folder in which the script is located
    SOURCE="${BASH_SOURCE[0]}"

    # resolve $SOURCE until the file is no longer a symlink
    while [ -h "$SOURCE" ]; do

      DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

      SOURCE="$(readlink "$SOURCE")"

      # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
      [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"

    done

    # the final assignment of the directory
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

    # return the directory
    echo "$DIR"
}

function main() {

	# Check if given file exist
	if [ -z "${1}" ]; then echo "No file given"; return; fi
	if [ ! -f "${1}" ]; then echo "The file given does not exist"; return; fi

	# Get our current script dir
	cur_dir="$(get_folder)"

	# Create a temp folder
	mkdir -p "${cur_dir}/tmp"

	# Create the needed bmps
	ffmpeg -hide_banner -i "${1}" -pix_fmt rgb24 -s "${DEVICE_RESOLUTION}" -y "${cur_dir}/logo-1.bmp"
	ffmpeg -hide_banner -i "${1}" -pix_fmt rgb24 -s "${DEVICE_RESOLUTION}" -y "${cur_dir}/logo-3.bmp" > NUL
	ffmpeg -hide_banner -i "${cur_dir}/pics/fastboot.bmp" -pix_fmt rgb24 -s "${DEVICE_RESOLUTION}" -y "${cur_dir}/logo-2.bmp"
	ffmpeg -hide_banner -i "${cur_dir}/pics/system_corrupt.bmp" -pix_fmt rgb24 -s "${DEVICE_RESOLUTION}" -y "${cur_dir}/logo-4.bmp"


}


main "${@}"
