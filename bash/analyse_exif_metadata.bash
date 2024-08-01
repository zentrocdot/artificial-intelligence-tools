#!/usr/bin/bash
# shellcheck disable=SC1083
#
# Extract exif data from image.
# Version 0.0.0.4
# Copyright © 2024, Dr. Peter Netz
# Published under the MIT license.
# Version 0.0.0.1
#
# Description:
# Extract slected exif data from image file.
#
# Prerequisite:
# Installation of exiftool
# sudo apt-get install exiftool

# Clear the screen
clear

# Get the filename from the command line.
FN=$1

# Check if file exist. Otherwise exit script.
if [ ! -f "${FN}" ]; then
    # Write a message into the terminal window.
    echo "File not found! Bye!"
    # Exit script with error code 1.
    exit 1
fi

# ------------------------------------------------------------------------------
# Function gcd
# ------------------------------------------------------------------------------
function gcd {
    # Assign the function arguments to the local variables.
    local a=$1
    local b=$2
    # Declare the variable n.
    local n
    # Loop until the gcd is found.
    while [[ "${b}" -gt 0 ]]
    do
        n="${a}"
        a="${b}"
        b=$((n%b))
    done
    # Output the greatest common divisor.
    echo "${a}"
    # Return 0.
    return 0
}

# ------------------------------------------------------------------------------
# Function calc_size
# ------------------------------------------------------------------------------
function calc_size {
    # Get filesize from function argument.
    filesize=$1
    # Get unit from file size string.
    unit=$(echo "${filesize}" | awk {'print $2'})
    # Do something on KiB or MiB.
    if [[ "${unit}" == "KiB" ]]; then
        kib_raw=$(echo "${filesize}" | awk {'print $1'})
        mib_raw=$(echo "scale=1;(${kib_raw}/1000)" | bc)
    elif [[ "${unit}" == "MiB" ]]; then
        mib_raw=$(echo "${filesize}" | awk {'print $1'})
    fi
    # Format the MB value.
    mib=$(echo "${mib_raw}" | awk '{printf "%.1f", $0}')
    mb_raw=$(echo "scale=1;(${mib_raw}*1.048576)" | bc)
    mb=$(echo "${mb_raw}" | awk '{printf "%.1f", $0}')
    echo -n "${mib};${mb}"
    # Return 0.
    return 0
}

# ------------------------------------------------------------------------------
# Function print_exifdata
# ------------------------------------------------------------------------------
function print_exifdata {
    # Get the filename from the function argument.
    fn=$1
    # Get the width and height of the image.
    xres=$(exiftool -imagewidth -s3 "${fn}")
    yres=$(exiftool -imageheight -s3 "${fn}")
    # Get the creator and copyright informations.
    copyright=$(exiftool -copyright -s3 "${fn}")
    creator=$(exiftool -creator -s3 "${fn}")
    creatortool=$(exiftool -creatortool -s3 "${fn}")
    # Get the informations from the comment tags.
    comment=$(exiftool -comment -s3 "${fn}")
    usercomment=$(exiftool -usercomment -s3 "${fn}")
    # Get the filesize and the image size of the image.
    filesize=$(exiftool -filesize -s3 "${fn}")
    imagesize=$(exiftool -imagesize -s3 "${fn}" | sed 's/x/ x /')
    # Calculate MiB and MB.
    ret_val=$(calc_size "${filesize}")
    mib=$(echo "${ret_val}" | awk -F ';' '{print $1}')
    mb=$(echo "${ret_val}" | awk -F ';' '{print $2}')
    # Calculate the greatest common divisor.
    gcd_val=$(gcd "${xres}" "${yres}")
    # Calculate the aspect ratio.
    x=$((xres/gcd_val))
    y=$((yres/gcd_val))
    if [ "${y}" -gt "${x}" ]; then
        orientation="Portrait"
    elif [ "${x}" -gt "${y}" ]; then
        orientation="Landscape"
    elif [ "${x}" -eq "${y}" ]; then
        orientation="None"
    fi
    # Calculate resolution.
    if [ "${yres}" -ge 8192 ] && [ "${xres}" -ge 8192 ]; then
        resolution="Ultra High"
    elif [ "${yres}" -ge 4096 ] && [ "${xres}" -ge 4096 ]; then
        resolution="High"
    elif [ "${yres}" -ge 2048 ] && [ "${xres}" -ge 2048 ]; then
        resolution="Medium"
    elif [ "${yres}" -lt 2048 ] && [ "${xres}" -lt 2048 ]; then
        resolution="High"
    else
        resolution="Unknown"
    fi
    # Get the md5 hash value for the file.
    hash=$(md5sum "${FN}" | awk '{print $1}')
    # Print summery
    echo "Filename: ${fn}"
    echo "MD5 Hash: ${hash}"
    echo "Comment: ${comment}"
    echo "User Comment: ${usercomment}"
    echo "Copyright: ${copyright}"
    echo "Creator: ${creator}"
    echo "Creator Tool: ${creatortool}"
    echo "File Size (MiB): ${mib} MiB"
    echo "File Size (MB): ${mb} MB"
    echo "Image Width: ${xres}"
    echo "Image Height: ${yres}"
    echo "Image Size (EXIF): ${imagesize} pixel"
    echo "Image Size (CALC): ${xres} x ${yres} pixel"
    printf "Aspect Ratio: %s:%s%b" "${x}" "${y}" "\n"
    printf "Orientation: %s%b" "${orientation}" "\n"
    printf "Resolution: %s%b" "${resolution}" "\n"
    # Return 0.
    return 0
}

# +++++++++++++++++++++++++++++
# Call the main script function
# +++++++++++++++++++++++++++++
print_exifdata "${FN}"

# Exit the script.
exit 0
