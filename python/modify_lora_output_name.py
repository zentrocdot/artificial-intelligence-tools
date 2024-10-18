#!/usr/bin/python3
'''Update meta data.'''
# pylint: disable=line-too-long
# pylint: disable=useless-return
#
# Version 0.0.0.2
#
# Script is still experimental.
#
# Use the script on your own risk.
#
# Make backup of your data before using the script.
#
# SafeTensor .safetensior file structure:
#   .safetensor -|
#                |- header |
#                          |- metadata
#                          |- pointer to the tensors
#                |- byte buffer (with the tensors)
#
# MetaData structure:
#   {
#     "ss_output_name": "filename",
#     "ss_optimizer": "adamw",
#     "ss_learning_rate": "0.0001",
#     "ss_max_train_steps": "1000",
#     "ss_tag_frequency":
#     "{
#        "0": {"tag0": int0}
#        "1": {"tag1": int1}
#        "2": {"tag2": int2}
#     }"
#   }
#
# First 8 bytes as unsigned little-endian 64-bit integer containing the size of the header as n
# n bytes of header data in utf-8 encoded JSON format
# p bytes as padding in form of space characters (each 1 byte) up to the next 8 byte block (???)
# m bytes of tensor data
#
# Side Note on Structure:
# Header:   header size [in bytes] + padding size [in bytes]) % 8 == 0
# Metadata: metadata is saved in the header as JSON using the special key "__metadata__"
#
# Reference:
# [1] https://github.com/huggingface/safetensors

# Import the Python modules.
import json
import io
import os
import shutil

# From Python module typing import BinaryIO.
from typing import BinaryIO

# Set the filename without extension.
FN = "AppleBottle_v11"

# Set Extension.
EXT = ".safetensors"

# Assemble filename.
SRC = FN + EXT

# Set the backup name.
DST = FN + "_bak" + EXT

# Make a backup copy.
shutil.copyfile(SRC, DST)

# Create the filenames.
OLD_FILENAME = DST
NEW_FILENAME = SRC

# Set TAG. TAG must be the filename without extension.
TAG = FN

# ------------------------------------------------------------------------------
# Subroutine read_header_data()
# ------------------------------------------------------------------------------
def read_header_data(file: BinaryIO) -> dict:
    '''Read header data from a given file.

    Parameter:
        file:   file to read from as binary
        return: header data as dict from json
    '''
    # Read the header size saved as little endian from first 8 bytes of file.
    header_size_bytes = file.read(8)
    # Convert the read little endian bytes to an integer.
    header_size_integer = int.from_bytes(header_size_bytes, byteorder='little')
    # Read the header data.
    header_data = file.read(header_size_integer)
    # Create the JSON data.
    json_data = json.loads(header_data)
    # Return the JSON data as dict.
    return json_data

# ------------------------------------------------------------------------------
# Subroutine read_header_data()
# ------------------------------------------------------------------------------
def read_metadata(file_name: str) -> dict:
    """Read file to extract the metadata.

    Parameter:
        file_name: name of the file to be read
        return:    metadata as dict from json
    """
    def type_json(value):
        '''Return type of JSON substructure.'''
        try:
            return type(json.loads(value))
        except:
            pass
    # Create an empty dict.
    metadata = {}
    # Open binary file for radonly reading.
    with open(file_name, 'rb') as file:
        # Get the header data from the file.
        header_data = read_header_data(file)
    # Extract the metadata from the header.
    for key, value in header_data.get("__metadata__", {}).items():
        # Get value to key from metadata.
        metadata[key] = value
        # Check if value is of type string and if string is dict.
        if isinstance(value, str) and type_json(value) == dict:
            # Try to get the value as JSON data.
            try:
                metadata[key] = json.loads(value)
            except json.JSONDecodeError:
                pass
    # Return the metadata as dict.
    return metadata

# ------------------------------------------------------------------------------
# Subroutine write_metadata()
# ------------------------------------------------------------------------------
def write_metadata(old_file_name: str, new_file_name: str, metadata: dict):
    '''Creates a new .safetensor file from given and modified file content and
    writes it with the modified metadata into a new file.

    Parameter:
        old_file_name: name of the original file
        new_file_name: name of the modified file
        metadata:      metadata as dict
    '''
    # Open a binary file for readonly reading.
    with open(old_file_name, 'rb') as old_file:
        # Extract the header data and the header size from the given file.
        old_header_data = read_header_data(old_file)
        # Overwrite the metadata in the header.
        old_header_data['__metadata__'] = metadata
        # Convert modified header data back to a binary string.
        new_header_data = json.dumps(old_header_data, separators=(',', ':')).encode('utf-8')
        # Open a new file for writing.
        with open(new_file_name, 'wb') as new_file:
            # Calculate the new offset value.
            offset = len(new_header_data)
            # Write the new offset value into the file.
            new_file.write(offset.to_bytes(8, 'little'))
            # Write the new header data into file.
            new_file.write(new_header_data)
            # Calculate chunk size based on buffer size for wrtiting the tensor to file.
            chunk_size = io.DEFAULT_BUFFER_SIZE
            # Read first chunk data for writing.
            chunk = old_file.read(chunk_size)
            # Write chunk data to file as long there is data.
            while chunk:
                # Write chunk data to the file.
                new_file.write(chunk)
                # Read the next new chunk data.
                chunk = old_file.read(chunk_size)

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Main script function.
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def main(old_filename: str, new_filename: str, value: str) -> None:
    '''Main script function.'''
    # Set the keys.
    key0 = "ss_output_name"
    key1 = "ss_tag_frequency"
    # Read the metadata from a given file.
    metadata = read_metadata(old_filename)
    # Update one entry in the metadata.
    metadata.update({key0: value})
    # Get the value for key ss_tag_frequency.
    temp_value = metadata.get(key1)
    #temp_value = json.dumps(temp_value, separators=(',', ':'))
    temp_value = json.dumps(temp_value)
    # Update one entry in the metadata.
    metadata.update({key1:temp_value})
    print(metadata)
    # Write the new file.
    write_metadata(old_filename, new_filename, metadata)
    # Check if both files have the same size.
    print(os.path.getsize(old_filename))
    print(os.path.getsize(new_filename))
    # Return None
    return None

# Execute as module as well as a program.
if __name__ == "__main__":
    # Call the main function.
    main(OLD_FILENAME, NEW_FILENAME, TAG)
