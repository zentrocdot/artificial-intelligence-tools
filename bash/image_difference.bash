#!/usr/bin/bash
#
# Comparison of two images
# Version 0.0.0.1
# Copyright © 2024, Dr. Peter Netz
# Published under the MIT license.
# https://github.com/zentrocdot/artificial-intelligence-tools/blob/main/LICENSE
#
# Description:
# First attempt to quantify the difference of two images, which dimensions
# in x-direction and y-direction should be equal.
#
# Prerequisite:
# ImageMagick
#
# Reference:
# https://imagemagick.org/

# Get filenames from the command line argument.
FN1=$1
FN2=$2

# clear screen.
clear

# Print header.
echo -e "------------------------"
echo -e "Comparison of the images"
echo -e "------------------------\n"

# Get the dimension in pixels of the images.
dim1=$(identify -ping -format '%h x %w' "${FN1}")
dim2=$(identify -ping -format '%h x %w' "${FN2}")

# Exit on wrong dimensions.
if [[ $dim1 != $dim2 ]]; then
    # Write message into the terminal window.
    echo -e "Sorry, wrong dimensions of first and second image. Exiting script. Bye!"
    # Exit script with error code 1.
    exit 1
fi

# Get the quality factors.
qual1=$(identify -format '%Q' "${FN1}")
qual2=$(identify -format '%Q' "${FN2}")

# Get width and height of the first image.
width=$(identify -ping -format '%w' "${FN1}")
height=$(identify -ping -format '%h' "${FN1}")

# Calculate the megapixels.
megapixel=$(echo "scale=8; $width*$height" | bc)

# Calculate difference using fuzz.
fuzz0=$(magick compare -verbose -metric AE -fuzz 0% $FN1 $FN2 null: 2>&1)
fuzz5=$(magick compare -verbose -metric AE -fuzz 5% $FN1 $FN2 null: 2>&1)
fuzz10=$(magick compare -verbose -metric AE -fuzz 10% $FN1 $FN2 null: 2>&1)

# Get all different pixels.
px0_sci=$(echo $fuzz0 | grep "all" | awk -F 'all: ' '{print $2}' | awk '{print $1}' | sed 's/^[ \t]*//;s/[ \t]*$//')
px0=$(LC_NUMERIC="en_US.UTF-8" printf "%.2f" "${px0_sci}")
px5_sci=$(echo $fuzz5 | grep "all" | awk -F 'all: ' '{print $2}' | awk '{print $1}' | sed 's/^[ \t]*//;s/[ \t]*$//')
px5=$(LC_NUMERIC="en_US.UTF-8" printf "%.2f" "${px5_sci}")
px10_sci=$(echo $fuzz10 | grep "all" | awk -F 'all: ' '{print $2}' | awk '{print $1}' | sed 's/^[ \t]*//;s/[ \t]*$//')
px10=$(LC_NUMERIC="en_US.UTF-8" printf "%.2f" "${px10_sci}")

# Get difference in percent (using fuzz with 0%, 5% and 10%).
pct0=$(echo "scale=16;${px0}/${megapixel}" | bc)
pct0=$(LC_NUMERIC="en_US.UTF-8" printf "%.8f" "${pct0}")
pct5=$(echo "scale=16;${px5}/${megapixel}" | bc)
pct5=$(LC_NUMERIC="en_US.UTF-8" printf "%.8f" "${pct5}")
pct10=$(echo "scale=16;${px10}/${megapixel}" | bc)
pct10=$(LC_NUMERIC="en_US.UTF-8" printf "%.8f" "${pct10}")

# Output summary of calculations.
echo -e "${FN1}: ${dim1} pixel => Quality: ${qual1}%"
echo -e "${FN2}: ${dim2} pixel => Quality: ${qual2}%\n"
echo -e "Megapixel: ${megapixel}\n"
echo -e "Absolute Difference Scientific Notation (Pixel): $px0_sci"
echo -e "Absolute Difference Decimal Notation (Pixel)   : $px0\n"
echo -e "Absolute Difference (Percent): $pct0%\n"
echo -e "Fuzz 5% (5% Pixel Difference)"
echo -e "Absolute Difference Scientific Notation (Pixel): $px5_sci"
echo -e "Absolute Difference Decimal Notation (Pixel)   : $px5\n"
echo -e "Absolute Difference (Percent): $pct5%\n"
echo -e "Fuzz 10% (10% Pixel Difference)"
echo -e "Absolute Difference Scientific Notation (Pixel): $px10_sci"
echo -e "Absolute Difference Decimal Notation (Pixel)   : $px10\n"
echo -e "Absolute Difference (Percent): $pct10%\n"

# Print farewell message.
echo -e "Have a nice day. Bye!"

# Exit the script without error.
exit 0
