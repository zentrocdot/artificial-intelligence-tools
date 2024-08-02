#!/usr/bin/bash
# shellcheck disable=SC1083
# shellcheck disable=SC2155
# shellcheck disable=SC2059
#
# Extract exif metadata from image.
# Version 0.0.0.5
# Copyright © 2024, Dr. Peter Netz
# Published under the MIT license.
#
# Description:
# Extract slected exif data from image file.
#
# Prerequisite:
# Installation of exiftool
# sudo apt-get install exiftool

# Get the filename from the command line.
FN=$1

# Check if file exist. Otherwise exit script.
if [ ! -f "${FN}" ]; then
    # Write a message into the terminal window.
    echo "File not found! Bye!"
    # Exit script with error code 1.
    exit 1
fi

# Initialise the boundary key and value variables.
K4=8192
K3=4096
K2=2048
K1=512
V4="Ultra High"
V3="High"
V2="Medium"
V1="Low"

# Declare the associative array for key and value of the resolutions.
declare -A associative_array=(["${K4}"]="${V4}" ["${K3}"]="${V3}"
                              ["${K2}"]="${V2}" ["${K1}"]="${V1}")

# ------------------------------------------------------------------------------
# Function gcd
# ------------------------------------------------------------------------------
function gcd {
    # Assign the function arguments to the local variables.
    local a=$1
    local b=$2
    # Declare the variable n.
    local n
    # Loop until the greatest common divisor is found.
    while [[ "${b}" -gt 0 ]]
    do
        n="${a}"
        a="${b}"
        b=$((n%b))
    done
    # Output the greatest common divisor.
    echo -n "${a}"
    # Return 0.
    return 0
}

# ------------------------------------------------------------------------------
# Function get_orientation
# ------------------------------------------------------------------------------
function get_orientation {
    # Assign the function arguments to the local variables.
    local x=$1
    local y=$2
    # Initialise the local variable.
    local orientation="n\a"
    # Determine the orientation.
    if [ "${y}" -gt "${x}" ]; then
        orientation="Portrait"
    elif [ "${x}" -gt "${y}" ]; then
        orientation="Landscape"
    elif [ "${x}" -eq "${y}" ]; then
        orientation="None"
    else
        orientation="Unknown"
    fi
    # Output the orientation.
    echo -n "${orientation}"
    # Return 0.
    return 0
}

# ------------------------------------------------------------------------------
# Function get_resolution
# ------------------------------------------------------------------------------
function get_resolution {
    # Assign the function arguments to the local variables.
    local x=$1
    local y=$2
    # Initialise the local variables.
    resolution="n\a"
    # Determine the resolution.
    if [ "${y}" -ge "${K4}" ] && [ "${x}" -ge "${K4}" ]; then
        resolution="${associative_array[${K4}]}"
    elif [ "${y}" -ge "${K3}" ] && [ "${x}" -ge "${K3}" ]; then
        resolution="${associative_array[${K3}]}"
    elif [ "${y}" -ge "${K2}" ] && [ "${x}" -ge "${K2}" ]; then
        resolution="${associative_array[${K2}]}"
    elif [ "${y}" -ge "${K1}" ] && [ "${x}" -ge "${K1}" ]; then
        resolution="${associative_array[${K1}]}"
    elif [ "${y}" -lt "${K1}" ] && [ "${x}" -lt "${K1}" ]; then
        resolution="None"
    else
        resolution="Unknown"
    fi
    # Output the resolution.
    echo -n "${resolution}"
    # Return 0.
    return 0
}

# ------------------------------------------------------------------------------
# Function aspect_ratio
# ------------------------------------------------------------------------------
function aspect_ratio {
    # Get width and height from the function arguments.
    local xres=$1
    local yres=$2
    # Calculate the greatest common divisor.
    gcd_val=$(gcd "${xres}" "${yres}")
    # Calculate the aspect ratio.
    x=$((xres/gcd_val))
    y=$((yres/gcd_val))
    # Output the aspect ratio.
    echo -n "${x}:${y}"
    # Return 0.
    return 0
}

