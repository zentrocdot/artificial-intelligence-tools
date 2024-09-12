#!/usr/bin/python
''' Read and print data from .pt file.'''
#
# Version 0.0.0.2
# Copyright © 2024, Dr. Peter Netz
# Published under the MIT license.
# https://github.com/zentrocdot/artificial-intelligence-tools/blob/main/LICENSE
#
# pylint: disable=wrong-import-position
# pylint: disable=consider-using-sys-exit

# Import the standard Python module
import sys

# Import module.
import warnings

# Ignore (torch) future warning.
warnings.simplefilter(action='ignore', category=FutureWarning)

# Import module.
import torch

# Set the printout options.
torch.set_printoptions(threshold=10_000)

# Get the argument from the command-line except the filename.
PT_FILE = sys.argv[1]

# Main script function.
def main(filename):
    '''Main script function.'''
    # Get data.
    data=torch.load(filename)
    # Print data.
    print(data)

# Execute as module as well as a program.
if __name__ == "__main__":
    # Call main function.
    main(PT_FILE)
