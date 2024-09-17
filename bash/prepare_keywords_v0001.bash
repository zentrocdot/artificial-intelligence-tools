#!/usr/bin/bash
#
# Prepare keyword file
# Version 0.0.0.1
# Copyright © 2024, Dr. Peter Netz
# Published under the MIT license.
# https://github.com/zentrocdot/artificial-intelligence-tools/blob/main/LICENSE
#
# Description:
# Prepare unsorted keword lists.
#
# Prerequisite:
# keyword.txt

# Set the filename.
FN="keywords.txt"

# Set temporary file.
TMP="temp.txt"

# ======================
# Function read_write ()
# ======================
function read_write {
    # Assign the function argument to the local variable.
    local pattern=$1
    # Loop over the line of the file.
    while IFS="" read -r c || [ -n "${c}" ]
    do
        if [[ "${c}" =~ $1 ]]; then
            printf '%s\n' "$c" >> "output.txt"
        fi
    done < "${FN}"
    # Return 0
    return 0
}

# ++++++++++++++++++++
# Main script function
# ++++++++++++++++++++
function main {
    # Create backup file.
    cp "${FN}" "${FN}.bak"
    # Remove empty lines from file.
    sed -i '/^$/d' "${FN}"
    # Remove spaces and double quote up to the first double qoute.
    sed -i 's/^ *"//g' "${FN}"
    # Remove everything after first occurrence of a double quote.
    sed -i".bak" 's/".*//' "${FN}"
    # Get only unique lines.
    sort -u "${FN}" -o "temp.txt"
    # Sort file content.
    sort -n "temp.txt" -o "${FN}"
    # Create a new file.
    touch out.txt
    # Read and write data.
    read_write "ss_"
    read_write "sshs_"
    read_write "ssmd_"
    # Return 0.
    return 0
}

# Call main script function.
main

# Exit script.
exit 0
