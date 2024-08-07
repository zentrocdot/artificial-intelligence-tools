#!/usr/bin/bash
# shellcheck disable=SC2034
# shellcheck disable=SC2068
#
# Calculate the valid resolution related to a given aspect ratio
# Version 0.0.0.5
# Copyright © 2024, Dr. Peter Netz
# Published under the MIT license.
#
# Description:
# In Stable Diffusion a number of values are allowed or preferred for the
# image dimensions width and height. The lowest value for width or height
# should not be less than 512. Based on this knowledge a valid resolution
# can be calculated if the aspect ratio is given. The related smallest
# resolution is returned to the given aspect ratio. Only integer values
# are allowed as numbers in the aspect ratio string.
#
# Prerequisites
# Installation of bc
# sudo apt-get install bc
#
# Linting:
# The Bash script was linted using the famous linter Shellcheck.
#
# Development Environment:
# Linux 5.15.0-117-generic #127-Ubuntu SMP Fri Jul 5 20:13:28 UTC 2024 x86_64 GNU/Linux
# Linuxmint, Linux Mint 21.3, Virginia
#
# References:
# https://tldp.org/LDP/abs/html/exitcodes.html

# Get the aspect ratio from command line argument.
AR=$1

# +++++++++++++
# Function quit
# +++++++++++++
quit () {
    # Write a message into the terminal window.
    STR0="Wrong format of the given aspect ratio. Exit the script. Bye!"
    STR1="Use a format for the aspect ratio like 1:1, 4:5 or 16:10 etc."
    echo -e "${STR0}"
    echo -e "${STR1}"
    # Exit the script with error code 1.
    exit 128
}

# Check the format of the given input.
if ! [[ ${AR} =~ ^[0-9]+:[0-9]+$ ]]; then
    # Quit the script.
    quit
fi

# Get the factor for the width from the aspect ratio.
WIDTH=$(echo "${AR}" | awk -F ':' '{print $1}')

# Get the factor for the height from the aspect ratio.
HEIGHT=$(echo "${AR}" | awk -F ':' '{print $2}')

# Check if HEIGHT or WIDTH are allowed.
if [ "${WIDTH}" -le 0 ] || ["${HEIGHT}" -le 0 ]; then
    # Quit the script.
    quit
fi

# Declare the array with the possible lens.
declare -a BASE_LENS="128 192 256 320 384 448 512 576 640 704 768 832
                      896 960 1024 1152 1280 1536 1792 2048 2304 4096"

# Declare the array with the valid lens.
declare -a VALID_LENS="512 576 640 704 768 832 896 960 1024
                       1152 1280 1536 1792 2048 2304 4096"

# -------------------_------
# Function lowest_resolution
# --------------------------
lowest_resolution () {
    # Get x and y from function argument.
    local x=$1
    local y=$2
    # Calculate a valid resolution if possible.
    for l in ${VALID_LENS[@]}; do
        # Calculate the lowest valid resolution.
        if [ $((l%y)) -eq 0 ]; then
            ny="${l}"
            div=$(echo "scale=0;${ny}/${y}" | bc)
            nx=$(echo "scale=0;${x}*${div}" | bc)
            break
        fi
    done
    # Output the resolution.
    echo -n "${nx}" "${ny}"
    # Return exit code 0.
    return 0
}

# +++++++++++++++++++
# Main script section
# +++++++++++++++++++

# Clear the screen.
clear

# Print a message into the terminal window.
echo -e "Calculate the Lowest Valid Resolution from the Aspect Ratio\n"

# Print the aspect artio into the terminal window.
echo -e "Aspect Ratio: ${AR}"

# Set x and y based on height and width.
if [ "${HEIGHT}" -lt "${WIDTH}" ]; then
    x="${WIDTH}"
    y="${HEIGHT}"
else
    x="${HEIGHT}"
    y="${WIDTH}"
fi

# Get nx and ny from subroutine.
read -r nx ny < <(lowest_resolution "${x}" "${y}")

# Check size of original height and original width.
if [ "${nx}" == "" ] && [ "${ny}" == "" ]; then
    # If no resolution could be calculated print the original one.
    echo -e "Resolution: ${WIDTH} x ${HEIGHT} pixel"
else
    # Print the result based on the original orientation.
    if [ "${HEIGHT}" -lt "${WIDTH}" ]; then
        echo -e "Resolution: ${nx} x ${ny} pixel"
    else
        echo -e "Resolution: ${ny} x ${nx} pixel"
    fi
fi

# Print farewell message.
echo -e "\nHave a nice day. Bye!"

# Exit the script
exit 0
