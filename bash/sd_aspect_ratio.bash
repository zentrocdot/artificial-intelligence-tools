#!/usr/bin/bash
# shellcheck disable=SC2034
# shellcheck disable=SC2068
#
# Calculate the valid resolution related to a given aspect ratio
# Version 0.0.0.2
# Copyright © 2024, Dr. Peter Netz
# Published under the MIT license.
#
# Description:
# In Stable Diffusion a number of values are allowed or preferred for the
# image dimensions width and height. The lowest value for width or height
# should not be less than 512. Based on this knowledge a valid resolution
# can be calculated if the aspect ratio is given. The related smallest
# resolution is returned to the given aspect ratio.
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
ar=$1

# Declare the array with the possible lens.
declare -a base_lens="128 192 256 320 384 448 512 576 640 704 768 832
                      896 960 1024 1152 1280 1536 1792 2048 2304 4096"

# Declare the array with the valid lens.
declare -a valid_lens="512 576 640 704 768 832 896 960 1024
                       1152 1280 1536 1792 2048 2304 4096"

# Check the format of theinput.
if ! [[ ${ar} =~ ^[0-9]+:[0-9]+$ ]]; then
    # Write a message into the terminal window.
    echo -e "Wrong format of the given aspect ratio. Exit the script. Bye!"
    echo -e "Use a format for the aspect ratio in the form 1:1, 3:2, 4:5 or 16:10 and so on."
    # Exit the script with error code 1.
    exit 128
fi

# Get the factor for the width from the aspect ratio.
width=$(echo "${ar}" | awk -F ':' '{print $1}')

# Get the factor for the height from the aspect ratio.
height=$(echo "${ar}" | awk -F ':' '{print $2}')

# Check the size of height and width.
if [ "${height}" -lt "${width}" ]; then
    x="${width}"
    y="${height}"
else
    x="${height}"
    y="${width}"
fi

# Calculate a valid resolution if possible.
for l in ${valid_lens[@]}; do
    # Calculate the lowest valid resolution.
    if [ $((l%y)) -eq 0 ]; then
        ny=$l
        div=$(echo "scale=0;$l/$y" | bc)
        nx=$(echo "scale=0;$x*$div" | bc)
        break
    fi
done

# Print a message into the terminal window.
echo -e "Calculate Resolution from Aspect Ratio"

# Print the aspect artio into the terminal window.
echo -e "Aspect Ratio: ${ar}"

# Check size of original height and original width.
if [ "${nx}" == "" ] && [ "${ny}" == "" ]; then
    echo -e "Resolution: ${width} x ${height} pixel"
else
    if [ "${height}" -lt "${width}" ]; then
        echo -e "Resolution: ${nx} x ${ny} pixel"
    else
        echo -e "Resolution: ${ny} x ${nx} pixel"
    fi
fi

# Print farewell message.
echo -e "Have a nice day. Bye!"

# Exit the script
exit 0
