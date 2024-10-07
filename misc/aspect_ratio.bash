#!/usr/bin/bash
#
# Determine the aspect ratio of an image
# Version 0.0.0.2
# Copyright © 2024, Dr. Peter Netz
# Published under the MIT license.
# github.com/zentrocdot/artificial-intelligence-tools/blob/main/LICENSE
#
# Description:
# The greatest common divisor (gcd) is used to determine the aspect ratio
# of an image. Input values are the x-resolution and the y-resolution. For
# testing puposes two default values for the resolutions are predefined.
# If the gcd is found x-resolution and y-resolution is devided by the gcd.
# This results in the aspect ration.
#
# See also:
# de.wikipedia.org/wiki/Bildauflösungen_in_der_Digitalfotografie

# Initialise the values of the resolutions.
XRES="${1}"
YRES="${2}"

# Set reg exp string.
re='^[0-9]+$'

# Check XRES and YRES using the reg exp string.
if ! [[ ${XRES} =~ $re ]] || ! [[ ${YRES} =~ $re ]]; then
   echo "ERROR. Not a Number." >&2; exit 1
fi

# ############
# Function gcd
# ############
function gcd () {
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
    # Output the greatest common devisor.
    echo "${a}"
    # Return 0.
    return 0
}

# +++++++++++++++++++
# Main script section
# +++++++++++++++++++

# Call the function:
GCD=$(gcd "${XRES}" "${YRES}")

# Calculate the aspect ratio.
x=$((XRES/GCD))
y=$((YRES/GCD))

# Print the result.
printf "%s:%s%b" "${x}" "${y}" "\n"

# Exit the script.
exit 0
