#/usr/bin/bash
#
# Simplified listing of image duplicates in a directory
# Version 0.0.0.1
# Copyright © 2024, Dr. Peter Netz
# Published under the MIT license.
#
# Prerequisite:
#     Installation of package findimagedupes:
#     sudo apt-get install findimagedupes
#
# Description:
# findimagedupes finds one or more duplicates of the same or a similar image.
# The output of findimagedupes returns the entire path to a duplicate. This
# makes the output of findimagedupes unreadable. This script reads each output
# line of findimagedupes with the duplicates in a loop. The script loops over
# the specified string array. Then the file name is extracted from the path.
# Each set of duplicates is printed line by line. When the script is finished,
# it prints out how many duplicate images were found.
#
# References:
# http://www.jhnc.org/findimagedupes/
# https://github.com/jhnc/findimagedupes

# Set counter.
count=0

# Print a message into the terminal window.
printf "%s%b" "Try to find duplicates. Process started!" "\n\n"

# Loop over the output of findimagedupes.
while read -r line
do
    # Increment counter.
    ((count++))
    # Print a message into the terminal window.
    echo "Duplicate(s) found:"
    echo "-------------------"
    # Loop over the string array.
    for ele in ${line}; do
        # Extract the filename from the path.
        fn="${ele##*/}"
        printf "%s%b" "$fn" "\n"
    done
    echo ""
done < <(findimagedupes *.* 2>/dev/null) # Warnings from findimagedupes are redirect to null

# Print how much duplicates were found.
if [ "${count}" -eq 0 ]; then
    printf "%s%b" "No duplicates found!" "\n\n"
else
    printf "%s%b" "Found ${count} duplicate(s)!" "\n\n"
fi

# Print farewell message into the terminal window.
printf "%s%b" "Have a nice day! Bye!" "\n"

# Exit the script.
exit 0
