#!/usr/bin/python3
'''Read all available Tensors from model and convert them into images.'''
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
# Show a PIL image:
#     imgage.show()
#
# Remark:
# The script was checked using the linter pylint.

# Import all required modules.
import os
from PIL import Image
from torchvision.transforms import transforms
from safetensors import safe_open

# Set the filename.
FN="model.safetensors"

# Create an empty tensor.
tensors = {}

# Define a transform to convert a Torch tensor into a PIL image.
transform = transforms.ToPILImage()

# Initialise the count variable.
count = 0

# Initialise height and width.
h = 0
w = 0

# Set the file exension.
EXT = ".jpeg"

# Set the directory.
DIR = "./test/"

# Create directory.
if not os.path.exists(DIR):
    os.makedirs(DIR)

# Read tensor by tensor from file.
with safe_open(FN, framework="pt", device=0) as f:
    for k in f.keys():
        # Get the value to the given key.
        tensors[k] = f.get_tensor(k)
        # Try to create a PIL image.
        try:
            # Increment the counter.
            count += 1
            # Create an image.
            pilimage = transform(tensors[k])
            # Create a new filename.
            fn = DIR + str(count) + ".jpeg"
            # Get width and height.
            w, h = pilimage.size
            # Check if it is a sqaure image.
            if w == h:
                # Save the file.
                pilimage.save(fn,"JPEG")
                # Print the dimensions.
                print(h, w)
        except ValueError as err:
            pass
