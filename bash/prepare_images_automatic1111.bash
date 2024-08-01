#!/usr/bin/bash
#
# Prepare image file for minting as NFT.
# Version 0.0.0.2
# Copyright © 2024, Dr. Peter Netz
# Published under the MIT license.
#
# Description:
# The script removes all the exif data from all the files in a directory.
# Then new exif data are added to the file. Then the md5 hash of the file
# is calculated. The original file is renamed using the characteristic
# md5 hash value.

# Set the file type extension.
FILES=("*.jpg" "*.JPG" "*.jpeg" "*.JPEG" "*.png" "*.PNG")

# Set the global EXIF data strings.
CREATOR="zentrocdot"
CREATORTOOL="AI Generator Stable Diffusion, AI WebUI AUTOMATIC1111"
COPYRIGHT="2024, zentrocdot"
COMMENT="Fantastic Mushroom Collection"
USERCOMMENT="Selected image for minting as NFT"

# -------------------------
# Function modify exif data
# -------------------------
modify_exifdata () {
    # Set temporary filename.
    tmpfn=$1
    # Strip all exif data from temporary file.
    exiftool -all= "${tmpfn}"
    # Add new exif data to the temporary file.
    exiftool -comment="${COMMENT}" -usercomment="${USERCOMMENT}" \
             -creator="${CREATOR}" -creatortool="${CREATORTOOL}" \
             -copyright="${COPYRIGHT}" "${tmpfn}"
}

# ---------------------
# Function create_image
# ---------------------
create_image () {
    # Loop over all image files by extension.
    for ext in "${FILES[@]}"
    do
        # Get the file list.
        list=$(ls ${ext} 2>/dev/null)
        files=($list)
        # Loop over all files from the file list.
        for file in "${files[@]}"
        do
            # Check if a filename is a md5 hash.
            MD5="${file:0:32}"
            if [[ ! $MD5 =~ ^[a-f0-9]{32}$ ]]
            then
                # Get the file extension.
                extension="${file##*.}"
                # Create a temporary filename.
                tmpfn="tmp.${extension}"
                # Print the filename in work to screen.
                echo "${file}"
                # Copy the file to the temporary file.
                cp "${file}" "${tmpfn}"
                # Strip all exif data from temporary file.
                modify_exifdata "${tmpfn}"
                # Get the md5 hash of the temporary file.
                HASH=$(md5sum "${tmpfn}" | awk '{print $1}')
                # Rename the temporary file using the md5 hash as filename.
                mv "${tmpfn}" "${HASH}"."${extension}"
                # Remove the not wanted original file.
                rm "${tmpfn}"_original
            fi
        done
    done
}

# ++++++++++++++++++++++++++++
# Call the man script function
# ++++++++++++++++++++++++++++
create_image

# Exit the script.
exit 0
