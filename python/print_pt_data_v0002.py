#!/usr/bin/python
''' Structured reading and writing data from .pt file.'''
#
# Version 0.0.0.1
#
# pylint: disable=wrong-import-position
# pylint: disable=consider-using-sys-exit

# Import module.
import warnings

# Ignore (torch) future warning.
warnings.simplefilter(action='ignore', category=FutureWarning)

# Import the standard Python module
import sys

# Import the third party Python module.
import torch

# Set the printout options.
torch.set_printoptions(threshold=10_000)

# Get the argument from the command-line except the filename.
PT_FILE = sys.argv[1]

# Main script function.
def main(filename):
    '''Main script function'''
    # Load pt file into data.
    data = torch.load(filename)
    # Loop over key and value in dict.
    for param in data:
        # print key and value.
        print(param, data[param])

# Execute as module as well as a program.
if __name__ == "__main__":
    # Call main function.
    main(PT_FILE)
