#!/usr/bin/python3
'''Read all available Tensors from a model.'''
# pylint: disable=unused-import
#
# Version 0.0.0.1
# Copyright © 2024, Dr. Peter Netz
# Published under the MIT license.
# https://github.com/zentrocdot/artificial-intelligence-tools/blob/main/LICENSE
#
# pylint: disable=invalid-name
# pylint: disable=bare-except
#
# Remark
# The script was checked using the linter pylint.

# Import all required modules.
from safetensors import safe_open

# Set the filename.
FN="model.safetensors"

# Create an empty tensor.
tensors = {}

# Read tensor by tensor from file.
with safe_open(FN, framework="pt", device=0) as fn:
    for key in fn.keys():
        # Get the value to the given key.
        tensors[key] = fn.get_tensor(key)
        # Print the given key.
        print(key)
        # Print the value related to the key.
        print(tensors[key])
