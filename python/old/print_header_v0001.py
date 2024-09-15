#!/usr/bin/python3
'''Get and print the metadata of a given .safetensor file.'''
# pylint: disable=invalid-name
#
# Version 0.0.0.1
# Copyright © 2024, Dr. Peter Netz
# Published under the MIT license.
# https://github.com/zentrocdot/artificial-intelligence-tools/blob/main/LICENSE
#
# Safetensor file structure:
#   .safetensor -|
#                |- header |
#                          |- metadata
#                          |- pointer to the tensors
#                |- byte buffer (with the tensors)
#
# Description:
# Following the safetensor file structure the script is extracting the
# header data from the safetensor file. Afterwards this data is converted
# into JSON data. The JSON data is then printed oput in a pretty print
# format for analysis.
#
# Reference
# [1] https://github.com/huggingface/safetensors/blob/main/README.md

# Import the standard Python modules.
import sys
import json
import struct

# Get the argument from the command-line except the scriptname itself.
FILENAME = sys.argv[1]

# Set the indentation of the JSON data.
INDENT=4

# Create a lambda function for fast clearing the screen.
clear = lambda : print("\033[H\033[J", end="")

# Main script function.
def main(filename: str) -> None:
    '''Main script function.'''
    # Clear the terminal window.
    clear()
    # Open file for reading as binary.
    with open(filename, "rb") as f:
        # Get the length of the header.
        length_of_header = struct.unpack('<Q', f.read(8))[0]
        # Read the header data as bytes using the length of the header.
        header_data = f.read(length_of_header)
        # Create JSON data.
        header = json.loads(header_data)
    # Print structured JSON data into the terminal window.
    print(json.dumps(header, indent=INDENT))
    # Return None
    return None

# Execute the script either as a module or as a program.
if __name__ == "__main__":
    # Call the main function.
    main(FILENAME)