# ------------------------------------------------------------------------------
# Function calc_size
# ------------------------------------------------------------------------------
function calc_size {
    # Get the filesize from the function argument.
    local filesize=$1
    # Get the unit from the filesize string.
    unit=$(echo "${filesize}" | awk {'print $2'})
    # Check on KiB and on MiB
    if [[ "${unit}" == "KiB" ]]; then
        kib_raw=$(echo "${filesize}" | awk {'print $1'})
        mib_raw=$(echo "scale=1;(${kib_raw}/1000)" | bc)
    elif [[ "${unit}" == "MiB" ]]; then
        mib_raw=$(echo "${filesize}" | awk {'print $1'})
    else
        mib_raw=-1
    fi
    # Format the MiB and MB value.
    mib=$(echo "${mib_raw}" | awk '{printf "%.1f", $0}')
    mb_raw=$(echo "scale=1;(${mib_raw}*1.048576)" | bc)
    mb=$(echo "${mb_raw}" | awk '{printf "%.1f", $0}')
    # Output formatted MiB and MB value.
    echo -n "${mib}" "${mb}"
    # Return 0.
    return 0
}

# ------------------------------------------------------------------------------
# Function print_exifdata
# ------------------------------------------------------------------------------
function print_exifdata {
    # Get the filename from the function argument.
    local fn=$1
    # Get the md5 hash value for the file.
    local hash=$(md5sum "${fn}" | awk '{print $1}')
    # Get filetype.
    ft=$(exiftool -filetype -s3 "${fn}")
    fte=$(exiftool -filetypeextension -s3 "${fn}")
    mt=$(exiftool -mimetype -s3 "${fn}")
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
    read -r mib mb < <(calc_size "${filesize}")
    # Calculate the aspect ratio.
    ar=$(aspect_ratio "${xres}" "${yres}")
    # Determine the image oriantation.
    io=$(get_orientation "${xres}" "${yres}")
    # Determine the image resolution.
    ir=$(get_resolution "${xres}" "${yres}")
    # Get category.
    if [[ "${comment}" == "Fantastic Mushroom Collection" ]]; then
        category="Mushroom"
    else
        category="Unknown"
    fi
    # Print the summery into the terminal window.
    fmtstr="%-28s%s%b"
    printf "${fmtstr}" "Filename:" "${fn}" "\n"
    printf "${fmtstr}" "MD5 Hash:" "${hash}" "\n"
    printf "${fmtstr}" "Category (EVAL):" "${category}" "\n"
    printf "${fmtstr}" "Copyright (EXIF):" "${copyright}" "\n"
    printf "${fmtstr}" "Creator: (EXIF)" "${creator}" "\n"
    printf "${fmtstr}" "Creator Tool (EXIF):" "${creatortool}" "\n"
    printf "${fmtstr}" "Comment (EXIF):" "${comment}" "\n"
    printf "${fmtstr}" "User Comment (EXIF):" "${usercomment}" "\n"
    printf "${fmtstr}" "File Type (EVAL):" "${ft}" "\n"
    printf "${fmtstr}" "File Type Extension (EVAL):" "${fte}" "\n"
    printf "${fmtstr}" "Mime Type (EVAL):" "${mt}" "\n"
    printf "${fmtstr}" "File Size (MiB):" "${mib} MiB" "\n"
    printf "${fmtstr}" "File Size (MB):" "${mb} MB" "\n"
    printf "${fmtstr}" "Image Width (EXIF):" "${xres}" "\n"
    printf "${fmtstr}" "Image Height (EXIF):" "${yres}" "\n"
    printf "${fmtstr}" "Image Size (EXIF):" "${imagesize} pixel" "\n"
    printf "${fmtstr}" "Image Size (EVAL):" "${xres} x ${yres} pixel" "\n"
    printf "${fmtstr}" "Aspect Ratio (CALC):" "${ar}" "\n"
    printf "${fmtstr}" "Orientation (EVAL):" "${io}" "\n"
    printf "${fmtstr}" "Resolution: (EVAL)" "${ir}" "\n"
    # Return 0.
    return 0
}

# +++++++++++++++++++++++++++++
# Main script section
# +++++++++++++++++++++++++++++

# Clear the screen
clear

# Extract and print the EXIF metadata.
print_exifdata "${FN}"

# Exit the script.
exit 0
