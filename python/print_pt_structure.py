#!/usr/bin/python3
'''Simple printout of .pt structure.'''
#
# Simple printout of .pt structure
# Version 0.0.0.2
# Copyright © 2024, Dr. Peter Netz
# Published under the MIT license.
# https://github.com/zentrocdot/artificial-intelligence-tools/blob/main/LICENSE

# Import standard Python modules.
import sys
import zipfile

# Get the argument from the command-line except the filename.
PT_FILE = sys.argv[1]

# Main script function.
def main(filename):
    '''Main script function.'''
    # Open file for reading.
    with zipfile.ZipFile(filename, mode="r") as archive:
        # Print file structure.
        archive.printdir()

# Execute as module as well as a program.
if __name__ == "__main__":
    # Call main function.
    main(PT_FILE)
