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

	echo "Boot image generator"

	# Check if given file exist
	if [ -z "${1}" ]; then echo "No file given"; return; fi
	if [ ! -f "${1}" ]; then echo "The file given does not exist"; return; fi

	# Get our current script dir
	cur_dir="$(get_folder)"

	# Create a temp folder
	tmp_dir="${cur_dir}/tmp"
	mkdir -p "${tmp_dir}"

	echo "Converting images ..."

	# Create the needed bmps
	ffmpeg -hide_banner -loglevel error -i "${1}" -pix_fmt rgb24 -s "${DEVICE_RESOLUTION}" -y "${tmp_dir}/logo-1.bmp"
	ffmpeg -hide_banner -loglevel error -i "${1}" -pix_fmt rgb24 -s "${DEVICE_RESOLUTION}" -y "${tmp_dir}/logo-3.bmp"
	ffmpeg -hide_banner -loglevel error -i "${cur_dir}/pics/fastboot.bmp" -pix_fmt rgb24 -s "${DEVICE_RESOLUTION}" -y "${tmp_dir}/logo-2.bmp"
	ffmpeg -hide_banner -loglevel error -i "${cur_dir}/pics/system-corrupt.bmp" -pix_fmt rgb24 -s "${DEVICE_RESOLUTION}" -y "${tmp_dir}/logo-4.bmp"

	echo "Conversion successful"
	echo "Joining images ..."

	# Create output folder
	out_dir="${cur_dir}/out"
	mkdir -p "${out_dir}"

	# Concatenate all the files and create the image
	cat \
		"${cur_dir}/bin/header.bin" \
		"${cur_dir}/tmp/logo-1.bmp" \
		"${cur_dir}/bin/footer.bin" \
		"${cur_dir}/tmp/logo-2.bmp" \
		"${cur_dir}/bin/footer.bin" \
		"${cur_dir}/tmp/logo-3.bmp" \
		"${cur_dir}/bin/footer.bin" \
		"${cur_dir}/tmp/logo-4.bmp" \
		"${cur_dir}/bin/footer.bin" \
		> "${out_dir}/logo.img"

	echo "Joining successful"
	echo "Creating flashable zip ..."

	# Create the flashable zip
	cp "${cur_dir}/bin/recovery-flashable.zip" "${out_dir}/flashable.zip"
	7z a "${out_dir}/flashable.zip" "${out_dir}/logo.img" &> /dev/null

	echo "Flashable ZIP created"

	echo "Success"

	# Cleanup
	rm "${tmp_dir}/"*
	rmdir "${tmp_dir}"

}


main "${@}"
